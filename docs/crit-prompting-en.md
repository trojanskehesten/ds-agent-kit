# CRIT Prompting, Meta-layer, and Practices for Agentic Data Analysis

## Overall Flow: Where to Start an Analysis

In agentic EDA, there are two entry points — the choice depends on how clearly your task is defined:

1. **No clear hypothesis / new unfamiliar dataset / vague business request ("take a look and see what's interesting")**
   `Step 0 (Meta-layer: 5 research questions)` → pick 1–2 directions → `Step 1 (CRIT + plan-jupyter)` → `Step 2 (Iterations / Interview)` → document conclusions in the notebook.

2. **Specific hypothesis, stakeholder claim, or experiment to validate**
   Go straight to `Step 1 (CRIT + plan-jupyter)` → `Step 2 (Iterations / Interview)` → document conclusions in the notebook.

## Step 0 (Optional): Meta-layer — Reconnaissance and Hypothesis Generation

### What It Is and When to Use It

The **Meta-layer** is a preliminary step where you do not ask the agent to immediately analyze data or write long code. Instead, you ask it to inspect the available tables first and propose a **list of 5 potential research questions** (or analytical directions).

**When it is needed:**

* You are seeing a new dataset for the first time (especially with multiple tables) and do not yet know which questions are actually answerable on these data.
* You received a vague request ("find growth opportunities", "help improve business processes").
* You want to avoid **tunnel vision** and prevent the agent from heading down a false or low-value path from the very first cell.
* You want to retain the architect role (human-in-the-loop): the agent generates options grounded in the real data structure, and you choose where to dig deeper.

### Example Prompt from the DataCamp Webinar

```text
Context:
Look at my lakehouse. You'll note I have 9 tables. The data comes from a South American e-commerce company and the orders span approx 2016 to 2018. You should assume the data is accurate but it's a good idea to verify any assumptions by actually querying the data.

Role:
You are a business analyst with 10 years of experience helping retailers and e-commerce companies improve their business processes. You are starting a new consulting gig and you were given the above context about the data you want to use to help this company improve their business. You have no additional information about this company.

Interview:
I am the CEO of this company. I want YOU to give me a list of FIVE potential research questions that you believe would be answerable given the datasets above. After you give those to me I will pick a few with you and ask you to dive deeper.

Go!
```

### Why This Prompt Works (Breakdown)

* **`verify any assumptions by actually querying the data`** — a critical phrase: it prevents the model from inventing questions "off the top of its head" based solely on file/table names, forcing it to actually inspect schemas, relationships, and available columns.
* **`list of FIVE potential research questions`** — a fixed number (typically 3–5) strikes a good balance: broad enough to surface non-obvious angles without generating a wall of 20 banalities.
* **`After you give those to me I will pick a few`** — a hard stop: the agent must pause after listing the questions and wait for your selection before diving into deep analysis.

### Meta-layer Prompt Draft (Fill-in Template)

```text
Context:
Look at the data located at [Specify folder / database / list of tables, e.g.: data/raw/ with 5 tables].
The data comes from [Brief description of domain, product, and time range, e.g.: B2C SaaS, events from 2024–2025].
You should assume the data is generally accurate, but verify any assumptions (schemas, keys, date ranges, null rates) by actually querying/inspecting the data first.

Role:
You are a [Specify role, e.g.: senior product data scientist / business analyst] with 10 years of experience in [Specify domain]. You are starting a new engagement with only the context above and no additional background on the company.

Interview:
I am a [Your role, e.g.: Senior DS / Head of Product].
Before running any deep analysis or plotting, inspect the available datasets and give me a list of FIVE high-impact potential research questions (or hypotheses) that are actually answerable given these tables. For each question, briefly note which tables/columns support it and what business decision it could inform.
After you give me the list, stop and wait — I will pick 1–2 questions with you, and then we will dive deeper.
```

## Step 1: Starter CRIT Prompt (Hypothesis Testing & `plan-jupyter`)

### Example Prompt from the DataCamp Webinar

