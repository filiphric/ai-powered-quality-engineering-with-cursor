# Chapter 1: Cursor Basics — Workshop Notes

## What is Cursor?
- AI-powered code editor built on VS Code
- Context-aware: understands your files, imports, and codebase
- Customizable: pick your model, set behavior rules, add tooling
- Supports MCP (Model Context Protocol) for extended capabilities

---

## Core Features

### Tab Completion
- Autocomplete suggestions based on current file context
- Works best when there's existing code to pattern-match against
- Also handles **refactoring** — e.g. fix a locator in one place, Tab propagates the change elsewhere

### Chat
- Like ChatGPT, but IDE-integrated with codebase awareness
- Add context by referencing files (e.g. `@ComponentName.vue`)
- AI follows patterns it sees in your existing tests
- Reference source components to get accurate test logic — no need to fully understand the app internals

### Inline Edits
- Focus AI on a specific section of code
- Best for: refactoring, understanding unfamiliar code, scoped edits
- Example: select 3 tests → prompt to merge them into one with test steps

---

## Tips
- Set a keyboard shortcut to toggle tab completion on/off
- Use ↑ arrow in chat to recall previous prompts
- Always give the AI relevant file context for accurate output

## Resources
- [Cursor documentation](https://www.cursor.com/docs)
- [Cursor learning center](https://cursor.com/learn)