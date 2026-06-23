# Chapter 2: Context Engineering

## Prompt Engineering vs. Context Engineering

Prompt engineering is about the *words* you use — techniques like role prompting, chain-of-thought, or the classic "Act as a...". Despite its popularity, these linguistic patterns have limited real impact. Research has shown that telling an LLM it's a genius doesn't actually make it one.

Context engineering is a fundamentally different concept, not an evolution of prompt engineering. Where prompt engineering is about phrasing, **context engineering is about information architecture** — what the model knows when it starts working. It's a more useful mental model for anyone working seriously with AI agents.

## The Context Window

The context window is everything an LLM can "see" at once. Think of it like RAM — there's a hard limit, and everything active must fit inside it. The context window contains:

- Your messages and the agent's responses
- Files and tools it's been given
- Any injected memory or instructions

## LLMs Are Stateless

LLMs have no memory between turns. Every time you send a message, the entire conversation history is sent along with it. The model isn't remembering — it's re-reading the full thread each time and completing the next part. This means **longer conversations = more tokens = more to process**.

## The Long Context Problem

Larger context windows (some models advertise 1M+ tokens) don't automatically mean better performance. "Needle in a haystack" benchmarks — where a specific piece of information is hidden inside a long document — consistently show performance degradation as context grows. More context means more noise the model has to work through.

## The Smart Zone

There's a region of conversation length where models perform best: short enough to hold everything in mind, make good connections, understand the task clearly, and stay on track. This is the **smart zone**.

- Short context → better connections, fewer mistakes, clearer intent
- Long context → drift, confusion, missed details

The goal when working with any AI agent (Cursor, Claude Code, ChatGPT) is to keep it in the smart zone. Pay attention to how long a conversation has been running.

## Staying in the Smart Zone

Concrete tactics for maintaining performance:

- **Start a new chat** when a task is complete — don't drag old context into new work
- **Launch sub-agents** for parallel or isolated tasks, each with a clean context window
- **Split work** into smaller, self-contained tasks
- **Spec-driven development** — define a spec, hand it to the agent, let it work in its own context window

The natural follow-on question: if you're always starting fresh, how does your agent know about your project? That's where instruction files come in — they carry project knowledge across sessions without bloating the conversation history.

## Key Takeaways

- Prompt engineering is about words; **context engineering is about information**
- LLMs are stateless — every turn re-reads the whole history
- Long contexts cause real performance degradation
- Stay in the **smart zone**: shorter, focused conversations
- Use instruction files to carry project knowledge across sessions