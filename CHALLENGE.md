# Workshop Challenges

Hands-on challenges for each chapter. Work through the levels at your own pace —
Level 1 repeats what was demoed, Level 2 varies it, Level 3 pushes further.

---

# Chapter 1 — Cursor Basics

## ⭐ Level 1 — Repeat it

**Tab completion**
Open an existing test file. Start typing a new test and let Cursor's tab completion finish it. Accept at least 3 suggestions.

**Chat: add a test**
Use the chat to add a test for creating a new list. Reference the relevant component files as context.

**Inline edit**
Select two or more tests and use inline edit to refactor them into a single test using test steps.

## ⭐⭐ Level 2 — Variation

**Tab completion**
Rename a `getByTestId` locator across multiple tests. Change the first occurrence manually and use tab completion to propagate the change.

**Chat: add a test**
Use the chat to write a test that deletes a card. Reference the relevant component to understand the interaction flow.

**Inline edit**
Select a test and use inline edit to add a `test.beforeEach` hook that navigates to the board before each test.

## ⭐⭐⭐ Level 3 — Go further

**Chat: fix a broken test**
Manually introduce a bug into one of your tests — wrong selector, missing step, or broken assertion. Then use only the Cursor chat to diagnose and fix it, referencing the component and the Playwright error output as context. Do not edit the test directly yourself.

**Inline edit: add error handling**
Pick a test that creates a new card. Use inline edit to add an assertion that verifies what happens when you attempt to submit the card form with an empty title — without looking at the component source first. Then reference the component (`CardCreateInput.tsx`) and use inline edit again to correct any assumptions you got wrong.

---

# Chapter 2 — Context Engineering

## ⭐ Level 1 — Repeat It

**Explore the context window playground.**

Visit the Claude Code context window explorer:
👉 https://code.claude.com/docs/en/context-window#explore-the-context-window

Use the interactive playground to observe how different inputs contribute to the total context size:

- Add a user message — how many tokens does it cost?
- Enable a tool — what does that add?
- Attach a file — how does size vary with content length?

**Goal:** build an intuition for what fills the context window and how quickly it adds up in a real agent session.

## ⭐⭐ Level 2 — Variations

**Audit a real conversation's context usage.**

Pick a previous conversation from either **Cursor** or **Claude Code** where you asked an agent to help with something non-trivial.

- In **Claude Code**: run `/context` to inspect what's currently loaded
- In **Cursor**: check the context indicator in the chat panel

Look at what made it into the context:
- How many tokens were used?
- What files, tools, or history were included?
- Were there things in context that weren't relevant to the task?

**Goal:** move from theory to observation — see exactly how a real session consumes context, and spot opportunities to have kept it leaner.

## ⭐⭐⭐ Level 3 — Go Further

**Build a context window progress bar using `/statusline`.**

Claude Code lets you customise the status line shown in your terminal via the `/statusline` command.

Your challenge: use it to display a **live progress bar** for your context window usage — so you can see at a glance how close you are to the limit while working.

Research the `/statusline` command in the Claude Code docs, figure out what data is available, and build something that gives you a useful at-a-glance signal before you drift out of the smart zone.

**Goal:** turn context awareness from a manual check into a passive, always-visible indicator in your workflow.

---

# Chapter 3 — Rules & Skills

## Part 1 — Rules

### ⭐ Level 1 — Repeat it

Create a project rule for your Playwright test suite:

1. Create a rule file at `.agents/rules/e2e/playwright.mdc` (or `.claude/rules/e2e/playwright.mdc` if using Claude Code)
2. Set the rule type to **Auto Attached** with a glob pattern that targets spec files
3. Include at least the following conventions in your rule:
   - Selector strategy (use `data-testid`, avoid CSS classes and XPath)
   - Timing strategy (no `waitForTimeout()`)
4. Create a symlink so both Cursor and Claude Code share the same rules:
   ```bash
   ln -s ../../.agents/rules/ .claude/rules/
   ```
