# Data Visualization Guide

## 1. Library Policy
- **Statistical plots & test results (Primary):** Use **`pltstat`** (`https://pypi.org/project/pltstat/`) with the **Plotly** backend enabled by default to plot distributions, comparisons, and annotated statistical results. If unsure about exact `pltstat` function signatures, inspect `dir(pltstat)` / `help(...)` before calling rather than guessing arguments.
- **Custom interactive charts:** Use **Plotly** (`plotly.express` / `plotly.graph_objects`).
- **Fallback:** Use **matplotlib / seaborn** only when `pltstat`/Plotly is overly complex, slow on very dense data, or for quick internal diagnostics.

## 2. Mandatory `[AI_SUMMARY]` Format
- Do NOT interpret charts visually or guess values from rendered images.
- Every visualization cell MUST print a compact, structured `[AI_SUMMARY]` block to `stdout` computed directly from the plotted DataFrame.
- **Histograms & distributions:** In addition to summary stats (median, IQR, mean, skew, outliers), include a compact **bin frequency table (5–10 appropriately sized bins with edges and count/%)** or key percentiles (`P5, P25, P50, P75, P95`) so intermediate distribution differences, gaps, and local peaks are visible.

Example format:
```text
[AI_SUMMARY | plot_id: 2.1_metric_by_group]
- n_total: 1240 (missing_dropped: 12)
- group_A (n=610): median=14.2, IQR=[11.0, 18.5], mean=15.1, outliers(>1.5*IQR)=8
- group_B (n=618): median=16.8, IQR=[13.4, 20.1], mean=17.0, outliers(>1.5*IQR)=3
- diff_B_vs_A: +2.6 median (+18.3%), Mann-Whitney p=0.0014
```

## 3. Diagnostic Zoom-In for Suspicious Regions
- If a histogram or distribution reveals a suspicious or anomalous region (e.g., an unexpected spike, sudden gap, rounding/boundary artifact, or potential sub-cluster), **build a follow-up zoomed-in histogram** restricted to that narrower range with finer binning (and log its `[AI_SUMMARY]`).

## 4. Chart Clarity & Readability Standards
- **One chart — one question:** Every chart must answer a specific analytical question.
- **Direct data labels:** Whenever readable (e.g., bar charts, histogram bins, grouped summaries, key points), display exact numeric values directly on the chart.
- **Gridlines:** Enable subtle gridlines (`showgrid=True` / `plt.grid(True)`) wherever they help read values accurately.
- **Complete annotations:** Always include a clear, descriptive title (with sample size `n` and key context/subtitle if helpful), labeled X and Y axes with units, a clear legend when multiple series exist, and explicit notes if axes are truncated or log-scaled.
