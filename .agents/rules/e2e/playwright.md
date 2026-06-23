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