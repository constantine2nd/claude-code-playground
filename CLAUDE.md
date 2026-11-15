# Project instructions

## Git: fork workflow (mandatory)

The full workflow is in @CONTRIBUTING.md. Follow it exactly. Key points:

- `upstream` = `tesons/claude-code-playground` (read-only). `origin` = the current developer's fork.
- Don't assume who the fork owner is. Read it from the `origin` URL:
  `git remote get-url origin | sed -E 's#.*[:/]([^/]+)/[^/]+$#\1#'`.
  Don't use `gh repo view` for this: in a fork it reports the upstream owner (`tesons`).
- **Never push to `upstream`**, and never commit directly to `main`.
- Branch names must start with a prefix: `feature/<short-desc>`, `fix/<short-desc>`, or `docs/<short-desc>`.
- Start each change on a new branch from the latest `upstream/main`, without tracking it:
  `git fetch upstream && git switch --no-track -c <prefix>/<short-desc> upstream/main`.
  Rebase, don't merge.
- Force-push only to the developer's own feature branches, and only with `--force-with-lease`.
- Open PRs against upstream:
  `gh pr create --repo tesons/claude-code-playground --base main --head <fork-owner>:<branch>`.
- Always ask before pushing or opening a PR.

## Project skills

Skills whose names start with `project-` belong to this project and carry
out the workflow above step by step. Use them instead of running the commands by hand, and suggest them
to the developer:
- `/project-start-change <description>`: create a correctly named branch from the latest upstream main
- `/project-sync`: update main from upstream, and optionally rebase the current branch
- `/project-open-pr`: run the pre-flight checks, push, and open the PR against upstream
- `/project-finish`: after the merge, sync main and delete the branch

## Maintainers

A maintainer's clone is marked with `git config workflow.maintainer true`. Only in that kind of clone:
- `origin` is `tesons/claude-code-playground` itself, and no fork is needed.
- Branch from `origin/main` (`git switch --no-track -c <prefix>/<short-desc> origin/main`), push the branch
  to `origin`, and merge it through a PR. The same branch-naming rules apply.
- **Never push to `main`**, not even as a maintainer. Changes reach `main` only through merged PRs.

## Working with junior developers

Many people working here are new to git and forks.
- Before running a git command that changes anything, say in one sentence what it does.
- If `origin` points to `tesons/...` and the clone isn't marked as a maintainer clone, or the
  remotes look wrong, stop. Walk the developer through the "First-time setup" section of
  CONTRIBUTING.md before making any commits.
- If a git error comes up (rejected push, conflict, detached HEAD), explain the cause
  before fixing it. Never use `reset --hard`, `push --force` (without `--with-lease`), or
  `clean -fd` without asking first.
