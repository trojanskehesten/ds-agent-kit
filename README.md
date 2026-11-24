# ds-agent-kit

Agent-agnostic, versioned collection of global rules, modular skills, and reference guides for Data Science and codebase navigation across AI coding agents (compatible with Markdown rules and the `SKILL.md` standard).

## Repository Structure

```text
ds-agent-kit/
├── .agent/
│   ├── rules/
│   │   ├── ds-standards.md
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
│   └── crit-prompting-ru.md
├── .gitignore
├── CHANGELOG.md
├── LICENSE
├── README.md
├── VERSION
└── install.ps1
```

## Included Rules, Skills & Docs

### Global Rules

- **`ds-standards.md`** — Baseline Data Science and Python engineering standards applied across projects:
  - **Language Policy:** All code comments, docstrings, Markdown cells, chart labels, and analytical reports in English.
  - **Python & Modularity:** PEP 8, 120-character max line length, `uv` for environment management, and extracting reusable/long blocks (>35–40 lines) from notebooks into `src/` or `utils/`.
  - **Data & Context Hygiene:** Prefer `parquet`, fix and log `random_seed`, document data fixes/assumptions, and keep `stdout` compact (`.head(3)`, never dumping raw tables).
- **`rtk-token-hygiene.md`** — Mandates prefixing supported CLI commands (`git`, `pytest`, `ruff`, `ls`, `grep`, etc.) with `rtk` (Rust Token Killer) to compress terminal output by 60–90%, with explicit raw-output exceptions and graceful fallback when `rtk` is unavailable.
- **`graphify-trigger.md`** — Lightweight trigger rule that activates the `graphify` skill automatically when `graphify-out/` exists or when exploring larger repositories (>30 files or 3+ code modules), and requires verifying graph findings in source files before editing.

### Skills

| Skill | Purpose |
| :--- | :--- |
| **`data-exploration-analysis`** | Structured 6-step workflow for rigorous EDA and hypothesis testing in Jupyter notebooks, with progressive reference guides for querying, statistical rigor, and `pltstat`/Plotly visualizations backed by mandatory `[AI_SUMMARY]` blocks. |
| **`notebook-report-synthesis`** | Compiles completed analysis notebooks into a single executive-ready Markdown report with strict numerical traceability, `[UNVERIFIED]` flagging, and cross-notebook contradiction reconciliation. |
| **`graphify`** | Standalone skill for building and querying structural knowledge graphs (`graphify-out/`) via the `graphify` CLI or MCP server to navigate unfamiliar codebases and trace dependencies without brute-force file reading. |

### Reference Docs (`docs/`)

Human-facing CRIT prompting cheat sheets ([EN](docs/crit-prompting-en.md) / [RU](docs/crit-prompting-ru.md)). Kept outside `.agent/` so agents do not auto-load them into context and `install.ps1` does not copy them into target projects.

---

## Installation

### 1. Global Installation (Windows / PowerShell Symlinks)

Linking rules and skills via symlinks keeps your global agent configuration automatically in sync with this repository. Pick your client's global config directory:

| Client | Global Config Directory | MCP Config File |
| :--- | :--- | :--- |
| **Antigravity / Gemini** | `~/.gemini/config/` | `~/.gemini/config/mcp_config.json` |
| **Claude Code** | `~/.claude/` | `~/.claude.json` |
| **Cursor** | `~/.cursor/` | `~/.cursor/mcp.json` |
| **Codex CLI** | `~/.codex/` | `~/.codex/config.toml` |

> **Note:** Creating symbolic links on Windows requires either **Developer Mode** enabled (`Settings -> System -> For developers`) or an **elevated (Administrator) PowerShell** session.

```powershell
$KitRoot     = (Get-Location).Path
$AgentConfig = Join-Path $env:USERPROFILE ".gemini\config"  # Adjust for your client from the table above

# Ensure target directories exist
New-Item -ItemType Directory -Path (Join-Path $AgentConfig "rules")  -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $AgentConfig "skills") -Force | Out-Null

# Symlink all global rules
Get-ChildItem -Path (Join-Path $KitRoot ".agent\rules") -Filter "*.md" | ForEach-Object {
    New-Item -ItemType SymbolicLink `
      -Path   (Join-Path $AgentConfig "rules\$($_.Name)") `
      -Target $_.FullName
}

# Symlink each skill directory
Get-ChildItem -Path (Join-Path $KitRoot ".agent\skills") -Directory | ForEach-Object {
    New-Item -ItemType SymbolicLink `
      -Path   (Join-Path $AgentConfig "skills\$($_.Name)") `
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

Verify installation and optionally register global agent hooks:

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
