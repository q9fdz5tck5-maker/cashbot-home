#!/usr/bin/env bash
# clone-and-host.sh — deep-clone a public site and host it on your own Pages site.
#
# What it does:
#   1. Mirrors a PUBLIC site at least TWO levels deep (home -> linked pages ->
#      the pages THOSE link to), with all images / CSS / JS / fonts, links
#      rewired so it works offline.
#   2. Drops the copy into clones/<name>/ inside THIS repo. Because this repo is
#      served by GitHub Pages (see CNAME), once you commit + push it goes live at
#      https://<your-domain>/clones/<name>/ — viewable from your phone.
#
# Honest use only: public pages, redesign reference. Don't pass a clone off as
# the original or your own work.
#
# Usage:
#   ./clone-and-host.sh https://freeaicash.com            # clone, 2 levels deep
#   ./clone-and-host.sh https://freeaicash.com 3          # go 3 levels deep
#   ./clone-and-host.sh https://freeaicash.com 2 --push   # clone AND push live
set -euo pipefail

URL="${1:-}"
DEPTH="${2:-2}"
PUSH="${3:-}"

if [ -z "$URL" ]; then
  echo "usage: $0 <url> [depth=2] [--push]" >&2
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST="$(printf '%s' "$URL" | sed -E 's#^https?://##; s#/.*$##; s#^www\.##')"
NAME="$(printf '%s' "$HOST" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9' '-' | sed -E 's/-+/-/g; s/^-|-$//g')"
DEST="$REPO_ROOT/clones/$NAME"
DOMAIN="$(cat "$REPO_ROOT/CNAME" 2>/dev/null || echo "your-pages-domain")"

echo "→ cloning $URL  (depth $DEPTH, domain $HOST)  →  clones/$NAME/"
mkdir -p "$DEST"

# Polite deep mirror: page requisites, offline link rewrite, stay on-domain,
# real user-agent, throttled so we never hammer the site.
wget \
  --mirror \
  --level="$DEPTH" \
  --page-requisites \
  --convert-links \
  --adjust-extension \
  --span-hosts \
  --domains="$HOST,www.$HOST" \
  --no-parent \
  --wait=1 --random-wait \
  --user-agent="Mozilla/5.0 (clone-and-host; redesign reference)" \
  --no-host-directories \
  --directory-prefix="$DEST" \
  "$URL" || true   # wget exits non-zero on partial fetches; the copy is still usable

PAGES=$(find "$DEST" -type f -name '*.html' 2>/dev/null | wc -l | tr -d ' ')
ASSETS=$(find "$DEST" -type f ! -name '*.html' 2>/dev/null | wc -l | tr -d ' ')
echo "✓ cloned: $PAGES pages, $ASSETS assets  →  $DEST"
echo "  preview locally:  (cd '$DEST' && python3 -m http.server 7900)  then open http://localhost:7900"
echo "  live URL once pushed:  https://$DOMAIN/clones/$NAME/"

if [ "$PUSH" = "--push" ]; then
  echo "→ pushing live…"
  cd "$REPO_ROOT"
  git add "clones/$NAME"
  git commit -q -m "clone: host $HOST at /clones/$NAME/ (redesign reference)"
  git push
  echo "✓ live (after Pages rebuilds, ~1 min):  https://$DOMAIN/clones/$NAME/"
else
  echo "→ to host it, run:  git add clones/$NAME && git commit -m 'clone $HOST' && git push"
fi
