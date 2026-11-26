# ds-agent-kit

Opinionated, versioned collection of personal rules, modular skills (`SKILL.md`), and reference guides for Data Science, Python, and codebase navigation. Built natively around the `.agent/` layout (Antigravity / Gemini-based agents) with portable Markdown rules and skills adaptable to other AI coding agents.

## Repository Structure

```text
ds-agent-kit/
├── .agent/
│   ├── rules/
│   │   ├── ds-standards.md
│   │   ├── general-standards.md
│   │   ├── graphify-trigger.md
│   │   └── rtk-token-hygiene.md
│   └── skills/
│       ├── data-exploration-analysis/
│       │   ├── SKILL.md
│       │   └── references/
│       │       ├── data-analysis-techniques.md
│       │       ├── data-query-guide.md
│       │       └── data-visualization-guide.md
│       ├── graphify/
│       │   ├── SKILL.md
│       │   └── mcp_config.example.json
│       └── notebook-report-synthesis/
│           ├── SKILL.md
│           └── references/
│               └── report-template.md
├── docs/
│   ├── crit-prompting-en.md
│   ├── crit-prompting-ru.md
│   ├── jupyter-mcp-setup-en.md
│   └── jupyter-mcp-setup-ru.md
├── .gitignore
├── CHANGELOG.md
├── LICENSE
├── README.md
├── VERSION
└── install.ps1
```

## Included Rules, Skills & Docs

### Global Rules

- **`general-standards.md`** — Universal baseline across all projects and languages: English-only code/docs/reports, modular code quality, concise evidence-based communication, compact `stdout`, and using the native domain persona/toolchain for non-DS projects.
- **`ds-standards.md`** — Scoped **only** to Data Science, ML, Jupyter notebooks, and Python projects/scripts:
  - **Role & Style:** Senior Data Scientist persona, PEP 8, type hints, 120-character max line length, `uv` for Python environments, and extracting reusable/long blocks (>35–40 lines) from notebooks into `src/` or `utils/`.
  - **Data & Reproducibility:** Prefer `parquet`, fix and log `random_seed`, document data fixes/assumptions, and keep DataFrame `stdout` compact (`.head(3)`, never dumping raw tables).
- **`rtk-token-hygiene.md`** — Mandates prefixing supported CLI commands (`git`, `pytest`, `ruff`, `ls`, `grep`, etc.) with `rtk` (Rust Token Killer) to compress terminal output by 60–90%, with explicit raw-output exceptions and graceful fallback when `rtk` is unavailable.
- **`graphify-trigger.md`** — Lightweight trigger rule that activates the `graphify` skill automatically when `graphify-out/` exists or when exploring larger repositories (>30 files or 3+ code modules), and requires verifying graph findings in source files before editing.

### Skills

| Skill | Purpose |
| :--- | :--- |
| **`data-exploration-analysis`** | Structured 6-step workflow for rigorous EDA and hypothesis testing in Jupyter notebooks, with progressive reference guides for querying, statistical rigor, and `pltstat`/Plotly visualizations backed by mandatory `[AI_SUMMARY]` blocks. |
| **`notebook-report-synthesis`** | Compiles completed analysis notebooks into a single executive-ready Markdown report with strict numerical traceability, `[UNVERIFIED]` flagging, and cross-notebook contradiction reconciliation. |
| **`graphify`** | Standalone skill for building and querying structural knowledge graphs (`graphify-out/`) via the `graphify` CLI or MCP server to navigate unfamiliar codebases and trace dependencies without brute-force file reading. |

### Reference Docs (`docs/`)

Human-facing guides kept outside `.agent/` so agents do not auto-load them into context and `install.ps1` does not copy them into target projects:

- **CRIT Prompting Cheat Sheet** ([EN](docs/crit-prompting-en.md) / [RU](docs/crit-prompting-ru.md)) — Meta-layer hypothesis discovery and structured CRIT prompting templates for agentic EDA.
- **Jupyter MCP Setup Guide** ([EN](docs/jupyter-mcp-setup-en.md) / [RU](docs/jupyter-mcp-setup-ru.md)) — Connecting AI coding agents to live JupyterLab and VS Code notebook kernels via `jupyter-mcp-server` and `jupyter-collaboration` (plus `jupytext` trade-offs).

---

## Installation

### 1. Global Installation (Windows / PowerShell Symlinks)

The `.agent/rules/*.md` + `.agent/skills/` layout is natively discovered by **Antigravity** (`~/.gemini/config/`). Other AI coding agents use different rule/skill paths, so adapt the mapping to your client:

| Client | Global Rules | Global Skills | MCP Config File |
| :--- | :--- | :--- | :--- |
| **Antigravity / Gemini** | `~/.gemini/config/rules/*.md` | `~/.gemini/config/skills/` | `~/.gemini/config/mcp_config.json` |
| **Claude Code** | `~/.claude/CLAUDE.md` *(include/merge)* | `~/.claude/skills/` | `~/.claude.json` |
| **Cursor** | User Rules *(UI)* / project `.cursor/rules/*.mdc` | Project / custom docs | `~/.cursor/mcp.json` |
| **Codex CLI** | `~/.codex/AGENTS.md` *(include/merge)* | `~/.codex/skills/` | `~/.codex/config.toml` |

