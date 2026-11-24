# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
