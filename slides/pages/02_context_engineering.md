---
layout: cover
---

Chapter #2:
# Context Engineering

---
layout: default
---
# What you'll learn

- What is the context window
- What context engineering
- Why long conversations hurt performance
- How to keep your agent smart

---
layout: two-cols
---
# Prompt engineering

- A set of linguistic patterns to get the right answer from an LLM
- Popular techniques: role prompting, chain-of-thought, style prompting...
- The famous **"Act as a..."**

::right::

![Prompt Taxonomy](/images/PromptTaxonomy.png)

<!--
- There's an idea called prompt engineering — the idea that if you use the right words, you unlock better answers
- There's a whole taxonomy of techniques: role-based prompts, emotion prompting, chain-of-thought, and many others
- One of the most popular is role-based prompting — the famous "Act as a senior engineer..."
- I want to be upfront: I'm not a huge fan of prompt engineering as a discipline
- Of course, giving clear instructions matters. But searching for magic patterns that unlock hidden potential? That doesn't really hold up
- Sander Schulhoff — the author of one of the most cited prompt engineering papers — found something interesting: when he compared "act as a Harvard-educated professor" vs "act as a complete idiot who can't do basic math", the idiot outperformed the professor
- Just because you tell an LLM it's a genius doesn't make it one
- Where prompt engineering IS genuinely interesting: AI security and prompt injection — that's a real field with real published research worth following
-->

---
layout: default
---
# Prompt engineering vs. Context engineering

- They are **not comparable** and not an evolution of one another
- Prompt engineering: *what words you use*
- Context engineering: *what information you put in front of the model*
- A better mental model for working effectively with AI agents

<!--
- Just because I'm mentioning these back to back doesn't mean context engineering is the next generation of prompt engineering — they're different things
- What I'm trying to give you is a mental model that helps you make better decisions when working with AI day to day
- Prompt engineering is about phrasing. Context engineering is about information architecture — what the model knows when it starts working
-->

---
layout: two-cols
---
# The context window

- Everything the LLM can "see" at once
- Think of it like **RAM** — there's a hard limit
- Contains: your messages, the agent's responses, files, tools, memory

::right::

![Context Window Empty](/images/ContextWindowV2.png)
::

<!--
- When you interact with an LLM, everything it can work with lives in the context window
- Think of it like your computer's RAM — there's a physical limit on how much can be active at once
- The context window holds your messages, the model's responses, any files or tools it's been given, and any injected memory
- This limit has real consequences, as we'll see
-->

---
layout: default
---
# LLMs are stateless

- Every message you send includes the **full conversation history**
- The model doesn't "remember" — it re-reads everything every time
- Longer conversation = more tokens = more to process

<!--
- Here's something people often don't realise: LLMs have no memory between turns
- Every time you send a message, your client sends the entire conversation history along with it
- The model isn't remembering — it's re-reading the whole thread and completing the next part, just like we were finishing sequences earlier
- So as your conversation grows, the amount of data being sent and processed grows with it
-->

---
layout: two-cols
---
# The long context problem

- Context windows can be 1M+ tokens — but bigger isn't automatically better
- "Needle in a haystack" benchmarks show performance drops at scale
- More context = more noise the model has to work through

::right::

![Context Window Empty](/images/LongContext.png)
::

<!--
- Some LLMs advertise context windows of 1 million tokens or more, and I'm genuinely skeptical of what that means in practice
- The size of the window doesn't tell you how well the model operates within it
- There are benchmarks like "needle in a haystack" — you hide a specific piece of information deep in a long document and ask the model to find it
- When Anthropic and OpenAI extend their context windows, they use these benchmarks to show improvements
- But critics point out: a model that scores well on the benchmark might just be operating on a bigger haystack — not actually getting better at finding the needle
- The graph tells the story — at some point, you see a drop-off in performance as context grows
-->

---
layout: two-cols
---
# The smart zone

- Short context → better connections, fewer mistakes, clearer intent
- Long context → drift, confusion, missed details
- **Goal: keep your agent in the smart zone**

::right::

![Smart Zone](/images/ContextWindowV3.png)
::

<!--
- If you want to get the most out of your AI agent, you need to keep it in what I call the smart zone
- This is the region where the conversation is short enough that the model can hold everything in mind, make good connections, understand the task, and stay on track
- When you start interacting with Cursor, Claude Code, or ChatGPT, keep a mental eye on how long the conversation has been running
- Shorter conversations = fewer errors, better output quality
-->

---
layout: default
---
# Staying in the smart zone

- **Start a new chat** when a task is done
- **Launch sub-agents** for parallel or isolated work
- **Split work** into smaller tasks with separate context windows
- Use **spec-driven development** — each spec lives in its own context

<!--
- There are concrete tactics for this
- Finish a task, open a new chat — don't drag yesterday's debugging session into today's feature work
- Sub-agents are great for parallelism and isolation — they each get a clean context to work in
- Spec-driven development is a natural fit here: you define a spec, hand it to the agent, it works in its own window, done
- But there's a catch: if you're always starting fresh, how does your agent know about your project?
-->


---
layout: center
---

# Demo

<!--

## Example 1 
- show context indicators in Cursor
- show statusline in Claude Code
- show /context
- install MCP and show /context

```
claude mcp add playwright npx @playwright/mcp@latest
```

## Example 2
https://code.claude.com/docs/en/context-window#explore-the-context-window

-->

---
layout: default
---
# Summary

- Prompt engineering is about words; **context engineering is about information**
- LLMs are stateless — every turn re-reads the whole history
- Long contexts cause real performance degradation
- Stay in the **smart zone**: shorter, focused conversations
- Use instruction files to carry project knowledge across sessions

<!--
- Context engineering is one of the highest-leverage skills for anyone working with AI agents
- You don't need to find magic prompts — you need to manage what the model knows and how long it's been running
- The patterns we've covered today apply to Cursor, Claude Code, and any other agent you work with
- In the next chapter we'll build the other side of this: the instruction files that let your agent start every session already knowing your project
-->