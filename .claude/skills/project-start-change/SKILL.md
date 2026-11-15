---
name: project-start-change
description: Start a new change in this project - creates a correctly named branch from the latest upstream main, following the fork workflow. Use when the developer wants to begin work on a feature, fix or docs change.
argument-hint: <short description of the change>
---

# Start a new change

The developer wants to start: **$ARGUMENTS**

Before every git command that changes something, say in one sentence what it does.

## 1. Check the working tree
Run `git status --porcelain`. If anything is listed, stop and ask the developer what to do:
commit it, stash it (`git stash push -m "<desc>"`), or cancel. Never discard changes.

## 2. Work out the clone type and the base branch
- If `git config --get workflow.maintainer` prints `true`, this is a **maintainer clone**: remote = `origin`, base = `origin/main`.
- Otherwise it's a **contributor fork**: remote = `upstream`, base = `upstream/main`.
  If the `upstream` remote is missing, stop and tell the developer to run `/project-sync` or to follow
  "First-time setup" in CONTRIBUTING.md.

## 3. Pick the branch name
- Prefix: `feature/` for new behavior, `fix/` for bug fixes, `docs/` for documentation only.
- Name: lowercase kebab-case, 2–5 words, from the description. Example: `feature/add-editorconfig`.
- If no description was given, ask for one.
- Check that the name is free: `git branch --list <name>` and `git ls-remote --heads origin <name>`.
  If it's taken, suggest another name.
- Tell the developer the name you chose. If they gave a different name, use theirs, as long as it has a valid prefix.

## 4. Create the branch
```
git fetch <remote>
git switch --no-track -c <branch> <base>
```
`--no-track` keeps the branch from tracking main. The first push makes it track the copy on `origin`.

## 5. Report
In 2–3 lines: the branch name, which commit it starts from (`git log --oneline -1`), and that
nothing has been pushed. Suggest `/project-open-pr` when the work is ready.
