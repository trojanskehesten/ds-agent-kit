# Connecting an AI Agent to JupyterLab and VS Code (via MCP)

> **Check your agent's native capabilities before installing.** The setup below works reliably, but it is only needed if your AI agent cannot natively edit cells and execute code against a live notebook kernel (or if its built-in tools fall short for your workflow). Many modern tools — such as **GitHub Copilot**, **Claude Code** (paired with VS Code via `NotebookEdit` + `executeCode` with execution confirmation), and **Cortex Code** — already cover these workflows out of the box.

## Why This Setup Exists and What Problem It Solves

Having an AI agent edit raw `.ipynb` files directly on disk quickly becomes awkward and expensive for three reasons:

1. **Token waste and format fragility.** An `.ipynb` file is raw JSON containing metadata, escaped strings, and embedded cell outputs. Just a couple of `base64`-encoded charts or wide HTML tables inside a notebook can easily burn tens of thousands of tokens on every read, and any small editing mistake breaks the JSON structure.
2. **Blindness to the live kernel.** When editing a file on disk, the agent cannot run cells on its own, cannot inspect variables in memory (RAM), and cannot read `stdout` or `traceback` from your active session — forcing you to copy and paste errors and outputs into chat manually.
3. **Browser sync conflicts.** By default, JupyterLab does not pick up external file modifications in real time: you either have to click `Reload` constantly or deal with `Overwrite` conflict dialogs.

Connecting **`jupyter-mcp-server`** solves the first two problems: the agent gets direct access to the live kernel and individual cells without reading raw JSON. *(Keep in mind that MCP tool schemas themselves consume a noticeable amount of context, so token savings are most pronounced on heavy notebooks with outputs and plots rather than small, clean files.)* For the MCP server's cell-level API (reading and editing cells) to work in both scenarios, the server side also requires the **`jupyter-collaboration`** extension, which additionally provides real-time UI synchronization in JupyterLab.

## Prerequisites

1. **Install `uv` globally** (so the `uvx` command is available to your MCP client from any environment, not just inside an activated `.venv`):
   * Windows: `winget install astral-sh.uv`
   * macOS / Linux: `curl -LsSf https://astral.sh/uv/install.sh | sh`

   *(Restart your terminal and IDE after installation so `PATH` is refreshed.)*

2. **Add `jupyter-collaboration` runtime artifacts to `.gitignore`:**
   ```gitignore
   .jupyter_ystore.db*
   .jupyter/
   ```

## Scenario 1 (Primary): Working with Notebooks in the Browser (JupyterLab)

1. **Activate `.venv` and install the packages:**
   ```bash
   uv pip install jupyterlab jupyter-collaboration jupyter-mcp-tools ipykernel
   ```
   *(If your environment was created without `uv`, use `pip install ...`. The `jupyter-mcp-tools` package is an optional extension that adds JupyterLab-level commands such as running all cells.)*

2. **Start JupyterLab in a separate terminal from the project root:**
   ```bash
   jupyter lab --port 8888 --IdentityProvider.token YOUR_RANDOM_TOKEN
   ```

3. **Configure the MCP server** in your AI agent's settings and reload the client (see the section below).

4. **Open the notebook tab in JupyterLab and connect the agent:**
   Once the notebook is open in the browser, it already has a live session. You do not need to look up `kernel_id` manually — simply ask the agent in your prompt:
   > Connect via `use_notebook` to `<notebook_path_from_project_root>`.

   The MCP server will automatically attach to the open tab's live kernel, and all agent edits will appear in the JupyterLab UI in real time.

## Scenario 2: Working with Notebooks Inside an IDE (VS Code and Compatible Editors)

> **Important:** Use this scenario if you want to work with a notebook directly inside the editor in IDEs/agents without native integration with the editor's notebook kernel (for example, in **Antigravity**, **Cursor**, **Codex**, and other MCP clients), or when the agent's built-in tools are insufficient for autonomous notebook work.

