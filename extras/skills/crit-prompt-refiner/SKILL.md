---
name: crit-prompt-refiner
description: >-
  Audits and refines CRIT prompt drafts (Context, Role, Interview, Task) for AI
  agents in data analysis and software development tasks. Use this skill when
  the user invokes "/crit", asks to review, fix, improve, or polish a CRIT
  prompt, or shares a prompt draft structured with Context / Role / Interview /
  Task sections.
metadata:
  short-description: Audits and refines CRIT prompt drafts without adding scope creep
---

# CRIT Prompt Refiner

A skill for auditing and refining CRIT prompts (Context, Role, Interview, Task) before sending them to an AI agent. It catches logical conflicts, template artifacts, and ambiguities, then outputs a clean, copy-ready version without inventing extra requirements.

## When to Use

- The user invokes `/crit` with a prompt draft.
- The user asks to review, fix, improve, or polish a CRIT prompt.
- The user shares a draft prompt containing `Context`, `Role`, `Interview`, `Task` (and optionally `Data source`) sections for an analytical or DS agent.

## Steps

1. **Confirm the target dialogue language:**
   - Check whether the user's message or prompt draft explicitly specifies the language in which the target agent should converse with the user.
   - **If the dialogue language is not specified**, ask the user which language they prefer for the conversation going forward before finalizing the refined prompt.
   - Once specified, ensure the refined prompt explicitly states the language rule: the target agent converses with the user in their chosen language, while writing code and code comments in English (unless the user explicitly requested another language for code).

2. **Audit the draft against key criteria:**
   - **Execution-order conflicts (critical):** Check for contradictory "first" instructions across sections (e.g., "interview me first" in `Interview`, "give me a plan first" in `Task`, and "start by inspecting the data" in `Data source`). If conflicts exist, consolidate them into a single unambiguous step-by-step sequence with explicit confirmation gates between stages.
   - **Template artifacts:** Spot unclosed brackets (`[`, `]`), leftover placeholders, and unnatural template phrasing (such as `"whether [X] holds up"`) left behind from a starter template.
   - **Language policy:** Verify that the preferred dialogue language and the English-for-code/comments rule (unless overridden by the user) are clearly stated.
   - **Execution environment & artifacts:** If the user mentions a notebook, scripts, or output format, make sure those requirements are stated clearly and without ambiguity.
   - **Clarity & typos:** Fix typos, grammar issues, and vague wording in `Task` without altering the underlying goals.

3. **Format the response in two parts:**
   - **What to fix:** A concise numbered list of actual issues found, ordered from most critical to minor — no filler.
   - **Refined prompt:** A copy-ready prompt inside a fenced ```` ```markdown ... ``` ```` code block that preserves the user's original intent, rigor level, and tech stack.

## Gotchas

- **Do not invent requirements:** Only rephrase, resolve logical conflicts, and fix inaccuracies. Never add new tasks, metrics, business rules, or tools that were not in the user's draft.
- **Only permitted default addition:** Explicitly stating the user-chosen dialogue language plus English for code and code comments (unless the user specified otherwise).
- **Keep feedback lean:** If the draft is already solid, point out only the real rough edges.
