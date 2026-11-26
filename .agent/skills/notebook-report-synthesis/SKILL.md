---
name: notebook-report-synthesis
description: Synthesize analytical findings, statistical results, and key caveats from multiple Jupyter notebooks into a single, executive-ready Markdown report. Use when analysis notebooks are complete and you need a unified project summary document with full numerical traceability.
metadata:
  short-description: Compile findings from multiple notebooks into a unified analytical report
---

# Notebook Report Synthesis

Follow the global standards in `ds-standards.md` and compile completed exploratory and analytical notebooks into a cohesive, defensible summary report.

## Core Rules

- **Evidence-Only Extraction:** Extract metrics strictly from Markdown conclusions, printed `stdout` outputs, and `[AI_SUMMARY]` blocks (if present). NEVER inspect raw `base64` image strings or invent numbers not present in outputs.
- **Fallback When `[AI_SUMMARY]` Is Absent:** If a notebook does not contain `[AI_SUMMARY]` blocks, rely strictly on printed tables, test outputs, and verified text metrics in `stdout`. If a conclusion rests only on an unquantified chart with no printed numbers, mark it `[UNVERIFIED]` instead of guessing from the image.
- **Flag Unverified Claims:** If a notebook's Markdown states a conclusion without supporting numerical output, explicitly mark it as `[UNVERIFIED]` instead of presenting it as fact.
- **Reconcile Contradictions:** Never silently pick one number when two notebooks disagree (e.g., different `n`, filters, or updated cleaning logic). Explicitly report the discrepancy and note which notebook is more recent or authoritative.
- **Traceability:** Link every key finding to its source notebook and section or `plot_id` (if present), e.g., `[02_cohort_analysis.ipynb | Section 2.1]`.
- **Progressive References:** Read `references/report-template.md` ONLY at Step 4 before drafting the final document.

## Workflow

Complete each step in order.

---

### Step 1: Inventory Target Notebooks
- List all relevant notebooks (`.ipynb` or paired Jupytext `.py`) in the project.
- Determine the logical order of analysis (e.g., `01_audit` → `02_eda` → `03_hypotheses`).
- If the scope is ambiguous (e.g., archive/draft notebooks mixed with final ones), ask the user to confirm which notebooks to include before proceeding.

---

### Step 2: Extract Structured Evidence
- **Token-Safe `.ipynb` Reading:** Read `.ipynb` notebooks via dedicated notebook tools (native IDE notebook readers or Jupyter MCP `read_notebook` / `read_cell`) when available; otherwise, extract cell sources and plain-text outputs (`stdout` / `text/plain`) via a lightweight Python snippet (`json`/`nbformat`) that strips `image/*`, `text/html`, and `application/vnd.plotly*` blobs — never dump raw `.ipynb` JSON into context.

For each notebook, extract:
- Objective and dataset scope (tables, date ranges, `n`, filters applied).
- Data quality issues, manual fixes, exclusions, and assumptions.
- Key numerical findings: effect sizes, confidence intervals, `n` per group, raw and adjusted p-values (including multiple-testing method used), and notable distribution/bin anomalies.
- Unresolved questions or limitations.

---

### Step 3: Cross-Notebook Reconciliation
- Merge duplicate findings into a single narrative.
- Check consistency of sample sizes (`n`), metric definitions, and date windows across notebooks.
- Compile a short list of any conflicts or `[UNVERIFIED]` claims to highlight in the report.

---

### Step 4: Draft the Unified Report
- Consult `references/report-template.md` and structure the output strictly according to it.
- Keep prose crisp, scannable, and senior-level: lead with takeaways and exact numbers, avoid filler.
- Save the final report to the requested path (default: `reports/final_analysis_summary.md`).

---

### Step 5: Final Verification Pass
- Verify that every reported metric includes sample size (`n`) and source traceability.
- Confirm all assumptions, confounders, and limitations from individual notebooks are preserved in the final report.