1. **Activate `.venv` and install the packages:**
   ```bash
   uv pip install jupyter-server jupyter-collaboration ipykernel
   ```
   *(If your environment was created without `uv`, use `pip install ...`. Here `jupyter-collaboration` is required not for the editor UI, but for the MCP server's cell operations — without it, reading and executing cells fail with `404`, although `execute_code` still works.)*

2. **Start a local Jupyter server in a separate terminal from the project root:**
   ```bash
   jupyter server --no-browser --port 8888 --IdentityProvider.token YOUR_RANDOM_TOKEN
   ```

3. **Configure the MCP server** in your AI agent's settings and reload the IDE window / MCP client (see the section below).

4. **Attach the notebook in your editor to the running server:**
   * Open the `.ipynb` file in VS Code (or a compatible IDE).
   * In the top-right corner of the notebook, click **Select Kernel → Select Another Kernel... → Existing Jupyter Server...**.
   * Paste `http://localhost:8888/?token=YOUR_RANDOM_TOKEN`, press `Enter`, and select your `.venv` kernel (typically shown as `Python 3 (ipykernel)`).

5. **Pass `kernel_id` to the agent for shared memory:**
   The VS Code Jupyter extension creates a session under a synthetic path like `name-jvsc-<uuid>.ipynb`, so the MCP server cannot automatically match it to your file on disk and would otherwise attach to a different kernel. To connect the agent to your exact kernel, run this cell in the notebook:
   ```python
   import ipykernel; print(ipykernel.get_connection_file())
   ```
   Copy the ID from `kernel-<id>.json` and include it in your first prompt to the agent:
   > Connect via `use_notebook` to `<notebook_path_from_project_root>` with `kernel_id=<id>`.

   *(Whenever you switch kernels, reload the window, or reconnect, fetch `kernel_id` again — it may have changed.)*

> **VS Code caveat:** The editor saves notebooks directly to disk rather than through the collaboration protocol, so enable auto-save (`files.autoSave`) and avoid editing cells at the same time as the agent to prevent overwriting each other's changes.

## MCP Server Configuration and Verification (Shared Across Both Scenarios)

1. **Add the `jupyter` server to your AI agent or IDE MCP configuration:**
   Baseline JSON format:
   ```json
   {
     "mcpServers": {
       "jupyter": {
         "command": "uvx",
         "args": ["jupyter-mcp-server@latest"],
         "env": {
           "JUPYTER_URL": "http://localhost:8888",
           "JUPYTER_TOKEN": "YOUR_RANDOM_TOKEN",
           "ALLOW_IMG_OUTPUT": "false"
         }
       }
     }
   }
   ```
   * The exact file path and schema depend on your client (for example, `mcpServers` in Claude Code / Cursor / Antigravity, `servers` with `"type": "stdio"` in `.vscode/mcp.json`, or a `[mcp_servers.jupyter]` TOML section in Codex).
   * Replace `YOUR_RANDOM_TOKEN` with your own random token, do not expose the server externally (`--ip 0.0.0.0`) unless necessary, and never commit a local MCP config containing a hardcoded token to Git (in clients that support environment variable interpolation, such as Claude Code, use `${JUPYTER_TOKEN}`).
   * Setting `ALLOW_IMG_OUTPUT: "false"` prevents plot images from being sent back to the agent — this saves tokens, though the agent will not see rendered charts visually.
   * For reproducible setups, you can pin a specific tested version instead of `@latest` (for example, `jupyter-mcp-server==2.2.6`).

2. **Reload the IDE window or restart your MCP client** and verify that the `jupyter` server connects without errors.

3. **Quick shared-memory check:** Run a cell in the notebook (without printing the variable):
   ```python
   import secrets; probe = secrets.token_hex(4)
   ```
   Ask the agent (after `use_notebook`) to run `print(probe)` via `execute_code`, and then run `print(probe)` in the notebook yourself. If both values match, the server, `jupyter-collaboration`, and shared memory are configured properly (a `NameError` means the agent attached to a different kernel).

> **Important workflow rule:** While a notebook is connected via MCP, the agent must create and edit cells **exclusively** through MCP tools (`insert_cell`, `edit_cell_source`, `overwrite_cell_source`, etc.), never through standard file-editing tools (`edit_file` or writing directly to `.ipynb` on disk) — otherwise `jupyter-collaboration` will overwrite or ignore external file changes and go out of sync.

## Alternative: `jupytext`

Choose **`jupytext`** (in JupyterLab, ideally still paired with `jupyter-collaboration`; in VS Code, you can run `.py` files with `# %%` cell markers directly via the built-in Interactive Window) when you want strict manual control over code execution, clean Git diffs, and minimal token usage — for example, during refactoring, code review, or heavy pipelines where you do not want the agent re-running cells on its own.

* **Pros:** Minimal context footprint (the agent works with plain `.py` files free of JSON markup, `base64` plots, and MCP tool schemas), clean Git history, and zero MCP setup.
* **Cons:** The agent has no access to the live kernel or in-memory session variables (it can only run scripts separately in a terminal), and in browser-based JupyterLab without `jupyter-collaboration` you must manually reload the notebook from disk.
