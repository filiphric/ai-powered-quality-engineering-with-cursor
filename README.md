# AI-Powered Quality Engineering with Cursor — Workshop

A hands-on workshop on writing effective tests using AI-powered workflows. You'll be working with a Trello clone application as the system under test.

## Prerequisites

Make sure you have the following installed before the workshop:

- **Git** — [git-scm.com](https://git-scm.com/downloads)
- **Node.js v20 or later** — [nodejs.org](https://nodejs.org)
- **npm** (comes bundled with Node.js)

## Installation

Run this command in your terminal:

**macOS / Linux:**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/filiphric/ai-powered-quality-engineering-with-cursor/main/scripts/setup.sh)
```

**Windows PowerShell (experimental):**

```powershell
irm https://raw.githubusercontent.com/filiphric/ai-powered-quality-engineering-with-cursor/main/scripts/setup.ps1 | iex
```

**Windows Git Bash:**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/filiphric/ai-powered-quality-engineering-with-cursor/main/scripts/setup.sh)
```

> Windows users running PowerShell: if script execution is blocked, run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` first.

The installer will:
1. Check that `git`, `node` (v20+), and `npm` are installed
2. Check network connectivity (flags VPN/proxy issues)
3. Clone the workshop repository
4. Install application dependencies
5. Set up the environment configuration

Once done, you'll see a menu to start the application.

## Starting the application

After setup, navigate to the project folder and run:

```bash
cd ai-powered-quality-engineering-with-cursor
npx workshop start
```

The app runs at **http://localhost:3000** with the API on **http://localhost:3001**.

## Workshop chapters

The workshop is split into chapters. Each chapter is a git branch that builds on the previous one.

| # | Chapter | Branch | What you'll learn |
|---|---------|--------|-------------------|
| 1 | Cursor Basics | `chapter/01-cursor-basics` | Use Cursor's chat, tab completion, and inline edits to write Playwright tests with proper selectors |
| 2 | Rules | `chapter/02-rules` | Create and organize rules with different trigger types to guide AI agent behavior |
| 3 | Skills | `chapter/03-skills` | Build reusable skills with SKILL.md, add supporting scripts, and use the skills registry |
| 4 | Context Engineering | `chapter/04-context-engineering` | Manage context windows effectively and keep conversations focused for best model performance |
| 5 | Workflow Building | `chapter/05-workflow-building` | Orchestrate agents with forked subagents and scoped MCP servers to automate complex workflows |
| 6 | AI code governance | `chapter/06-ai-code-governance` | Enforce team coding standards on PRs using AI-powered code review with rules and context-aware agents |

### Switching chapters

To jump to a chapter, run:

```bash
npx workshop chapter <number>
```

For example, to start chapter 3:

```bash
npx workshop chapter 3
```

This will automatically stash any uncommitted changes and switch to the correct branch. Each chapter branch contains the completed state of all previous chapters, so you can jump in at any point.

## Script commands

Use the setup script throughout the workshop:

| Command | What it does |
|---|---|
| `npx workshop setup` | Full setup + interactive menu |
| `npx workshop start` | Start the application |
| `npx workshop reset` | Reset the database to a clean state |
| `npx workshop check` | Check if ports 3000 & 3001 are free |
| `npx workshop verify` | Verify that everything is set up correctly |
| `npx workshop chapter <n>` | Switch to a chapter branch |

## Troubleshooting

**Node.js version is too old**
Upgrade to v20+. Using `nvm`: `nvm install 20 && nvm use 20`. On Windows: download from [nodejs.org](https://nodejs.org) or run `winget install OpenJS.NodeJS.LTS`.

**Network checks fail (VPN / proxy)**
Your corporate network may be blocking `github.com` or `registry.npmjs.org`. Ask IT to allowlist these domains, or try from a personal network.

**Port 3000 or 3001 is already in use**
Run `npx workshop check` to see what's using the ports. The script can kill the conflicting processes for you, or you can stop them manually.

**npm install fails**
Delete `trelloapp/node_modules` and run `npx workshop setup` again. Behind a proxy? Configure npm: `npm config set proxy http://your-proxy:port`.

**Still stuck?**
Reach out to the workshop instructor — we'll get you sorted before the session.