```text
Context:
Here is my business problem. We just held a c suite meeting to discuss our marketing strategy. Our CMO made this statement:
> “Last quarter was the best quarter in out history. We crushed Wall Streets earning targets by a wide margin. I am POSITIVE that the key reason was our revamped digital advertising campaigns. Recently we conducted a comprehensive survey of our social media usage at our mall stores and it is apparent our Instagram presence is expanding. 52% of survey respondents said they learned about our company from Instagram. We should double down on our Instagram ads to continue our earnings trajectory.”

Everyone in the room, including me, was skeptical. But we need hard data and analytics to prove it.

Role:
You are a marketing analytics data scientist with 10 years of experience in the retail space. I want you to help me look through the data and, using your intuition and experience, help me understand if the CMO’s statements are correct.

Interview:
I am the CEO of this retailer. I want you to interview me and let’s look at this data together. I want YOU to ask me questions about my business, goals, etc, and let’s reason through this problem together. Feel free to ask me any questions that may help you dive deeper and offer better recommendations. Work with me in a step-wise manner. Let’s look at each step together. Assume I know nothing about data, analytics, and what a data scientist is or does.

Task:
Should we invest more money in Instagram ad spend? Or something else? How much should we spend on Instagram ads? Tell me what you are thinking at each step of the process and ask any follow-on questions as needed.

The survey data is in a Microsoft Fabric table in a lakehouse attached to this notebook called “dbo.marketing_surveys”. I’m not sure what’s in this table, but this is the data our CMO gave to us.
```

### Starter CRIT Prompt Draft (Fill-in Template)

Replace the text inside square brackets `[]` with your task details (or paste the question chosen in Step 0). In choice blocks, keep the one option that fits:

```text
Context:
Here is my problem / hypothesis: [Describe the business context, task, or claim to be verified].
[Describe the skepticism, risks, or alternative explanations so the agent looks for weaknesses rather than agreeing].
We need hard data and rigorous statistical analysis to verify or refute this.

Experiment / Data collection protocol (if applicable):
- [How the data was collected or how the experiment was designed: splitting, duration, participants, conditions]
- [Known limitations of the collection process so the agent immediately checks the design for confounders and drift]

Role:
You are a [Specify narrow specialization, e.g.: senior data scientist / product analyst] with 10 years of experience in [Specify domain / industry]. We've brought you in to help us make this decision — or show us what we should be thinking about or doing wrong. Using your domain intuition and statistical rigor, evaluate whether [Specify key hypothesis] holds up.

Interview:
[Choose one expertise level]:
- Option A (familiar with data & statistics): Assume I am a Senior Data Scientist familiar with this domain: skip basic explanations, focus on statistical rigor, edge cases, and exact numbers.
- Option B (new unfamiliar domain / need fresh perspective): Assume I am unfamiliar with the nuances of these data/domain: explain your reasoning clearly at each step and flag non-obvious domain pitfalls.

Before writing any analysis code, interview me: ask clarifying questions about the domain, constraints, and goals so we can reason through this problem together.
Work with me in a step-wise manner and wait for my confirmation before executing each step.

Task:
Answer the following key questions:
1. [Key business or research question 1]
2. [Key question 2]
3. [Optional: what decision we need to make based on the results]

First, give me a high-level design of the analysis (plan-jupyter: chapters, key hypotheses, statistical checks, and potential pitfalls) that will help us answer these questions given the data and background context above. Keep the process high level at first, tell me what you are thinking before each step, and ask any follow-on questions as needed.

Data source:
The data is located at [Specify file path, table, or load command, e.g.: data/raw.parquet or sns.load_dataset("penguins")].
[Choose one schema familiarity option]:
- Option A (schema unknown): I'm not sure about the exact schema or data quality yet — start by inspecting the data structure, missing values, and potential biases before jumping to conclusions.
- Option B (schema known): I know the schema well ([briefly describe key columns / keys or point to a schema file/documentation]), so skip exploratory guesswork — just run a quick sanity check on this fresh extract (row counts, date range, nulls, duplicates, unexpected values) before proceeding.
```

### Starter Prompt Breakdown: Why It Works

The prompt is built on the **CRIT** framework (Context, Role, Interview, Task), with each block targeting a specific LLM failure mode:

* **Context (anti-sycophancy guard).**
  The phrase *"Everyone in the room was skeptical. We need hard data to prove it"* immediately disables the model's default "agree with the user" mode and primes it to hunt for holes in the hypothesis (selection bias, confounders, correlation vs. causation) instead of confirming the initial claim.

