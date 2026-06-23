---
layout: cover
---

Chapter #6:
# Code Governance
`npx workshop chapter 6`

---
layout: default
---

# What you'll learn

- Why AI-generated code creates a governance problem
- What code governance means in the age of AI coding
- How Qodo closes the loop between standards and review
- Demo: AI code review on a Playwright test pull request
- How to create and enforce Playwright-specific coding rules

---
layout: default
---

# The new problem

- AI writes code *fast* — faster than any human reviewer can keep up with
- Volume is no longer the bottleneck. **Quality is.**
- Your team now ships 3× the code. But who's reviewing it?

<!--
Let's set the scene. You've been in this workshop for a while now. You've learned how to use AI to write tests faster, generate fixtures, work with agents, and even build your own skills.

Here's the uncomfortable part: all of that velocity creates a new problem.

When a developer could write 200 lines a day, a senior engineer could review it. When they write 600 lines with AI assistance, that same review process falls apart.

The math doesn't work. You can't just review faster. The bottleneck has shifted.

And in test automation specifically, this matters a lot. Poorly written tests are often worse than no tests at all. They're flaky. They test implementation details instead of behaviour. They don't follow your team's conventions. They slow down CI.

AI will happily generate all of that for you.
-->

---
layout: default
---

# Code governance

- A system that **captures**, **enforces**, and **evolves** your team's coding standards
- Not a linter. Not a style guide doc. Not a one-time review.
- A *living* process that scales with your team

<!--
Code governance is a term that gets thrown around a lot, but here's what I mean by it.

It's not a single tool or a policy document. It's a system — something that:
- Captures what good code looks like for your specific team and codebase
- Enforces those standards consistently, on every PR, without a human having to remember
- Evolves as your team grows, your codebase changes, and new patterns emerge

Think about how much institutional knowledge lives inside your senior engineers' heads. The "we don't use `page.waitForTimeout` here" or "all selectors should use data-testid attributes". That knowledge rarely makes it into a linter rule, and it almost never survives team changes.

Governance is the mechanism for externalising and systematising that knowledge.
-->

---
layout: default
---

# The AI code review gap

- AI writes more code → more PRs → reviews become a bottleneck
- Standard linters catch syntax, not *intent*
- Human reviewers can't scale to match AI velocity
- What you need: a reviewer that **understands your codebase**

<!--
This is the gap that AI code review is designed to fill.

Traditional linters are great at catching syntax issues and style violations, but they don't understand what the code is trying to do. They can't tell you that this test is checking the wrong assertion, or that this page object duplicates logic from another file, or that this test will be flaky because it depends on network timing.

Human reviewers can catch all of that — but only if they have time. And at AI velocity, they don't.

What you need is a reviewer that has the same context a senior engineer has: knows the codebase, knows the patterns, knows the conventions, and can apply all of that to every single PR automatically.

That's what we're going to look at today.
-->

---
layout: default
---

# Qodo

- The **AI Code Review Platform** — the missing quality layer in your AI stack
- Combines a **rules system** with **context-aware review agents**
- Integrates directly into your Git workflow (GitHub, GitLab, Bitbucket, Azure DevOps)
- Reviews PRs with full codebase context — not just the diff

<!--
Qodo is the tool we'll be looking at today. The reason I chose it for this chapter is that it was built for exactly this problem.

There are two distinct things Qodo does, and they work together:

First, there's the rules system. This is where your team's coding standards live. Rules can be created manually, but Qodo also discovers them automatically from your codebase patterns and PR history. If your senior engineers keep leaving the same comment on PRs, Qodo will notice and suggest turning it into a rule.

Second, there are the review agents. These are the reviewers. They have access to your full codebase — not just the changed files — so they can reason about architecture, duplication, dependencies, and compliance with your rules.

Together, these form a closed loop: rules feed the review, and the review feeds the rules.
-->

---
layout: default
---

# The closed loop

```
  Codebase patterns          Review agents
  PR history         →  →  → enforce standards
        ↑                          |
        |                          ↓
  Rules evolve   ←  ←  ←   Recurring comments
                            suggest new rules
```

- Standards that **create and maintain themselves**
- One source, many surfaces: rules live in one portal, enforced everywhere

<!--
This diagram is the core idea behind how Qodo 2.0 works.

On one side you have the rules system — it learns from your codebase and your PR history. Every time a reviewer leaves the same comment twice, that's a candidate for a rule.

On the other side you have the review agents — specialized agents that use your rules, plus full codebase context, to review every PR.

The loop closes because review data feeds back into rules. Analytics tell you which rules are helping and which are noise. Recurring feedback patterns suggest new rules.

The result is a standards system that doesn't require constant manual maintenance. It gets smarter over time.

For a test automation context: imagine Qodo learning that your team always uses getByRole instead of locator. It creates a rule. Now every PR that uses locator gets flagged — automatically, without a human needing to remember.
-->

---
layout: center
---

# Demo
## Qodo PR review on a Playwright test pull request

<!--
## Demo: Qodo PR review on a Playwright test repo

### What you'll show

A pull request with new Playwright tests. Qodo reviews it, surfaces issues, and enforces rules specific to your Playwright conventions.

### Setup (before the demo)

