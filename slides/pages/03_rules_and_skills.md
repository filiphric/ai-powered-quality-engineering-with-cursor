---
layout: cover
---

Chapter #3:
# Rules & Skills

---
layout: default
---

# What you'll learn

- What types of rules there are, how to create them
- What skills are and how they differ from rules
- How to create your own skill, add supporting scripts, the skills registry
- Commands / workflows / agents that pull rules, skills and tools together

---
layout: cover
---

# Part 1 — Rules

---
layout: default
---

# Types of rules

- AGENT.md and CLAUDE.md
- Project rules
- User (local) rules

---
layout: default
---

# AGENTS.md and CLAUDE.md

- their purpose is to define intentions
- attached to every conversation
- different naming convention for Claude Code

<!-- 
- AGENT.md is sort of like a README file. It defines the intent of a project. It covers the basic information about a project, so stuff like how to run how to run your tests, how to seed your database, code style guidelines and so on 
- they are attached to every converstion
- Claude uses CLAUDE.md and Cursor uses AGENT.md files
- AGENTS.md is an effort to unify basic instructions for users so that if within your team some people use Cursor, some use Windsurf, they can all have a common starting point
- they are stubborn, but you can create symlinks between them
-->

---
layout: two-cols
---

# AGENTS.md files in your context window
- instruction pasted into every conversation
- `/init` command in claude code

::right::
<SlidevVideo autoplay class="w-100 mx-auto">
  <source src="/video/claude-md.webm" type="video/webm" />
</SlidevVideo>

<!-- 
- These files are sent along with your prompt when you work with Cursor, Claude Code, Codex, or other AI agents.
- They have become a standard over the past couple of months. And many people chose to add them to their projects.
- many tools such as Claude Code enable you to create a CLAUDE.md file using a /init command
- it will scan your repository, create a summary and create the file for you
- However, I would advise against this
-->

---
layout: default
---

# What the research says

<SlidevVideo autoplay class="w-200 mx-auto">
  <source src="/video/SuccessRateChart.webm" type="video/webm" />
</SlidevVideo>

<!--
- a recent study shows a 3% performance decrease in tasks done by AI agents on repositories that contain AGENTS.md, over those that don't.
- This made headlines recently, people started deleting those files
-->

---
layout: default
---

# ...but it depends who wrote it

<SlidevVideo autoplay class="w-200 mx-auto">
  <source src="/video/BarChart.webm" type="video/webm" />
</SlidevVideo>

<!--
- but the study says some other things as well
- On average, a 4% performance improvement was measured in those projects where AGENTS.md files were created by humans
- the thing is, when you let AI do the scanning for you, it's like letting someone who never used the repository write a summary for you
- it's fair to say that the AGENTS.md concept is not perfect.
- It needs constant updates, because it rots like documentation.
- Some tools make their own choices on when to include these files.
- And they can potentially introduce noise to the context window. Which is probably the main reason for that 3% performance decrease.
-->

---
layout: default
---

# My advice

- keep the file lean
- skip the basic stuff
- include custom conventions

<!--
- my advice
- keep the file lean
- Your AGENTS.md file should not contain things like "npm run dev" or other scripts that an average AI agent can read in your package.json.
- It is a place for things like custom project conventions, non-obvious architectural decisions, and business logic quirks.
- Think about all the things that confuse your new colleagues. Things that you only learn after months of working on a project.
-->

---
layout: center
---

# Demo
## Creating AGENTS.md file

---
layout: default
---

# Project rules

- markdown files live in `.cursor/rules` or `.claude/rules` folder
- four types: Always, Auto Attached, Agent Requested, Manual
- scoped using glob patterns

<div class="mt-10 w-[50%] neo-block px-2 bg-[#20212e] mx-auto">

```
your-project/
├── .claude/
│   ├── CLAUDE.md              # Main project instructions
│   └── rules/
│       ├── code-style.md      # Always applied
│       ├── e2e/
│       │   └── playwright.md  # Auto attached to *.spec.ts
│       └── accessibility.md   # Agent requested
```

</div>

