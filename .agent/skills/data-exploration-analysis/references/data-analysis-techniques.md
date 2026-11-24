# Statistical Rigor & Analysis Techniques

## 1. Data Quality & Missingness
- Quantify missing values per column and per subgroup; distinguish structural nulls from data bugs.
- Check for silent parsing errors (e.g., numeric ranges parsed as dates, mixed units, sentinel values like `-999` or `0`).

## 2. Distributions & Outliers
- Inspect skewness, heavy tails, and multimodality before using means or standard deviations.
- Report medians and IQR alongside means/SDs for skewed distributions.
- Examine intermediate distribution shape (e.g., via appropriately binned frequencies or percentiles), not just summary moments.
- Investigate outliers before dropping them — verify whether they are measurement errors or high-value real events.

## 3. Hypothesis Testing & Multiple Comparisons
- Choose tests matching data properties (e.g., Mann-Whitney / permutation tests for skewed data; Welch's t-test over Student's t-test by default).
- Never rely on p-values alone: always report **sample size (`n`)**, **effect size**, and **confidence intervals**.
- **Multiple-testing corrections:**
  - If the total number of tests ($m$) is known and fixed *before* computing p-values, apply **Bonferroni**.
  - Otherwise, choose based on the error-rate target: **Holm** (or Bonferroni) for **FWER**, or **Benjamini-Hochberg** for **FDR**.
  - **Gatekeeping:** Use a Gatekeeping strategy whenever hypotheses have a clear hierarchy (e.g., primary → secondary endpoints); for unstructured exploratory screening, use Holm (FWER) or Benjamini-Hochberg (FDR).

## 4. Bias & Confounders
- Actively check for selection bias, survivorship bias, and confounding variables (e.g., operator/cohort/time effects mixed with treatment).
- Verify whether aggregate trends reverse within subgroups (Simpson's paradox).
- For time-series or longitudinal data, check for seasonality, drift, and temporal leakage.
