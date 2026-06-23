---
name: Bump version
description: Bump the version of the project
allowed_tools: gh, git, npm
---

1. update version in @package.json
2. add new tag to git
3. push the tag using github cli
4. create a new github release with the new version according to semver