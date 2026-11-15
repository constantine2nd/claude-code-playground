# Project instructions

## Git: fork workflow (mandatory)

The full workflow is in @CONTRIBUTING.md. Follow it exactly. Key points:

- `upstream` = `tesons/claude-code-playground` (read-only). `origin` = the current developer's fork.
- Don't assume who the fork owner is. Check with `git remote -v`, or get the
  owner with `gh repo view --json owner -q .owner.login`.
- **Never push to `upstream`**, and never commit directly to `main`.
- Start each change on a new branch from the latest `upstream/main`. Rebase, don't merge.
- Force-push only to the developer's own feature branches, and only with `--force-with-lease`.
- Open PRs against upstream:
  `gh pr create --repo tesons/claude-code-playground --base main --head <fork-owner>:<branch>`.
- Always ask before pushing or opening a PR.

## Working with junior developers

Many people working here are new to git and forks.
- Before running a git command that changes anything, say in one sentence what it does.
- If `origin` points to `tesons/...`, or the remotes look wrong, stop. Walk the developer
  through the "First-time setup" section of CONTRIBUTING.md before making any commits.
- If a git error comes up (rejected push, conflict, detached HEAD), explain the cause
  before fixing it. Never use `reset --hard`, `push --force` (without `--with-lease`), or
  `clean -fd` without asking first.