<!-- 
- rules are attached to the context window, so they are basically another set of instructions that get added everytime you prompt Cursor
- project rules are saved in `.agents/rules` or `.claude/rules` folder
- four types:
  - Always: always included in context
  - Auto Attached: triggered by glob patterns (e.g. **/*.spec.ts)
  - Agent Requested: AI decides when to pull them in, based on the description field
  - Manual: only added when you explicitly @mention them

- AGENTS define intent, RULES define boundaries, SKILLS define execution.
-->

---
layout: default
---

# User Rules
- defined through UI in Cursor
- CLAUDE.local.md or `~/.claude/CLAUDE.md`

<!-- 

- User rules are set in settings, applied across all projects

-->

---
layout: center
---

# Demo

<!-- 

## Example #1 - creating a rule

- go to settings and show user rules
- go to project rules
- describe types of rules

Rule file: `.agents/rules/e2e/playwright.mdc`

```md
---
description: Playwright-specific conventions. Use when writing or editing e2e tests.
globs:
  - "**/*.spec.ts"
---

# Playwright test conventions

## Selectors
- always use `data-testid` attributes for element selection
- never use CSS classes or XPath
- prefer `page.getByTestId()` over `page.locator()`

## Timing
- never use `waitForTimeout()` - use `waitForSelector` or `expect` assertions instead
- always use Playwright's built-in auto-waiting

## Trello app specifics
`add-list-input` element is automatically visible and focused when there are no lists inside a board.
This means that the `create-list` button is not available for selection in following situations:
- test is interacting with a newly created board
- the test created a new list, but `add-list-input` element is still focused
- right after the test clicked the `create-list` button
```


Create a symlink so both tools share the same rules:
```bash
ln -s ../../.agents/rules/ .claude/rules/
```

## Example #2 - AGENTS.md

Create an AGENTS.md tailored to a Playwright project:

```md
# Trello Clone - Test Automation Project

## Project overview
End-to-end test suite for the Trello clone app using Playwright.

## Running tests

  npx playwright test          # run all tests
  npx playwright test --ui     # open UI mode
  npx playwright show-report   # view last run report

## Test structure
- tests live in `/trelloapp/tests` folder
- each test starts with a complete database reset (@/trelloapp/tests/setup/cleanup.setup.ts)
- tests follow "arrange - act - assert" pattern

## Environment setup

  npm run dev        # start app on localhost:5173
  npm run db:seed    # seed test database

## Code style
- use TypeScript
- use `data-testid` attributes for selectors
- follow the Page Object Model pattern
- test descriptions should read like user stories: "user can add a new card"
```

- this file was generated
- look how much redundant info

# Example #3 - user rules

- go to cursor and show them

```
Please reply in an extremely concise style. Sacrifice grammar for concision
```

Prompt Cursor:
give me summary of basic trelloapp features
-->

---
layout: default
---

# Recommendations
- don't download rules from the internet
- don't generate your rules using `/init`
- don't try to figure them all out at once
- if agent makes a mistake, define a rule
- they are basically abstractions for your agent
- AGENTS define intent, RULES define boundaries, SKILLS define execution.

<!-- 

- there are rules on the internet that you can download, but same as prompt engineering, it can turn into a little bit of an alchemy
- my suggestion is to always reverse-engineer your rules + experiment
- so build your rules based on what you know works
- rules are basically abstractions - you want to not repeat yourself when you prompt AI to do something - and as with all abstractions, you don't want to start to apply them before they make sense
- the four rule types give you a lot of control: always-on rules for universal conventions, glob-triggered for filetype-specific patterns, agent-requested for opt-in guidance

-->

---
layout: cover
---

# Part 2 — Skills

---
layout: center
---

# Demo
## Part 1 — Create your own skill

<!--

## Creating a simple skill

A skill is a folder containing a SKILL.md file.

```
.agents/skills/
└── my-skill/
    └── SKILL.md
```

Create the file:

```
.agents/skills/summarize-failures/SKILL.md
```

Content:

```md
name: summarize-failures
description: Use when the user wants to summarize Playwright test failures,
             understand why tests failed, or get a structured breakdown of
             a test run output.

# Summarize Playwright test failures

When given Playwright CLI output, produce a clear summary:

1. Total: passed / failed / skipped
2. For each failure: test name, file, error message, line number
3. Group failures by likely root cause if patterns are visible
4. Suggest next steps for each failure group
```

run the test to copy the complete outputs
```
npx playwright test --reporter=json | pbcopy
```

Simply prompt: "summarize my test failures" while pasting the Playwright output. Claude reads the description and loads the skill.

Key thing to point out: the description field is doing all the triggering work.
Claude reads it to decide when to load the skill. Make it precise and specific.

## Adding a supporting script

Some operations are dumb but reliable: run a command, parse output, open a file.
These belong in a script, not in prose instructions.

Add a scripts/ folder alongside SKILL.md:

```
summarize-failures/
├── SKILL.md
└── scripts/
    └── get-results.sh
```

scripts/get-results.sh:

```bash
#!/bin/bash
npx playwright test --reporter=json 2>/dev/null
```

Reference it from SKILL.md:

```md
## Getting test results

If the user provides no output, run:

bash scripts/get-results.sh

Then parse the JSON and produce the summary.
```

The script does the mechanical work. The skill does the reasoning.

Show how Claude calls the script when the user just says "check my test results"
without pasting anything.

-->

---
layout: default
---

# Skills registry

- **skills.sh** is the open agent skills directory — think npm, but for AI skills
- skills are organized by `owner/repo` — anyone can publish
- install with a single command: `npx skills add <owner/repo>`

<div class="mt-8 w-[60%] neo-block px-4 py-3 bg-[#20212e] mx-auto font-mono text-sm">

```bash
# install a skill from the registry
npx skills add microsoft/playwright-cli

# install a specific skill from a repo
npx skills add https://github.com/microsoft/playwright-cli \
  --skill playwright-cli
```
</div>

<!--

- skills.sh is a community registry run by Vercel Labs - open source at github.com/vercel-labs/skills
- it works across agents: Claude Code, Cursor, Copilot, Cline, Windsurf and more
- the leaderboard shows install counts - you can see what the community finds useful
- our playwright-cli skill is from Microsoft, has around 23k installs, sits at #239 on the leaderboard
- once installed, the skill folder lands in your project and Claude picks it up immediately
- worth pointing out: Anthropic also publishes skills there - frontend-design, pptx, docx, pdf are all in the top 100

-->

---
layout: default
---

# Install with care

- be wary of "best practices" / "use 50% fewer tokens" skills — that's prompt-engineering territory
- **read every skill you add** — they run with your agent's permissions
- a skill can carry **prompt injection** — only install from sources you trust

<!--
- there's now a library of skills available at skills.sh - npx skills add for any agent
- but I'd be wary of downloading too many skills or adding skills such as "best practices" to your projects - this is once again "prompt engineering" territory, where you might find people claiming a skill reduces token usage by 50% or makes no mistakes
- more importantly, you need to read the skills you are adding to your project, because they may introduce prompt injection
- if you are downloading skills, make sure they come from a source you trust
-->

---
layout: center
---

# Demo
## Part 2 — playwright-cli skill

<!--

## Installing the skill

```
npx skills add https://github.com/microsoft/playwright-cli --skill playwright-cli
```

Show the folder that gets created in .agents/skills/playwright-cli/ - open SKILL.md
and walk through the structure: it's a browser automation skill with a rich command set.

This is not about running .spec.ts files. It gives Claude a CLI to actually
control a real browser, step by step.


## What the skill teaches Claude

The skill describes a set of playwright-cli commands:

```
playwright-cli open https://your-app.com
playwright-cli snapshot
playwright-cli click e5
playwright-cli fill e3 "user@example.com"
playwright-cli screenshot
```

Claude uses these to interact with the app, inspect the accessibility tree via snapshot,
and take screenshots - all driven by natural language prompts from you.


## Demo flow

Prompt: "Open our app, go to the board, add a new list called QA and take a screenshot"

Watch Claude:
  playwright-cli open http://localhost:3000
  playwright-cli snapshot            (to see the page structure)
  playwright-cli click e12           (the "add list" button)
  playwright-cli fill e14 "QA"
  playwright-cli press Enter
  playwright-cli screenshot


## Why this matters for test automation

The skill turns Claude into an exploratory testing agent.
You can say "find all the forms on this page and check they have proper validation"
and Claude will navigate, interact, and report - without you writing a single line of code.

It also closes the loop: once Claude has explored the app with playwright-cli,
it can generate the actual Playwright spec from what it just did.

-->

---
layout: cover
---

# Part 3 — Repeatable Workflows

---
layout: default
---

# Commands,
<div class="-mt-8"/>

# Workflows,
<div class="-mt-8"/>

# Agents

<!-- 
- I'm grouping these together, because different tools have different names for this
- essentially I'm talking about repeatable workflows or sets of steps that your agent is able to follow
- they allow you to combine repeatability with fuzziness of AI
- commands are one of my favourite use cases for agents, and chances are, if you're doing automation that they will be favourite for you too
-->

---
layout: default
---

<SlidevVideo autoplay>
  <source src="/video/claude-command.webm" type="video/webm" />
</SlidevVideo>

<!-- 
- a typical use case would be - write an end-to-end test for this ticket
- an agent is able to digest a set of steps, it can pull rules, skills, mcps and all the tools needed together, to complete a certain task
- they can fire sub-agents to complete partial tasks, e.g. that fetching of the info from a ticket could be a separate task
- commands or agents pull together all of the things we have talked about
- one of the things I personally like to do is to let a subagent figure out the react components that I'm interacting with through my e2e tests. if a proper selector is missing, the agent is instructed to add the data-test-id property
-->

---
layout: default
---

<SlidevVideo autoplay>
  <source src="/video/agent-browser.webm" type="video/webm" />
</SlidevVideo>

<!-- 
- the way I usually create agents as command is that I first go with my agent manually
- when writing an e2e test, I either use playwright-cli, or lately I have been using agent-browser from vercel for this and actually use claude code or cursor to go step by step
- once I'm happy with all the steps, I tell claude to summarize what we just did into a markdown file
- that file will then become a blueprint for the repeatable workflow
-->