* **Role (domain heuristics).**
  Rather than a generic "data scientist", it specifies a narrow profile (*marketing analytics, 10 years in retail*) plus *"using your intuition and experience"*. This activates domain-specific checks (attribution, seasonality, offline vs. online) that the model might otherwise skip.

* **Interview (the core mechanism).**
  * *"Work with me in a step-wise manner. Let’s look at each step together"* — a stop-valve preventing the agent from silently writing 15 code cells in one shot and hallucinating conclusions.
  * *"I want YOU to ask me questions"* — flips standard LLM behavior: instead of guessing business context, the agent must extract it from you first.
  * *Explanation depth* — explicitly sets the level: for working analysis, state your actual role (**Senior DS**) for maximum statistical rigor, and only switch to a non-technical tone (CEO / PM) at the very end when verified findings need to be repackaged for stakeholders.

* **Task (linking decisions and data).**
  * **Business questions** (*should we invest? how much?*) come first, not a technical "plot a chart" — anchoring the agent to the actual decision.
  * *"Tell me what you are thinking at each step"* — forces explicit reasoning before running code.
  * *Schema declaration* — either honestly states the schema is unknown (forcing `df.info()` / `df.head()` first), or provides the schema while keeping a mandatory sanity check on the fresh extract.

### Enhancements from the Second Case (Machine Experiment)

* **Experiment / data collection protocol in `Context`.** A brief outline of *how* the data was generated (e.g., who operated what, for how long, how groups were assigned) lets the agent immediately spot methodological flaws: confounded factors (such as "1 operator = 1 machine") and temporal drift (fatigue, learning effects).
* **Explicit permission to reject the premise in `Role`.** The phrasing *"help us make this decision — or show us what we should be thinking about or doing wrong"* is stronger than ordinary skepticism: it empowers the agent not to force a "winner" out of the table, but to state plainly that the experiment is flawed and it is too early to decide.
* **Requesting an analysis plan before code in `Task`.** The phrase *"give me a high-level design of the analysis... Keep the process high level"* formalizes the `plan-jupyter` step: agree on the high-level design first, then write code.

### What Belongs Outside the Prompt (in `SKILL.md`)

