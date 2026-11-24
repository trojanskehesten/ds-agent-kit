# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
