# [Project / Analysis Title] — Analytical Summary Report

**Date:** YYYY-MM-DD  
**Notebooks Covered:** [list of filenames]  
**Data Scope:** [datasets/tables, date range, total `n` after core filters]

---

## 1. Executive Summary
- 3–5 high-impact bullet points answering the core business/research questions.
- Every bullet MUST include concrete numbers (effect size, `n`, CI / adjusted p-value where applicable) and source tag `[notebook | section]`.

## 2. Objective & Methodology
- Concise statement of the analytical objective and hypotheses tested.
- Summary of statistical methods, multiple-testing corrections (Bonferroni / Holm / BH / Gatekeeping), and key metric definitions.

## 3. Data Quality, Fixes & Caveats
- Summary of missingness, anomalies, exclusions, and manual data fixes applied across notebooks.
- Known confounders, selection biases, or cross-notebook discrepancies (if any).

## 4. Key Findings
Organize by theme or hypothesis (not chronologically by notebook):

### 4.1 [Theme / Hypothesis Name]
- **Finding:** Clear statement backed by exact numbers (`n`, median/IQR or mean/SD, effect size, CI, adjusted p-value).
- **Distribution / Diagnostic Notes:** Notable bin patterns, zoom-in anomalies, or subgroup reversals (Simpson's paradox).
- **Source:** `[notebook_name.ipynb | section / plot_id]`

*(Repeat subsections as needed)*

## 5. Limitations & Open Questions
- Explicit list of assumptions, `[UNVERIFIED]` items (if any), and gaps in the data.

## 6. Recommendations & Next Steps
- Concrete, prioritized analytical or business actions directly justified by Section 4.

---

## Appendix: Notebook Index
| Notebook | Role / Focus | Key Outputs & Scope (`n`) |
| :--- | :--- | :--- |
| `01_...ipynb` | Data audit & cleaning | ... |
| `02_...ipynb` | Hypothesis testing | ... |