1. Install the Qodo Git Plugin on your GitHub account (https://github.com/apps/qodo-gen)
2. Fork or use the workshop repo — it should already have a few Playwright tests
3. Create a feature branch with deliberately imperfect tests:

```typescript
// tests/checkout.spec.ts — intentionally problematic

test('checkout flow', async ({ page }) => {
  await page.goto('http://localhost:3000/checkout')

  // Bad: hardcoded wait instead of waiting for element
  await page.waitForTimeout(2000)

  // Bad: fragile selector — class-based
  await page.click('.btn-primary')

  // Bad: locator instead of getByRole
  const confirmButton = page.locator('#confirm-order')
  await confirmButton.click()

  // Weak assertion — only checks URL, not content
  await expect(page).toHaveURL('/order-confirmation')
})
```

4. Open a pull request from the feature branch into main

### Step 1 — Show the PR before Qodo reviews it

- Point out the issues manually (hardcoded wait, fragile selectors, weak assertion)
- "This is the kind of code that gets merged when velocity is high and review is rushed"

### Step 2 — Trigger a Qodo review

- Add the `@qodo-gen review` comment to the PR, or wait for auto-review (if configured)
- Show the review appearing in the PR comments

### Step 3 — Walk through Qodo's findings

Point out each finding:
- The `waitForTimeout` flagged as a reliability risk (suggest `waitForSelector` or `waitForLoadState` instead)
- The class-based selector flagged as fragile (suggest `data-testid` or role-based selector)
- The `locator('#confirm-order')` flagged against your rules (if you've set up a rule preferring `getByRole`)
- The weak URL-only assertion noted as insufficient coverage

Show that each finding has:
- A severity label
- A clear explanation of *why* it's an issue
- A suggested fix

### Step 4 — Show a Playwright-specific rule (optional, 3–4 minutes)

Navigate to the Qodo rules portal.

Show a rule like:

> **Prefer role-based selectors**
> Use `getByRole`, `getByLabel`, or `getByText` instead of `locator()` with CSS selectors or IDs. Role-based selectors are more resilient to markup changes and better reflect user-facing behaviour.

Point out:
- The rule has a description, examples, and severity
- It was enforced automatically on the PR without any extra configuration
- This is the kind of rule that previously lived only in a senior engineer's head

### Wrap up the demo

"What we just saw is the closed loop in action. We have a rule that captures a team convention. A PR comes in that violates it. Qodo catches it automatically — before a human has to spend time on it. The developer gets a clear explanation and a suggested fix. The senior engineer's time is freed up for the review decisions that actually require judgement."

-->

---
layout: default
---

# What Qodo catches in test code

| Issue type | Example |
|---|---|
| Flakiness risks | `waitForTimeout`, time-dependent assertions |
| Fragile selectors | Class or ID-based selectors that break on markup change |
| Missing assertions | Tests that navigate but don't assert meaningful state |
| Convention violations | Any pattern your team has defined as a rule |
| Duplication | Test logic that already exists in a page object or fixture |

<!--
Let me be concrete about the kinds of issues Qodo surfaces in a Playwright codebase specifically.

Flakiness is the big one. Tests that use waitForTimeout are going to fail in CI on a slow day. Qodo catches these.

Fragile selectors — locators that depend on CSS classes or auto-generated IDs — will break every time your frontend team refactors a component. Qodo can be configured to prefer data-testid attributes or role-based selectors.

Missing assertions are subtle but important. A test that clicks through a flow but only checks the final URL isn't really verifying much. Qodo's agents can reason about assertion coverage.

Convention violations are where the rules system really shines. Whatever standards your team has — page object patterns, fixture organisation, test naming conventions — all of that can become enforceable rules.

And duplication is something that only a tool with full codebase context can catch. If you've already built a login helper and a new test is reimplementing login from scratch, only a reviewer that can see the whole repo will notice.
-->

---
layout: default
---

# Rules for Playwright teams

- **Selector standards** — prefer `getByRole`, `getByLabel`, `getByTestId`
- **No raw waits** — flag `waitForTimeout`, require semantic waits
- **Assertion depth** — require assertions that verify content, not just URL
- **Page object conventions** — enforce where and how selectors are defined
- **Test isolation** — flag tests that share state or depend on execution order

<!--
Let me give you a practical starting point for rules that matter in a Playwright test codebase.

These aren't just style preferences — each of these rules exists because violating them causes real problems in CI.

Selector standards: role-based and label-based selectors are resilient. CSS class selectors break when UI changes. Encoding this as a rule means every PR gets checked automatically.

No raw waits: waitForTimeout is a smell. It means the test is waiting for *time* instead of waiting for *state*. Replace with waitForSelector, waitForResponse, or waitForLoadState depending on context.

Assertion depth: a test that only checks toHaveURL is checking navigation, not behaviour. Most pages should have at least one content assertion.

Page object conventions: if your team follows page object model, Qodo can enforce that selectors live in page objects and not inline in test files.

Test isolation: tests that modify shared state or depend on running in a specific order are a source of intermittent failures. These are subtle and hard to catch in review — Qodo can flag patterns that suggest shared state.
-->

---
layout: default
---

# The shift

| Before | After |
|---|---|
| Standards live in docs and people's heads | Standards live in Qodo's rules portal |
| Inconsistent review depending on who reviews | Every PR gets the same review |
| Senior engineers review boilerplate | Senior engineers review architecture |
| Flaky tests slip through | Flakiness patterns flagged before merge |

<!--
I want to close with this framing because it captures why governance matters beyond just "catching bugs."

The goal isn't to replace human reviewers. It's to change *what* human reviewers spend their time on.

Right now, senior engineers burn review time on things that could be automated: selector choices, assertion patterns, naming conventions, obvious flakiness. That's not a good use of their time.

Qodo handles the systematic stuff. That frees reviewers to focus on what actually requires judgement: architecture decisions, edge case coverage, test strategy, business logic correctness.

That's the shift. Not AI instead of humans — AI handling the parts that don't need human judgement, so humans can focus on the parts that do.
-->