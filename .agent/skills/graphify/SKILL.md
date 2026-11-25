---
name: graphify
description: Build and query structural knowledge graphs of codebases, notebooks, and documents using Graphify. Use when onboarding onto an unfamiliar repository, tracing cross-file dependencies, performing impact analysis, or navigating large projects without brute-force file reading.
metadata:
  short-description: Structural codebase and document navigation via Graphify knowledge graphs
---

# Graphify Knowledge Graph Navigation

Use the `graphify` CLI (package `graphifyy`) or its MCP server to inspect repository architecture, dependencies, and concept clusters before performing broad file reads or greps.

## Core Rules

- **Graph First, Raw Files Second:** When a repository has `graphify-out/`, consult `GRAPH_REPORT.md` and query `graph.json` before scanning raw source files.
- **Check Before Rebuilding:** Reuse an existing `graphify-out/graph.json` if it is up to date. Rebuild only when missing or when significant structural changes occurred.
- **Distinguish Edge Confidence:** Treat AST-derived `EXTRACTED` edges as deterministic facts and semantic `INFERRED` edges as hypotheses to verify directly in source code.
- **Keep Artifacts Local:** Never commit `graphify-out/` or generated graph files into version control — add `graphify-out/` to the target repository's `.gitignore` if missing.

## Workflow

### Step 1: Check Existing Graph Artifacts

Check whether `graphify-out/graph.json` and `graphify-out/GRAPH_REPORT.md` already exist in the target repository.

- If present and current, skip directly to **Step 3**.
- If absent or stale, proceed to **Step 2**.

### Step 2: Build or Update the Graph

Verify that `graphify` is available in the environment (`graphify --help`), then generate or refresh the knowledge graph:

```bash
# Build or incrementally update the graph for the current repository
graphify .
```

If `graphify` is not installed, inform the user to install `graphifyy` (or `graphifyy[mcp]` for MCP support) and fall back to targeted file search.

### Step 3: Query the Architecture

Use either the connected **Graphify MCP server** tools (preferred when configured; see `mcp_config.example.json`) or the CLI:

1. **High-level map:** Read `graphify-out/GRAPH_REPORT.md` to identify core modules, communities, and high-connectivity ("god") nodes.
2. **Targeted queries:**
   ```bash
   # Ask an architectural or relationship question
   graphify query "How does data ingestion connect to feature engineering?"

   # Trace the shortest dependency path between two nodes
   graphify path "<node-a>" "<node-b>"

   # Inspect a specific node's degree, community, and neighbors
   graphify explain "<node>"
   ```

### Step 4: Verify in Source Code

- Open only the specific files and line ranges surfaced by the graph to confirm implementation details before making edits or drawing conclusions.
- Re-run `graphify .` after major structural refactors if further graph-assisted exploration is needed.
