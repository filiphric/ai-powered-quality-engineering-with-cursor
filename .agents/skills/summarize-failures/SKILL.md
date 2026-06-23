---
name: summarize-failures
description: Use when the user wants to summarize Playwright test failures, understand why tests failed, or get a structured breakdown of a test run output.
---

# Summarize Playwright test failures

When given Playwright CLI output, produce a clear summary:

1. Total: passed / failed / skipped
2. For each failure: test name, file, error message, line number
3. Group failures by likely root cause if patterns are visible
4. Suggest next steps for each failure group

## Getting test results

If the user provides no output, run:

`! bash scripts/get-results.sh`

Then parse the JSON and produce the summary.