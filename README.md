# ds-agent-kit

Versioned collection of global rules and modular skills for Data Science and codebase navigation in **Antigravity**.

## Repository Structure

```text
ds-agent-kit/
├── .agent/
│   ├── rules/
│   │   └── ds-standards.md
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
├── .gitignore
├── CHANGELOG.md
├── README.md
├── VERSION
└── install.ps1
```

## Included Rules & Skills

### Global Rule: `ds-standards.md`
Defines baseline Data Science and Python engineering standards applied across projects:
- **Language Policy:** All code comments, docstrings, Markdown cells, chart labels, and analytical reports in English.
- **Python & Modularity:** PEP 8, 120-character max line length, `uv` for environment management, and extracting reusable/long blocks (>35–40 lines) from notebooks into `src/` or `utils/`.
- **Data & Context Hygiene:** Prefer `parquet`, fix and log `random_seed`, document data fixes/assumptions, and keep `stdout` compact (`.head(3)`, never dumping raw tables).

### Skills

| Skill | Purpose |
| :--- | :--- |
| **`data-exploration-analysis`** | Structured 6-step workflow for rigorous EDA and hypothesis testing in Jupyter notebooks, with progressive reference guides for querying, statistical rigor, and `pltstat`/Plotly visualizations backed by mandatory `[AI_SUMMARY]` blocks. |
| **`notebook-report-synthesis`** | Compiles completed analysis notebooks into a single executive-ready Markdown report with strict numerical traceability, `[UNVERIFIED]` flagging, and cross-notebook contradiction reconciliation. |
| **`graphify`** | Standalone skill for building and querying structural knowledge graphs (`graphify-out/`) via the `graphify` CLI or MCP server to navigate unfamiliar codebases and trace dependencies without brute-force file reading. |

---

## Installation

### 1. Global Installation in Antigravity (Windows / PowerShell Symlinks)

Antigravity discovers global customizations under `$env:USERPROFILE\.gemini\config\`. Linking via symlinks keeps your global setup automatically in sync with this repository.

> **Note:** Creating symbolic links on Windows requires either **Developer Mode** enabled (`Settings -> System -> For developers`) or an **elevated (Administrator) PowerShell** session.

```powershell
$KitRoot   = "C:\Users\forth\Documents\ds-agent-kit"
$AgyConfig = Join-Path $env:USERPROFILE ".gemini\config"

# Ensure target directories exist
New-Item -ItemType Directory -Path (Join-Path $AgyConfig "rules")  -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $AgyConfig "skills") -Force | Out-Null

# Symlink global rule
New-Item -ItemType SymbolicLink `
  -Path   (Join-Path $AgyConfig "rules\ds-standards.md") `
  -Target (Join-Path $KitRoot ".agent\rules\ds-standards.md")

# Symlink each skill directory
Get-ChildItem -Path (Join-Path $KitRoot ".agent\skills") -Directory | ForEach-Object {
    New-Item -ItemType SymbolicLink `
      -Path   (Join-Path $AgyConfig "skills\$($_.Name)") `
      -Target $_.FullName
}
```

### 2. Local Installation into a Project

Use `install.ps1` to copy `.agent/` into a specific project workspace. The script prints the version from `VERSION` and warns before overwriting any existing files:

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

To expose `graphify-out/graph.json` as native MCP tools in Antigravity, add the `graphify` entry from [`.agent/skills/graphify/mcp_config.example.json`](.agent/skills/graphify/mcp_config.example.json) to your global `~/.gemini/config/mcp_config.json`:

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

---

## Versioning Policy

This repository follows [Semantic Versioning](https://semver.org/) tracked in [`VERSION`](VERSION) and documented in [`CHANGELOG.md`](CHANGELOG.md):

- **`MAJOR`** — Breaking changes to repository layout, rule contracts, or skill interfaces.
- **`MINOR`** — New skills, new rule sections, or backward-compatible workflow additions.
- **`PATCH`** — Wording refinements, documentation updates, and bug fixes.
