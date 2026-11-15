---
name: project-sync
description: Sync this project's main branch with upstream, and optionally rebase the current feature branch onto it.
disable-model-invocation: true
---

# Sync with upstream

Before every git command that changes something, say in one sentence what it does.
Never use `reset --hard`, `push --force` (without `--with-lease`) or `clean`.

## 1. Check the starting point
- Run `git status --porcelain`. If anything is listed, stop and ask the developer to commit or stash it first.
- Remember the current branch: `git branch --show-current`.
- Work out the clone type:
  - `git config --get workflow.maintainer` prints `true`: **maintainer clone**. Remote = `origin`, base = `origin/main`.
  - Otherwise: **contributor fork**. Remote = `upstream`, base = `upstream/main`.
    If `upstream` is missing, add it with `git remote add upstream https://github.com/tesons/claude-code-playground.git`,
    then run `git config remote.upstream.pushurl DISABLED`.

## 2. Update main
```
git fetch <remote>
git switch main
git merge --ff-only <base>
```
- If `--ff-only` fails, local `main` has commits that aren't in upstream, which breaks the rule against committing to main.
  Stop. Show those commits with `git log --oneline <base>..main` and explain. Suggest moving them to a
  feature branch. Don't fix it without the developer's agreement.
- **Contributor fork only:** push the updated main to the fork with `git push origin main`.
  Maintainers never push main. It moves only through merged PRs.

## 3. Rebase the feature branch (if you started on one)
If the starting branch wasn't `main`:
- Switch back to it: `git switch <branch>`.
- If `git merge-base --is-ancestor <base> HEAD` succeeds, it's already up to date. Say so and stop.
- Otherwise ask: "Rebase `<branch>` onto the latest `<base>`?" If yes, run `git rebase <base>`.
  - On a conflict: list the files, explain what a conflict is, and resolve each one only with the
    developer's agreement. Then `git add <file>` and `git rebase --continue`. If they want to give up,
    run `git rebase --abort`, which returns everything to how it was before.
  - If the branch was already pushed (`git ls-remote --heads origin <branch>` is not empty), the fork
    needs `git push --force-with-lease origin <branch>`. Explain why: the rebase rewrote its commits. Ask first.

## 4. Report
In 2–4 lines: the commit `main` is now at (`git log --oneline -1 main`), whether the fork was pushed,
and the state of the feature branch.
