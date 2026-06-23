---
layout: cover
---

Chapter #5:
# Workflow Building
`npx workshop chapter 5`

---
layout: default
---

# What you'll learn

- What workflows are and why they matter for test automation
- How to build a skill that runs in a forked agent context
- How to build a sub-agent
- How sub-agents return findings back to the main thread

<!--
So far in this workshop we've been working in what I'd call "conversational mode" — we ask something, Claude responds.

A skill captures a repeatable procedure so you don't have to re-explain it each time. 

A sub-agent creates a separate context window with its own tools, model, and permissions, does a job, and returns a result.

-->

---
layout: default
---

# Skills

- Add `context: fork` to run it in an **isolated subagent**
- The skill content becomes the task prompt for that agent
- The agent does its work, then **returns a summary** to your main thread
- Use `agent: Explore` for read-only investigation tasks

```yaml
---
name: find-missing-testids
description: Scan the application for interactive elements that are missing a data-testid attribute
context: fork
agent: Explore
---
```

<!--
The key idea here is isolation.

When a skill runs inline, it sees your full conversation, it competes for the same context budget, and every tool call it makes shows up in your main thread. That's fine for lightweight skills.

But when you're doing something exploration-heavy — like scanning an entire codebase or crawling a web app — you don't want all that noise in your conversation. That's what `context: fork` is for.

The `agent: Explore` field is important. Explore is a built-in read-only agent in Claude Code — it uses Haiku (fast, cheap), has only Read, Glob, and Grep tools, and cannot modify anything. Perfect for an audit task.

One thing to keep in mind: the subagent starts fresh. It doesn't have your conversation history. So your SKILL.md needs to be self-contained — it has to explain everything the agent needs to do its job.
-->

---
layout: default
---

# Sub-agents with MCP

- Sub-agents are defined in `.claude/agents/` as markdown files with YAML frontmatter
- The `mcpServers` field scopes an MCP server **only to that agent** — not the main thread
- Great for browser automation: Playwright MCP runs inside the agent, not your whole session
- The agent navigates, observes, collects — then **summarises findings** back to you


<!--
Sub-agents are where things get really interesting for test engineers.

The challenge with browser automation and AI is context. If you give Claude a live browser and ask it to explore an entire app, the tool call logs, screenshots, and DOM snapshots can easily consume the entire context window — and you're left with no room for the actual test code.

A sub-agent solves this. The Playwright MCP runs inside the agent's isolated context. It clicks around, collects info, and when it's done, it compresses everything into a clean report and returns that to your main thread.

Your main thread stays clean and has the full context budget available to actually write the tests.

Also worth noting: because the Playwright MCP is defined inline in the agent frontmatter, it's only connected when that agent runs. The rest of your session doesn't have browser tools. That's much cleaner than configuring Playwright MCP globally.
-->

---
layout: center
---

# Demo

<!--

## Example 1 - find-missing-testids skill

A skill called `find-missing-testids` that:
1. Scans the application source for interactive elements (buttons, inputs, links, selects)
2. Identifies which ones are missing a `data-testid` attribute
3. Returns a structured list — so we know exactly what needs to be tagged before we can write tests

## Setup

Make sure the demo application is running. We're using the usual board/todo app.

## Step 1 — Create the skill directory

In the project root:

```bash
mkdir -p .claude/skills/find-missing-testids
```

## Step 2 — Create the SKILL.md

Create `.claude/skills/find-missing-testids/SKILL.md`:

```markdown
---
name: find-missing-testids
description: Scan the trelloapp code for interactive elements that are missing a data-testid attribute. Use when preparing the app for test automation or auditing testability coverage.
context: fork
agent: Explore
---

Scan the trelloapp code for all interactive HTML elements.

Your job is to find every element that:
- Is interactive: button, input, select, textarea, a (anchor), or any element with an onClick / onChange handler
- Is missing a `data-testid` attribute

## How to search

1. Use Glob to find all component files: `src/**/*.{tsx,jsx,vue,html}`
2. Use Grep to find elements: search for `<button`, `<input`, `<select`, `<textarea`, `<a `, `onClick=`, `onChange=`
3. For each match, check whether `data-testid` appears on the same element
4. If `data-testid` is absent — record it

## What to return

Return a markdown list grouped by file. For each missing element include:
- The file path
- The line number
- The element type
- A suggested testid value (use kebab-case, derived from the element's visible label, aria-label, name, or surrounding context)

Example:

```
## src/components/LoginForm.tsx

