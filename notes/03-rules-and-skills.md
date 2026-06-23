# Chapter 3: Rules & Skills

Rules and skills are two ways to shape how an AI agent behaves. Rules define
boundaries that are always (or conditionally) in context; skills define
executable capabilities the agent loads on demand. A useful mental model:

> **AGENTS define intent, RULES define boundaries, SKILLS define execution.**

---

## Part 1 — Rules

### Types of rules
- AGENTS.md / CLAUDE.md
- Project rules
- User (local) rules

### AGENTS.md and CLAUDE.md
- purpose is to define project intent (like a README for AI)
- covers: how to run tests, seed the database, code style guidelines
- attached to every conversation automatically
- naming differs by tool: Claude uses `CLAUDE.md`, Cursor uses `AGENT.md`
- `AGENTS.md` is an effort to unify conventions across tools (Cursor, Windsurf, etc.)
- can create symlinks so both tools share the same file

### Project rules
- markdown files saved in `.cursor/rules` or `.claude/rules`
- four types:
  - **Always** — always included in context
  - **Auto Attached** — triggered by glob patterns (e.g. `**/*.spec.ts`)
  - **Agent Requested** — AI decides when to pull them in, based on the description field
  - **Manual** — only added when explicitly `@mentioned`

### User rules
- Cursor: defined through settings UI, applied across all projects
- Claude Code: `CLAUDE.local.md` or `~/.claude/CLAUDE.md`

### Recommendations
- don't download rules from the internet — becomes alchemy fast
- don't generate rules with `/init` — output tends to be bloated
- don't try to define all rules upfront — build them as you go
- if the agent makes a mistake, define a rule
- rules are abstractions — apply them when they earn their place

---

## Part 2 — Skills

### What are skills?

A skill is a folder containing a `SKILL.md` file, placed inside `.agents/skills/`. Unlike rules (which always apply), skills are loaded on demand — the agent reads the `description` field to decide when a skill is relevant and loads it only when needed.

```
.agents/skills/
└── my-skill/
    └── SKILL.md
```

### Anatomy of a skill

A `SKILL.md` file has two key parts:

- **Frontmatter** — `name` and `description` fields. The description does all the triggering work: make it precise and specific so the agent loads the skill at the right moment.
- **Body** — prose instructions telling the agent exactly what to do when the skill is active.

### Adding supporting scripts

For mechanical, reliable operations (running a command, parsing output), add a `scripts/` folder alongside `SKILL.md` and reference the scripts from the skill body. The script does the mechanical work; the skill does the reasoning.

```
my-skill/
├── SKILL.md
└── scripts/
    └── get-results.sh
```

### The skills registry — skills.sh

[skills.sh](https://skills.sh) is an open community registry for AI skills — think npm, but for agent skills. Skills are organized by `owner/repo` and work across agents (Claude Code, Cursor, Copilot, Cline, Windsurf, and more).

```bash
# Install a skill from the registry
npx skills add microsoft/playwright-cli

# Install a specific skill from a repo
npx skills add https://github.com/microsoft/playwright-cli --skill playwright-cli
```

Once installed, the skill folder lands in `.agents/skills/` and the agent picks it up immediately. Anthropic also publishes skills on the registry — `frontend-design`, `pptx`, `docx`, and `pdf` are all in the top 100.

### The playwright-cli skill

The `microsoft/playwright-cli` skill (~23k installs) gives the agent a CLI to control a real browser step by step — this is distinct from running `.spec.ts` files. Key commands:

```
playwright-cli open https://your-app.com
playwright-cli snapshot       # inspect the accessibility tree
playwright-cli click e5
playwright-cli fill e3 "user@example.com"
playwright-cli screenshot
```

**Why this matters for test automation:** the skill turns the agent into an **exploratory testing agent**. You can prompt it in natural language ("find all forms on this page and check they have proper validation") and it will navigate, interact, and report — without writing a single line of code. Once it has explored an app with `playwright-cli`, it can generate the actual Playwright spec from what it just did, closing the loop between exploration and test authoring.
