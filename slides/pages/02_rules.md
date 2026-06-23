---
layout: cover
---

Chapter #2:
# Rules
`npx workshop chapter 2`

---
layout: default
---

# What you'll learn
- What types of rules there are
- How to create and generate rules
- Recommendations

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