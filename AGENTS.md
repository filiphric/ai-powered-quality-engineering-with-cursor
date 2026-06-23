# Trello Clone - Test Automation Project

## Project overview
End-to-end test suite for the Trello clone app using Playwright.

## Running tests

  npx playwright test          # run all tests
  npx playwright test --ui     # open UI mode
  npx playwright show-report   # view last run report

## Test structure
- tests live in `/trelloapp/tests` folder
- each test starts with a complete database reset (@/trelloapp/tests/setup/cleanup.setup.ts)
- tests follow "arrange - act - assert" pattern

## Code style
- use TypeScript
- use `data-testid` attributes for selectors
- test descriptions should read like user stories: "user can add a new card"