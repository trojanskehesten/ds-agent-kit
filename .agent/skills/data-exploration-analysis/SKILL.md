---
name: data-exploration-analysis
description: Perform rigorous, reproducible data exploration and analysis in Jupyter notebooks. Use when analyzing structured datasets from databases, data lakes, or files to validate data quality, test hypotheses, and produce defensible DS findings.
metadata:
  short-description: Senior DS workflow for structured EDA and analysis in notebooks
---

# Data Exploration and Analysis

Follow the global standards in `ds-standards.md` and execute this structured workflow in order.

## Workflow Rules

- Complete each step in order. Do NOT skip directly to modeling, conclusions, or visualizations before auditing the raw data.
- **Progressive References:** Read files under `references/` ONLY when the current step calls for them. Do NOT load all reference files upfront.

---

### Step 1: Understand Structure & Audit Raw Data

Establish the exact schema and live-data reality before making assumptions.

- Inspect available tables/files, shapes, column names, and data types.
- Identify key fields (timestamps, IDs, targets, categorical dimensions, join keys).
- Run a fast sanity check: missing values, duplicates, unexpected string/date formats, and date ranges.

Consult `references/data-query-guide.md`.

---

### Step 2: Retrieve Exploratory Dataset

Load data safely into a DataFrame for analysis.

- Avoid arbitrary small limits (e.g., `LIMIT 50`) that distort distributions, but check row counts first to avoid OOM.
- For very large datasets, use random or stratified sampling or pre-filter/aggregate via SQL, DuckDB, or Polars before loading into `pandas`.
- Do NOT apply complex business filters or aggregations yet.

Consult `references/data-query-guide.md`.

---

### Step 3: Exploratory Audit & Planning Checkpoint (STOP)

Understand baseline distributions and align on methodology before deep diving.

- Check distributions, skew, cardinality, time density, and obvious anomalies.
- **Checkpoint:** Pause and present:
  1. Key data quality findings and potential pitfalls (confounders, selection bias, data bugs).
  2. A high-level analysis plan (chapters, hypotheses, metrics, and statistical tests).
  3. Clarifying questions on business context or edge cases.
- Wait for user confirmation before proceeding to Step 4 (unless the user explicitly asked for an end-to-end run).

Consult `references/data-analysis-techniques.md`.

---

### Step 4: Investigate Patterns & Test Hypotheses

Execute targeted analysis with statistical rigor.

- Formulate explicit hypotheses and test them with appropriate parametric or non-parametric methods.
- Always report sample sizes (`n`), effect sizes, confidence intervals, and apply multiple-testing corrections (Bonferroni/Holm for FWER, Benjamini-Hochberg for FDR, and Gatekeeping when hypotheses are hierarchical).
- Actively check for confounders, Simpson's paradox, and data leakage.

Consult `references/data-analysis-techniques.md`.

---

### Step 5: Visualize Findings

Build clear, publication-ready charts backed by exact numbers.

- **Primary tools:** Use **`pltstat`** (configured with the **Plotly** backend by default) for statistical visualizations and displaying test/analysis results. Use plain **Plotly** for custom interactive charts, and fall back to **matplotlib/seaborn** only when Plotly/`pltstat` is overly complex or unsuitable.
- **Mandatory `[AI_SUMMARY]`:** For every plot, print a compact `[AI_SUMMARY]` block to `stdout` with exact underlying metrics (quantiles, `n`, outliers, bin frequencies for histograms, correlations, group stats). Base all written conclusions strictly on these numbers, never by guessing from rendered images.

Consult `references/data-visualization-guide.md`.

---

### Step 6: Document Conclusions

Synthesize findings into a self-contained analytical record.

- Summarize the methodology, key numerical findings, and how they answer the original question.
- Explicitly state limitations, assumptions, and unresolved uncertainties.
- Ensure every claim in Markdown is backed by code output or `[AI_SUMMARY]` evidence.