- Line 24 — `<button>` — suggested: `data-testid="login-submit-button"`
- Line 31 — `<input type="email">` — suggested: `data-testid="login-email-input"`
```

Keep the output concise. Do not include elements that already have `data-testid`.
```

## Step 3 — Trigger the skill

In Claude Code, type:

```
/find-missing-testids then make suggestion on which elements needed to be added. finally, suggest a test that 
   uses the newly added data-testid attributes  
```

Claude Code creates an Explore subagent, hands it the skill content as its task, and the agent starts scanning.

## Step 4 — Watch the output

Show the audience:
- The "subagent running" indicator in Claude Code UI
- The Explore agent using Glob and Grep (read-only tools only)
- The final report appearing in the main thread — clean, structured, not cluttered with every individual tool call

## What to highlight

"Notice what didn't happen — the main thread stayed clean. All the file scanning happened in the Explore agent's context. What we got back was just the report."

"This is the power of `context: fork`. Heavy exploration work, zero noise in your conversation."


## Example 2 - Sub-agent with Playwright MCP

A sub-agent called `playwright-explorer` that:
1. Launches a real browser via Playwright MCP
2. Navigates through the demo application
3. Discovers all interactive elements, form flows, and navigation paths
4. Returns a structured summary — which the main thread uses to generate a Playwright test

## Step 1 — Create the sub-agent file

Create `.agents/agents/playwright-explorer.md`:

```markdown
---
name: playwright-explorer
description: Use a real browser to navigate the application, discover all interactive elements and user flows, and return a structured report that can be used to write Playwright tests. Use when you need to understand what the app actually does before writing tests.
mcpServers:
  - playwright:
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
color: green
---

You are a test reconnaissance agent. Your job is to explore the running application using a real browser and produce a structured report of everything a test engineer would need to know.

## Your task

1. Navigate to the application (assume it is running at http://localhost:3000 unless told otherwise)
2. Discover and document:
   - All pages and navigation paths
   - All interactive elements on each page: buttons, inputs, forms, links, dropdowns
   - For each element: its visible label or placeholder, its `data-testid` if present, and what it does
   - Any multi-step flows (e.g. login, create item, edit item, delete item)
3. Note any elements that are missing `data-testid` — flag them clearly

## How to explore

- Use `browser_navigate` to open pages
- Use `browser_snapshot` to get a structured view of the current page (prefer this over screenshots for element discovery)
- Use `browser_click` to navigate through flows
- Use `browser_fill_form` to discover form behaviour
- Do not submit forms that would create or delete real data unless necessary to understand the flow

## What to return

A markdown report with this structure:

```
# Application Exploration Report

## Pages discovered
- / — Home / Dashboard
- /login — Login page
...

## Interactions by page

### /login
| Element | Type | data-testid | Action |
|---------|------|-------------|--------|
| Email field | input[type=email] | login-email-input | Enter email |
| Password field | input[type=password] | login-password-input | Enter password |
| Sign in button | button | login-submit-button | Submits the login form |

### /dashboard
...

## Flows discovered
1. **Login flow**: navigate to /login → fill email → fill password → click Sign In → redirected to /dashboard
2. ...

## Missing data-testid
- Submit button on /create-item page (no testid found)
```

Be thorough but concise. This report will be used directly to write Playwright tests.
```

## Step 2 — Invoke the sub-agent

In Claude Code:

```
Use the playwright-explorer agent to explore the running app and give me a full interaction report
```

## What to highlight

"The sub-agent did the messy browser work. The main thread got a clean report. And now writing the test is almost trivial — Claude already knows the app."

"This is also why we scope the Playwright MCP to the sub-agent. You don't want browser tools available in every conversation. They're heavy, they encourage Claude to browse instead of think, and they eat context. Scoped MCP keeps things tight."

-->