#!/usr/bin/env bash
# SessionStart hook: makes sure this clone follows the fork workflow.
# - adds the `upstream` remote if missing
# - disables pushing to `upstream` (applies to humans too, not just Claude)
# - warns if `origin` is the upstream repo itself (i.e. no fork was made),
#   unless the clone is marked as a maintainer clone (git config workflow.maintainer true)
# Anything printed here is added to Claude's context for the session.

UPSTREAM_SLUG="tesons/claude-code-playground"
UPSTREAM_URL="https://github.com/${UPSTREAM_SLUG}.git"

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

if ! git remote get-url upstream >/dev/null 2>&1; then
  git remote add upstream "$UPSTREAM_URL"
  echo "Fork setup: added remote 'upstream' -> $UPSTREAM_URL"
fi

if [ "$(git config --get remote.upstream.pushurl)" != "DISABLED" ]; then
  git config remote.upstream.pushurl DISABLED
  echo "Fork setup: disabled pushing to 'upstream'."
fi

origin_url="$(git remote get-url origin 2>/dev/null)"
if [ "$(git config --get workflow.maintainer)" = "true" ]; then
  echo "Maintainer clone: branch from origin/main, push branches to origin, merge only via PRs; never push to main."
elif [[ "$origin_url" == *"$UPSTREAM_SLUG"* ]]; then
  echo "WARNING: 'origin' points to the upstream repo ($origin_url), not to a fork."
  echo "Tell the developer to fork $UPSTREAM_SLUG on GitHub and point origin at the fork"
  echo "(see CONTRIBUTING.md, 'First-time setup'). Do not push until this is fixed."
fi

exit 0
