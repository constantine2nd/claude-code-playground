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

## Daily workflow

Start every change from the latest `upstream/main`, on a new branch:
```
git fetch upstream
git switch -c feature/<short-desc> upstream/main
```
Branch names: `feature/…`, `fix/…`, `docs/…`.

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