> **Note:** Creating symbolic links on Windows requires either **Developer Mode** enabled (`Settings -> System -> For developers`) or an **elevated (Administrator) PowerShell** session.

Example PowerShell symlink setup for **Antigravity / Gemini** (`~/.gemini/config/`):

```powershell
$KitRoot     = (Get-Location).Path
$AgentConfig = Join-Path $env:USERPROFILE ".gemini\config"

# Ensure target directories exist
New-Item -ItemType Directory -Path (Join-Path $AgentConfig "rules")  -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $AgentConfig "skills") -Force | Out-Null

# Symlink all global rules (idempotent: -Force updates existing links)
Get-ChildItem -Path (Join-Path $KitRoot ".agent\rules") -Filter "*.md" | ForEach-Object {
    New-Item -ItemType SymbolicLink -Force `
      -Path   (Join-Path $AgentConfig "rules\$($_.Name)") `
      -Target $_.FullName | Out-Null
}

# Symlink each skill directory
Get-ChildItem -Path (Join-Path $KitRoot ".agent\skills") -Directory | ForEach-Object {
    New-Item -ItemType SymbolicLink -Force `
      -Path   (Join-Path $AgentConfig "skills\$($_.Name)") `
      -Target $_.FullName | Out-Null
}
```

### 2. Local Installation into a Project

On Windows (PowerShell), use `install.ps1` to copy `.agent/` into a specific project workspace. The script prints the version from `VERSION` and warns before overwriting any existing files *(on macOS/Linux, copy `.agent/` directly with `cp -r .agent /path/to/your-project/`)*.

```powershell
.\install.ps1 -TargetProject "C:\path\to\your-project"
```

Pass `-Force` to overwrite existing files without prompting:

```powershell
.\install.ps1 -TargetProject "C:\path\to\your-project" -Force
```

### 3. Installing `graphify` (CLI & Optional MCP Server)

The `graphify` skill only stores agent instructions and an example config; install the `graphifyy` Python package separately:

```powershell
# Recommended: install via uv with MCP support
uv tool install "graphifyy[mcp]"

# Or without MCP (CLI only)
uv tool install graphifyy

# Alternative: install via pip
pip install "graphifyy[mcp]"
```

Verify installation:

```powershell
graphify --help
```

#### Connecting the Graphify MCP Server (Optional)

To expose `graphify-out/graph.json` as native MCP tools, add the `graphify` entry from [`.agent/skills/graphify/mcp_config.example.json`](.agent/skills/graphify/mcp_config.example.json) to your client's MCP configuration file (see the table above):

```json
{
  "mcpServers": {
    "graphify": {
      "command": "graphify-mcp",
      "args": [
        "--graph",
        "graphify-out/graph.json"
      ]
    }
  }
}
```

*(Alternatively, you can launch the stdio server via `python -m graphify.serve graphify-out/graph.json`.)*

### 4. Installing `rtk` (Rust Token Killer)

The [`rtk-token-hygiene.md`](.agent/rules/rtk-token-hygiene.md) rule expects [`rtk`](https://github.com/rtk-ai/rtk) to be installed on your `PATH` to compress CLI output:

```powershell
# Recommended on Windows via winget
winget install rtk-ai.rtk

# Alternative: install from GitHub via Cargo (do NOT run plain `cargo install rtk`)
cargo install --git https://github.com/rtk-ai/rtk --branch master rtk
```

Verify installation, and optionally register global agent hooks (hooks auto-rewrite commands and are optional — `rtk-token-hygiene.md` works without them):

```powershell
rtk --version
rtk gain
rtk init -g
```

---

## Versioning Policy

This repository follows [Semantic Versioning](https://semver.org/) tracked in [`VERSION`](VERSION) and documented in [`CHANGELOG.md`](CHANGELOG.md):

- **`MAJOR`** — Breaking changes to repository layout, rule contracts, or skill interfaces.
- **`MINOR`** — New skills, new rule sections, or backward-compatible workflow additions.
- **`PATCH`** — Wording refinements, documentation updates, and bug fixes.

## License

Licensed under the [MIT License](LICENSE).

## Credits & References

- **CRIT Prompting Framework:** Geoff Woods (*The AI-Driven Leader*) and DataCamp (*"How to Do Agentic Data Analysis"*).
- **Agentic DS Architecture (CodeAct & Skills pattern):** Roberto Rodriguez (NDC talk).
- **`pltstat`:** <https://pypi.org/project/pltstat/>
- **`graphify`:** <https://pypi.org/project/graphifyy/> ([Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify))
- **`rtk` (Rust Token Killer):** <https://github.com/rtk-ai/rtk>
