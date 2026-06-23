---
layout: cover
---

Chapter #3:
# Skills
`npx workshop chapter 3`

---
layout: default
---

# What you'll learn
- What skills are and how they differ from rules
- How to create your own skill
- How to pass arguments and add supporting scripts
- The skills registry (skills.sh)
- Demo: playwright-cli skill

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