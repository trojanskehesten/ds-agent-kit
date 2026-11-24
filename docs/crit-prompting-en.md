# CRIT Prompting Framework for Data Science

**CRIT** (**C**ontext, **R**ole, **I**nterview, **T**ask) is a structured prompting framework for AI agents that minimizes hallucinations, hidden assumptions, and generic analytical output.

---

## 1. Framework Structure

* **C — Context:** Business or research objective, data overview (tables, files, date range, known quirks), constraints, target audience, and prior findings.
* **R — Role:** The specific persona the agent should adopt (e.g., *Senior Data Scientist*, *Biostatistician*, *skeptical peer reviewer / devil's advocate*). *(Note: if `ds-standards.md` is active globally, the baseline Senior DS role is already set — specify only domain-specific expertise here.)*
* **I — Interview:** An explicit instruction to ask clarifying questions **before** writing code or drawing conclusions. Essential for surfacing confounders, edge cases, metric definitions, and missing filters early.
* **T — Task:** Concrete deliverable (notebook, module, hypothesis test, summary report), expected format, and definition of done.

---

## 2. Copy-Paste Template

```markdown
**Context:**
- Objective: [what problem or question we are answering]
- Data: [file paths / tables, approximate size, key columns]
- Constraints & known quirks: [missingness, data bugs, business rules, exclusions]
- Audience: [personal exploration / DS team / leadership]

**Role:**
Act as a [specific role, e.g., Senior DS specializing in clinical/observational data / skeptical statistical reviewer].

**Interview:**
Before writing any code or drawing conclusions, ask me 3–5 concise clarifying questions to uncover hidden assumptions, metric definitions, and edge cases. Wait for my answers before proceeding.

**Task:**
[Clearly state the deliverable: e.g., audit data quality and test hypothesis H1 in `02_analysis.ipynb`, following project standards.]
```

---

## 3. Quick DS Example

> **Context:** We have `data/processed/study_cohort.parquet` (~120k rows, 2024–2026). Retention in Group B dropped after an algorithm update in March. We need to determine whether this is a real treatment effect or a data/selection artifact.
>
> **Role:** Act as a Senior Data Scientist and skeptical reviewer who prioritizes checking confounders and instrumentation bugs first.
>
> **Interview:** Ask me 3–5 clarifying questions about cohort definitions, retention windows, and concurrent changes before starting the analysis.
>
> **Task:** Once I answer, propose a hypothesis-testing plan and run the EDA in `01_retention_drop.ipynb`.

---

## 4. When to Use Interview Mode

* **Always use:** Starting a new analysis, ambiguous problem statements, root-cause investigations, or stakeholder-facing reports.
* **Skip it:** Routine refactoring, quick chart tweaks, or format conversions — **Context + Task** is enough.

---

## References

* **CRIT Framework:** Geoff Woods, *The AI-Driven Leader*.
* **Data Science Adaptation:** DataCamp webinar *"How to Do Agentic Data Analysis"*.
