# Terminal & Token Hygiene (RTK)

Use **`rtk`** (Rust Token Killer) as a mandatory CLI proxy for terminal commands to compress verbose command output and preserve context window budget.

## Mandatory Usage Rules

- **Prefix Supported Commands with `rtk`:** Whenever running high-output or routine shell commands, invoke them through `rtk`:
  - **Git:** `rtk git status`, `rtk git diff`, `rtk git log`, `rtk git commit`, `rtk git push`
  - **Testing & Linting:** `rtk pytest`, `rtk ruff check`, `rtk cargo test`, `rtk npm test`
  - **Files & Search:** `rtk ls`, `rtk find`, `rtk grep`, `rtk rg`
  - **Containers & Packages:** `rtk docker`, `rtk pip`
- **Explicit Exceptions:** Run the raw command without `rtk` only when uncompressed output is strictly required (e.g., piping machine-readable JSON/CSV to another tool or inspecting exact byte-level diffs).
- **Graceful Fallback:** If `rtk` is not installed in the current environment or rejects a specific subcommand/flag, fall back to the raw command immediately without retrying in a loop, and note that `rtk` was unavailable.