5. Prompt your AI agent to write a new test and verify the rule is being respected

### ⭐⭐ Level 2 — Variations

Do all of the above, then extend your rules setup:

1. Create an `AGENTS.md` file in the root of your project. Include:
   - A short project overview
   - Commands to run and develop the app
   - Test structure description
   - Code style guidelines

   > 💡 Try generating a first draft with your AI agent, then trim and refine it — notice how much redundant or irrelevant content gets generated.

2. Create a second rule file — this time with type **Agent Requested** — that covers something more situational (e.g. accessibility checks, API mocking conventions, or database reset behaviour)

3. Prompt your agent with a task that should trigger each rule and confirm they are being applied correctly

### ⭐⭐⭐ Level 3 — Go further

1. Set up a **User Rule** (in Cursor settings, or via `CLAUDE.local.md` / `~/.claude/CLAUDE.md`) that changes the agent's default communication style across all your projects (e.g. always respond concisely, always explain reasoning, always ask clarifying questions before writing code)

2. Explore the four rule types and create one of each:
   - **Always** — a universal rule applied to every conversation
   - **Auto Attached** — triggered by a glob pattern of your choice
   - **Agent Requested** — an opt-in rule the agent pulls in based on context
   - **Manual** — a rule you explicitly `@mention` when needed

3. Intentionally break one of your rules (e.g. write a test using a CSS selector) and prompt the agent to review it. Does it catch the violation? If not, refine your rule until it does.

4. Reflect: which rules feel like useful abstractions, and which feel like noise?

## Part 2 — Skills

### ⭐ Level 1 — Repeat it

Create the `summarize-failures` skill from the demo:

1. Create the skill file at `.agents/skills/summarize-failures/SKILL.md` with:
   - A `name` and `description` field (the description does the triggering — make it precise)
   - Instructions for summarising Playwright output: totals, per-failure breakdown, root cause grouping, next steps

2. Add a supporting script at `.agents/skills/summarize-failures/scripts/get-results.sh`:
   ```bash
   #!/bin/bash
   npx playwright test --reporter=json 2>/dev/null
   ```
   Reference it from your `SKILL.md` so the agent runs it automatically when no output is provided.

3. Verify it works — prompt your agent with just `"summarize my test failures"` without pasting any output. The agent should call the script and produce the summary on its own.

### ⭐⭐ Level 2 — Variations

**Build a different skill**
Create a new skill that solves a different Playwright pain point. Some ideas:
- `generate-selectors` — given a URL or a component, suggest robust `data-testid`-based selectors
- `flaky-test-detector` — analyse a test file and flag patterns known to cause flakiness (hard waits, missing `await`, time-dependent assertions)
- `test-coverage-report` — compare spec files against source components and list untested interactions

Make sure the `description` field is specific enough that the agent only loads the skill when it's genuinely relevant — not on every prompt.

**Install a skill from the registry**
Browse [skills.sh](https://skills.sh) and install one skill that looks useful for your workflow:
```bash
npx skills add <owner/repo>
```
Open the installed `SKILL.md`, read through its structure, and note what makes a well-written community skill. Try it out with a prompt that matches its description.

### ⭐⭐⭐ Level 3 — Go further

**Exploratory testing with playwright-cli**
Install the Microsoft playwright-cli skill if you haven't already:
```bash
npx skills add https://github.com/microsoft/playwright-cli --skill playwright-cli
```

Use it to run a full exploratory session against the app:
- Navigate to the board view
- Find all interactive elements on the page
- Interact with at least two of them (e.g. create a list, rename a card)
- Take a screenshot at each meaningful step

Once the session is complete, prompt the agent to generate a Playwright `.spec.ts` file based on everything it just explored — without you writing a single line of code.

**Close the loop**
Run the generated spec with `npx playwright test`. If it fails, paste the error back into the agent and ask it to fix it — using only the context it already has from the exploratory session. Document how many iterations it took to get a green run.
