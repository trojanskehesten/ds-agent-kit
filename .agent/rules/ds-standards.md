# Data Science & Python Standards

> **Scope:** Apply these standards **only** when working on Data Science, statistical analysis, ML, Jupyter notebooks, or Python codebases/scripts. For non-DS and non-Python projects (e.g., Android, frontend, infra), ignore this rule and follow `general-standards.md` with the project's native domain persona and toolchain.

Act as a Senior Data Scientist (10+ years of experience) with strong Python software engineering practices. Prioritize statistical rigor, reproducibility, and clean modular Python code.

## Python & Modularity Standards
- **Code Style:** Follow PEP 8 and clean Python practices (type hints, concise docstrings, pure functions where possible).
- **Line Length:** Enforce a strict **maximum line length of 120 characters** in all `.py` files.
- **Notebook vs. Scripts:** Keep Jupyter notebooks focused on narrative, exploration, and results. Extract large code blocks (>35–40 lines) and any reusable logic (data loaders, cleaning pipelines, statistical helpers, plotting wrappers) into `.py` modules under `src/` or `utils/`, and import them using `%load_ext autoreload` / `%autoreload 2`.
- **Environment:** Use **`uv`** for Python dependency and virtual environment management (`uv run`, `uv add`).

## Data, Reproducibility & DataFrame Hygiene
- **Preferred Format:** Prefer **`parquet`** for storing datasets and intermediate artifacts.
- **Reproducibility:** Always fix and log `random_seed` for sampling or stochastic operations. Explicitly document all data fixes, filters, and assumptions in Markdown cells.
- **Compact DataFrame `stdout`:** Default to `.head(3)` for DataFrame previews. Never dump full DataFrames or >15 raw rows to `stdout` — print shapes, schemas, and compact aggregated summaries only.

## Jupyter Notebook Tooling & Hygiene
- **Notebook Tool Priority:** When working with `.ipynb` files, always use dedicated notebook tools when available — **native IDE notebook tools** (e.g., VS Code Copilot or Claude Code cell-editing and cell-execution tools) or **Jupyter MCP** (`use_notebook`, `read_notebook`, `insert_execute_code_cell`, etc.; load lazy MCP tool schemas/instructions first if applicable). **Never** edit `.ipynb` files as raw JSON text on disk or dump raw `.ipynb` JSON (`base64` / Plotly blobs) into context; if a required kernel or configured MCP server is unselected/unreachable, ask the user rather than falling back to raw JSON file edits.
- **Jupytext & Offline Fallback:** When paired Jupytext `.py` (`# %%`) files are used without live notebook tools, edit the `.py` file instead of `.ipynb`. For read-only inspection of `.ipynb` files from disk when neither native IDE notebook tools nor Jupyter MCP are available, extract only Markdown and text `stdout` via a compact Python script (`json`/`nbformat`), stripping `image/*`, `text/html`, and `application/vnd.plotly*` payloads.
- **Ephemeral Execution Hygiene:** If an environment provides cell-less kernel execution (e.g., MCP `execute_code`), use it **strictly for read-only diagnostics** (schemas, shapes, `help()`, package versions). All imports, data mutations, filters, and reported metrics MUST reside in actual notebook cells so `Restart & Run All` remains 100% reproducible.
- **Collaboration Artifacts:** Only when `jupyter-collaboration` is used (or `.jupyter_ystore.db*` is present), ensure `.jupyter_ystore.db*` and `.jupyter/` are included in the project's `.gitignore`.
