# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.5.0] - 2026-11-26

### Added
- `Jupyter Notebook Tooling & Hygiene` section in `.agent/rules/ds-standards.md` defining a portable tool priority (native IDE notebook tools / Jupyter MCP over raw `.ipynb` JSON), read-only discipline for cell-less `execute_code`, token-safe offline `.ipynb` inspection, and `.gitignore` hygiene for `jupyter-collaboration` artifacts.
- Standalone `Live Notebook Execution` reminder in `.agent/skills/data-exploration-analysis/SKILL.md` and `Token-Safe .ipynb Reading` guidance in `.agent/skills/notebook-report-synthesis/SKILL.md` to prevent dumping `base64`/Plotly JSON blobs into context when reading notebooks offline.

### Changed
- Added `.jupyter/` and `.jupyter_ystore.db*` to `.gitignore` and updated `README.md` to reflect the new `ds-standards.md` notebook tooling rules.

## [1.4.4] - 2026-11-26

### Added
- Human-facing Jupyter MCP setup guides in `docs/jupyter-mcp-setup-en.md` and `docs/jupyter-mcp-setup-ru.md` covering live kernel integration for JupyterLab and VS Code via `jupyter-mcp-server` and `jupyter-collaboration` (plus `jupytext` trade-offs), linked from `README.md`.

## [1.4.3] - 2026-11-25

### Changed
- Replaced `docs/crit-prompting-en.md` and `docs/crit-prompting-ru.md` with the complete CRIT prompting & agentic Data Science reference guides.

## [1.4.2] - 2026-11-25

### Fixed
- Replaced hardcoded `.agent/skills/graphify/SKILL.md` path in `.agent/rules/graphify-trigger.md` with skill-name reference for global/multi-client portability.
- Instructed the `graphify` skill to add `graphify-out/` to the target repository's `.gitignore` if missing.
- Made the PowerShell global symlink snippet in `README.md` idempotent (`-Force`) and clarified that `rtk init -g` hooks are optional alongside `rtk-token-hygiene.md`.
- Prevented `install.ps1` from hanging on `Read-Host` in non-interactive sessions by failing cleanly with an instruction to pass `-Force`.

## [1.4.1] - 2026-11-25

### Changed
- Specified `pltstat >= 0.11` as the minimum version for Plotly backend support in `.agent/skills/data-exploration-analysis/SKILL.md` and `references/data-visualization-guide.md`, with fallback to plain Plotly (or matplotlib/seaborn) when an older version is installed.

## [1.4.0] - 2026-11-24

### Added
- Language-agnostic global rule `.agent/rules/general-standards.md` covering English artifacts, modular engineering habits, and compact diagnostic output across all project types.

### Changed
- Scoped `.agent/rules/ds-standards.md` strictly to Data Science, ML, Jupyter notebooks, and Python codebases/scripts so it does not interfere with non-Python/non-DS projects (e.g., Android).
- Updated `README.md` to reflect the split rules and clarify that this is an opinionated personal kit.

## [1.3.1] - 2026-11-24

### Fixed
- Corrected multiple-testing guidance in `.agent/skills/data-exploration-analysis/references/data-analysis-techniques.md`: reserve Bonferroni for cases where $m$ is fixed in advance and adjusted p-values are needed before remaining p-values are computed; use Holm (FWER) or Benjamini-Hochberg (FDR) once all p-values are available.
- Fixed `[AI_SUMMARY]` example in `.agent/skills/data-exploration-analysis/references/data-visualization-guide.md` to separate descriptive median difference from Mann-Whitney U (stochastic dominance + rank-biserial `r`).
- Clarified client-specific rule/skill paths and `.agent/` native compatibility in `README.md` (removed overstated "agent-agnostic" framing and noted macOS/Linux `cp -r` fallback alongside `install.ps1`).

## [1.3.0] - 2026-11-24

### Added
- Human-facing CRIT prompting cheat sheets in `docs/crit-prompting-en.md` and `docs/crit-prompting-ru.md` (kept outside `.agent/` and excluded from `install.ps1`), including source references.
- Multi-client global configuration path table and `Credits & References` section in `README.md`.

### Changed
- Made `README.md` agent-agnostic rather than tied to a single AI coding client.

## [1.2.1] - 2026-11-24

### Changed
- Refined `Graceful Fallback` in `.agent/rules/rtk-token-hygiene.md` so the agent explicitly notifies the user in chat when `rtk` is missing and asks once per session whether to install it.

## [1.2.0] - 2026-11-24

### Added
- Lightweight global trigger rule (`.agent/rules/graphify-trigger.md`) instructing the agent to activate the `graphify` skill when `graphify-out/` exists or when exploring larger repositories (>30 files or 3+ modules), and to verify graph artifacts before acting.

## [1.1.0] - 2026-11-24

### Added
- Global terminal token-hygiene rule (`.agent/rules/rtk-token-hygiene.md`) mandating `rtk` (Rust Token Killer) as a CLI proxy for supported commands with graceful fallback.
- Installation and verification instructions for `rtk` on Windows in `README.md`.
- MIT `LICENSE`.

### Changed
- Updated PowerShell global symlink instructions in `README.md` to link all `.agent/rules/*.md` files automatically.

## [1.0.0] - 2026-11-24

### Added
- Global Data Science and Python standards rule (`.agent/rules/ds-standards.md`).
- `data-exploration-analysis` skill with progressive reference guides (`data-query-guide.md`, `data-analysis-techniques.md`, `data-visualization-guide.md`).
- `notebook-report-synthesis` skill with a structured report template (`report-template.md`).
- Standalone `graphify` skill (`.agent/skills/graphify/SKILL.md`) with an example MCP server configuration (`mcp_config.example.json`).
- PowerShell installer (`install.ps1`) for copying `.agent/` into target projects with overwrite protection and version reporting.
- Repository documentation (`README.md`), semantic version file (`VERSION`), and `.gitignore`.
