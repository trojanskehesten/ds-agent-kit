# Codebase Navigation Trigger (Graphify)

Use the `graphify` skill proactively on non-trivial repositories to avoid brute-force file reading and save context tokens. Defer all CLI/MCP workflow details to `.agent/skills/graphify/SKILL.md`.

## Trigger Conditions

- **Existing Graph Artifacts:** If `graphify-out/graph.json` or `graphify-out/GRAPH_REPORT.md` is present in the workspace, activate the `graphify` skill and inspect those artifacts before running broad directory scans or greps.
- **Large Repository First Run:** When onboarding onto an unfamiliar repository, tracing cross-file dependencies, or performing impact analysis in a project without `graphify-out/` that has **more than ~30 source/notebook/doc files** (or **3+ top-level code modules/packages**), activate the `graphify` skill to build the initial graph first.
- **Verify Artifacts Before Acting:** Always inspect the generated `GRAPH_REPORT.md` / query outputs and verify critical or `INFERRED` relationships directly in the targeted source files before editing code or stating architectural conclusions.
- **Graceful Fallback:** If `graphify` is not installed in the environment, skip graph generation and fall back to targeted file search without blocking the task.