Everything repetitive and technical (FWER, `ai_viz.py`, chapter numbering, `uv`, pre-commit, output formatting) does not need to be duplicated in every CRIT prompt — those rules belong in a dedicated skill (`SKILL.md` + `references/`, following the structure from Roberto Rodriguez's repository) so the prompt itself stays concise and focused on the specific task.

## Step 2: Iteration / Follow-up — Injecting External Context

### Example from the DataCamp Webinar

After the agent inspects the table with code and asks clarifying questions (including flagging the `"20-Dec"` anomaly in the age column), the user injects "messy reality" that does not physically exist in the data:

```text
* **my apologies for the data quality issues. I doublechecked and the "20-Dec" data is an anomaly and a data quality issue. My data people are idiots and they didn't load the data correctly.**
  * "20-Dec" should really be "12-20" for the "AgeBracket".
  * Can you do me a favor? It's going to take my data engineers another 6 months on a backlog to fix the data. Can you just assume, for now that `"20-Dec" = 12-20` for the AgeBracket?
* A little more about our business may help you.
  * We are a retailer of **cold weather apparel** sold to mostly to the **Under 40** demographic.
  * we are omni-channel but only about 20% of our receipts are from our shopping mall stores.

I also just confirmed some things with the CMO about HOW her team conducted the interviews. Here's the key findings:
* the surveys were only taken at one mall location in California.
* the surveys were conducted **as the shoppers where leaving the store**
* in many cases the respondents would not give their actual age ranges and the folks conducting the surveys guessed at their age ranges.
* the survey looked like this:

Store Survey
1. Did you hear about us through social media? Yes/No
2. If you answered "yes", which social media website?

With this new information, can you provide any additional insights?
```

### Why This Step Is Critical (Breakdown)

No `pandas` script or code could ever extract these facts from the table alone, yet they completely change the conclusions:

* **On-the-fly data bug fix:** `"20-Dec"` in `AgeBracket` is a classic Excel auto-formatting bug. The user explicitly authorizes a temporary mapping in code without waiting for data engineers.
* **Geographic and channel bias:** The brand sells *cold weather apparel*, yet the survey was run at *one mall in California*, and mall stores account for only *20% of revenue*.
* **Survivorship / Exit bias:** Only shoppers *leaving the store* were surveyed — online buyers and non-visitors were excluded.
* **Measurement noise:** Interviewers *guessed respondents' ages visually*, making age-based segmentation unreliable.
* **Broken survey design:** The questionnaire asked *only* about social media, completely ignoring search, referrals, email, and other channels.

### Where to Answer the Agent's Questions

Both options work — choose based on convenience:

1. **In chat (usually faster):** reply directly in the conversation, and ask the agent at the end to record the agreed assumptions in a Markdown cell in the notebook (this line is already included in the template below).
2. **Directly in a notebook Markdown cell:** write your answers under the questions, save the file, and tell the agent in chat: *"I answered in cell X, please recalculate the analysis with these inputs."*

### Follow-up Prompt Draft (Template for Answering the Agent)

Use this template in subsequent iterations when answering the agent's questions after initial data inspection:

```text
Here are the clarifications based on your questions and initial data inspection:

1. Data quality & temporary fixes:
- [Describe the anomaly found, e.g.: value "X" in column "Y" is an export bug].
- For this analysis, please assume/remap: [Specify the temporary cleaning or filtering rule in code].

2. Business & domain context (not in the table):
- [Key facts about the product, audience, channel share, or seasonality].

3. Data collection & potential biases:
- How the data was collected: [Who, where, when, and how the data/logs were gathered].
- Known limitations / noise: [Missingness, manual entry, guessing, sampling bias].

Please document these assumptions in a Markdown cell in the notebook, update the analysis/calculations accordingly, and revise your conclusions with these constraints in mind.
```

## Working Practices (Workflow & Hygiene)

### The Agentic EDA Loop

The real power of agentic analysis is not a single "perfect" prompt, but a tight iterative loop:

1. The agent inspects the data with code and highlights anomalies / schema gaps.
2. You inject external context (how data was collected, known biases, acceptable temporary fixes in code).
3. The agent recalculates metrics and revises conclusions under those constraints.

### Documenting Context Directly in the Notebook

Clarifications, temporary mappings (like `"20-Dec" -> "12-20"`), and sampling limitations should be recorded **directly in Markdown cells inside the notebook**, not left solely in chat history. That way, when reopening the file or starting a new agent session, the full business context and decision log remain visible.

### When to Use the `graphify` Skill

`graphify` builds a knowledge graph of the repository so the agent immediately sees the architecture and file relationships without burning tokens on blind search.

* **When to use it:** medium and large projects (rule of thumb: **10–15+ interconnected files/tables** — SQL/dbt models, ETL scripts, configs, internal modules, and docs).
* **When it is overkill:** ad-hoc analysis on 1–3 tables and a single notebook — just pass the file paths directly.
* **Key limitation:** `graphify` only sees **static structure** (code, schemas, dependencies), not **live values** in a specific extract (anomalies like `"20-Dec"`, sudden `NaN` spikes, or distribution shifts). In large projects, the best combo is `graphify` for architecture + code for live-data sanity checks.

### File Sync Hygiene (Avoiding Lost Edits)

When the agent edits `.ipynb` / `.py` files directly on disk, the golden rule is simple: **do not edit the active file while the agent is generating and writing changes** (scrolling, reading, and switching to other files is fine).

Choosing a save mode in VS Code:

* **`Auto Save: onFocusChange` (sweet spot):** the file saves automatically the moment you switch focus from the editor to the agent chat window. No need to remember `Ctrl+S`, and stray keystrokes in chat won't touch the file.
* **`Auto Save: off` + manual `Ctrl+S` before prompting (maximum control):** prevents accidental typos while reading, but requires a strict habit of saving before sending a prompt.
* **`Auto Save: afterDelay`:** fast and convenient, but carries a higher risk of accidentally saving a typo if you bump the keyboard while the agent is working.
* **For true simultaneous editing in the same notebook:** use **JupyterLab + `jupyter-collaboration` + `jupyter-mcp-server`** — edits sync in real time via CRDT on a single server without disk-save conflicts.

## References

* **CRIT Framework:** Geoff Woods, *The AI-Driven Leader*.
* **Data Science Adaptation & Prompt Examples:** DataCamp webinar *"How to Do Agentic Data Analysis"*.
* **Skills Architecture (`SKILL.md` + `references/`):** Roberto Rodriguez (NDC talk & repository).
