---
name: project-open-pr
description: Run the pre-flight checks, push the current branch and open a pull request against tesons/claude-code-playground.
disable-model-invocation: true
argument-hint: [optional PR title]
---

# Open a pull request

Upstream repo: `tesons/claude-code-playground`, base branch `main`.
Before every git command that changes something, say in one sentence what it does.

## 1. Pre-flight checks
Run all of these. If any fails, stop, explain it in plain language, and say how to fix it.

1. **Clone type:** `git config --get workflow.maintainer` prints `true` → maintainer (base remote `origin`).
   Otherwise contributor (base remote `upstream`). Base = `<remote>/main`.
2. **Branch:** `git branch --show-current` must not be `main`, and it must match
   `^(feature|fix|docs)/[a-z0-9][a-z0-9-]*$`. If it doesn't, offer `git branch -m <new-name>`.
3. **Clean tree:** `git status --porcelain` must be empty.
4. **Up to date:** run `git fetch <remote>`, then `git merge-base --is-ancestor <base> HEAD`. If that fails,
   the branch is behind upstream: offer to run `/project-sync`, which rebases it.
5. **Has commits:** `git log --oneline <base>..HEAD` must not be empty.
6. **Tests:** look for the project's test command (CONTRIBUTING.md, package.json, Makefile, etc.)
   and run it. If there isn't one, say "no test command found" and continue.

Then show a summary: the branch, its commits (`git log --oneline <base>..HEAD`), the changed files
(`git diff --stat <base>...HEAD`), and the test result.

## 2. Push the branch
Ask for confirmation, then run:
- First push: `git push -u origin <branch>`.
- If the branch was pushed before and has been rebased since, use `git push --force-with-lease origin <branch>`, and explain why.

## 3. Open or update the PR
- **Branch owner:** read it from the origin URL with `git remote get-url origin | sed -E 's#.*[:/]([^/]+)/[^/]+$#\1#'`.
  Don't use `gh repo view`, which reports `tesons` inside a fork.
- **Existing PR?** Run:
  `gh pr list --repo tesons/claude-code-playground --head <branch> --state open --json url,headRepositoryOwner -q '.[] | select(.headRepositoryOwner.login=="<owner>") | .url'`
  `--head` matches only the branch name; the owner filter keeps you from picking up another contributor's PR.
  If it prints a URL, the push already updated that PR. Show the URL and stop.
- **gh account:** `gh api user -q .login`.
  - If it matches the branch owner, run:
    `gh pr create --repo tesons/claude-code-playground --base main --head <owner>:<branch> --title "<title>" --body "<body>"`
  - If it doesn't match (e.g. a maintainer clone, where gh is logged in as a contributor account), do **not** use gh,
    or the PR would be authored by the wrong account. Give the developer this link to open while signed in as `<owner>`:
    `https://github.com/tesons/claude-code-playground/compare/main...<owner>:<branch>?expand=1`
    along with the title and body to paste.
- **Title:** use $ARGUMENTS if given. Otherwise, the subject of the first commit if there's one commit, or a short imperative summary.
- **Body template:**
  ```
  ## Summary
  <1-3 sentences: what and why>

  ## Changes
  - <one bullet per logical change>

  ## Spec
  <path in docs/specs/ if this implements one, otherwise "n/a">

  ## Testing
  <command run and result, or "no test command">
  ```

## 4. Report
The PR URL (or the compare link), and what happens next: a maintainer reviews it. Fix review comments
on the same branch and push again; the PR updates automatically. After the merge, run `/project-finish`.
