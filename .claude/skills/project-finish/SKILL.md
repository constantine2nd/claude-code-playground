---
name: project-finish
description: Clean up after a pull request has been merged - sync main and delete the merged branch locally and on origin.
disable-model-invocation: true
argument-hint: [branch name, default = current branch]
---

# Finish a merged change

Before every git command that changes something, say in one sentence what it does.

## 1. Which branch
The branch to finish is $ARGUMENTS if given, otherwise the current branch (`git branch --show-current`).
If that's `main` and no argument was given, list local branches other than main and ask which one.

## 2. Confirm it was merged
Get the branch owner from the origin URL with `git remote get-url origin | sed -E 's#.*[:/]([^/]+)/[^/]+$#\1#'`. Then run:
```
gh pr list --repo tesons/claude-code-playground --head <branch> --state merged \
  --json number,url,headRepositoryOwner -q '.[] | select(.headRepositoryOwner.login=="<owner>") | .url'
```
The owner filter matters: `--head` matches only the branch name, so without it you could pick up
another contributor's PR for a branch with the same name.
- If it prints nothing, there's no merged PR for this branch. Stop. Explain that the branch isn't merged yet and nothing was deleted.
  If an open PR exists, show its URL.

## 3. Check the working tree
`git status --porcelain` must be empty. If it isn't and you're on that branch, stop and ask. Those changes
weren't part of the merged PR.

## 4. Sync main
Follow the same steps as `/project-sync` step 2: fetch, `switch main`, `merge --ff-only`, and for a contributor
fork, `git push origin main`.

## 5. Delete the branch
- **Locally:** `git branch -d <branch>`. If git refuses with "not fully merged" (this happens with
  squash or rebase merges), explain that GitHub merged the PR (step 2 confirmed it) under different
  commit IDs. Ask, then use `git branch -D <branch>`.
- **On origin:** if `git ls-remote --heads origin <branch>` shows it, ask, then run `git push origin --delete <branch>`.
  If it's already gone (GitHub can delete merged branches automatically), say so.
- Run `git fetch --prune origin` to drop stale remote references.

## 6. Report
In 2–3 lines: the commit main is now at, what was deleted, and a suggestion to run `/project-start-change` for the next piece of work.
