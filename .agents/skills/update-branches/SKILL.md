---
name: Update branches
description: Workflows related to updating branches
allowed-tools: git
---

There are two tasks:

## Task #1 - branch names
- making sure the branch names are same everywhere. Branch names are mentioned in @scripts/check-update.sh, bin/workshop.js, @scripts/chapter.sh and @README.md
- unless mentioned otherwise, @README.md is the source of truth

## Task #2 - updating branches
- all the branches have numbers and they should be rebased on top of one another
- when asking to update branches, your task is to rebase branch chapter/01-<name> on top of main, chapter/02<name> on top of chapter/01-<name> and so on