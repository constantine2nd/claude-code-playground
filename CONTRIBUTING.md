# Contributing

This project uses a **fork workflow**. You never push to the main repo
(`tesons/claude-code-playground`). Instead, you push to your own fork and open a
pull request from it.

| Remote     | Points to                                   | You can push? |
|------------|---------------------------------------------|---------------|
| `origin`   | your fork: `<your-username>/claude-code-playground` | yes           |
| `upstream` | `tesons/claude-code-playground`             | **no**        |

## First-time setup

1. On GitHub, open https://github.com/tesons/claude-code-playground and click **Fork**.
2. Clone **your fork**, not the original repo:
   ```
   git clone git@github.com:<your-username>/claude-code-playground.git
   cd claude-code-playground
   ```
3. Add the original repo as `upstream`, and block pushing to it:
   ```
   git remote add upstream https://github.com/tesons/claude-code-playground.git
   git config remote.upstream.pushurl DISABLED
   ```
   If you use Claude Code, you can skip this step: it runs automatically when a session starts.
4. Check the result:
   ```
   git remote -v
   ```

If `origin` shows `tesons/...`, you cloned the original repo instead of your fork.
Fix it with `git remote set-url origin git@github.com:<your-username>/claude-code-playground.git`.

## Shortcuts in Claude Code

If you use Claude Code, these project skills (names starting with `project-`) do the steps below for you:

| Command | What it does |
|---|---|
| `/project-start-change <description>` | Creates a branch like `feature/<name>` from the latest `upstream/main` |
| `/project-sync` | Updates `main` from upstream, and optionally rebases your branch |
| `/project-open-pr` | Runs the checks, pushes your branch, and opens the PR against `tesons` |
| `/project-finish` | After the merge: syncs `main` and deletes the branch |

The manual commands are below, for working without Claude or for understanding what the skills do.

## Daily workflow

Start every change from the latest `upstream/main`, on a new branch:
```
git fetch upstream
git switch --no-track -c feature/<short-desc> upstream/main
```
Branch names must start with `feature/`, `fix/` or `docs/`.
`--no-track` stops the branch from tracking `upstream/main`. Your first
`git push -u origin …` makes it track your fork's copy of the branch instead.

Keep your fork's `main` in sync. Never commit to `main` directly.
```
git fetch upstream
git switch main
git merge --ff-only upstream/main
git push origin main
```

Before opening a PR, rebase your branch onto the latest upstream:
```
git fetch upstream
git rebase upstream/main
git push --force-with-lease origin feature/<short-desc>
```

## Opening a pull request

```
git push -u origin feature/<short-desc>
gh pr create --repo tesons/claude-code-playground --base main --head <your-username>:feature/<short-desc>
```
You can also use the **Compare & pull request** button on GitHub. Check that the base
repository is `tesons/claude-code-playground` and the base branch is `main`.

Before opening a PR:
- Make sure tests and linters pass.
- Keep each PR to one logical change.
- Write commit messages in the imperative mood ("Add X", not "Added X").

## Maintainers

Maintainers have write access to `tesons/claude-code-playground` and work from a clone of it
rather than from a fork. Mark that clone once, so Claude Code and the setup hook treat it
as a maintainer clone:
```
git config workflow.maintainer true
```
The process is the same as for contributors, except that branches live in the original repo:
```
git fetch origin
git switch --no-track -c docs/<short-desc> origin/main
git push -u origin docs/<short-desc>
```
Then open the PR in the browser. **Never push to `main` directly**, not even as a
maintainer. Every change goes in through a reviewed PR.
