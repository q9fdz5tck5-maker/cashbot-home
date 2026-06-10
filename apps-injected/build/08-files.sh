#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════
# APP 08 · FILES · BUILD · P0
# ════════════════════════════════════════════════════════════════════
# PERSONA:
# You are CASH.BOT — FILES MODULE. One clean, organized home for everything
# the machine makes, reachable from any device, backed up. Never delete or
# overwrite their files without asking. Their work is sacred.
# The glass break: opening one folder from their phone and seeing EVERYTHING.
# ════════════════════════════════════════════════════════════════════

source ~/.cashbot/lib.sh 2>/dev/null || source "$(dirname "$0")/../lib.sh"

# --- INJECTED CODE (runnable) ---

# STEP 1: build the full Apps/ tree (mirrors the real FILES app sync layout).
files_build_tree() {
  local apps="wallet trade faucethub pay ide terminal browser sites vnc \
generators captions viralshorts marketingcopy keywords difficulty thumbnailidea \
imageprompt videohooks leads scraper blast autopost email inbox community \
research analytics voice phone superfractal shell clients operation"
  for a in $apps; do mkdir -p ~/cashbot-files/Apps/"$a"; done
  printf '{"created":"%s","apps":%d}\n' "$(cb_today)" "$(echo $apps|wc -w)" > ~/cashbot-files/.structure.json
  echo "built $(echo $apps|wc -w) app folders under ~/cashbot-files/Apps/"
}

# STEP 4: real daily backup (never destructive — copies, keeps last 7 days).
files_backup() {
  local b=~/cashbot-files/.backup/$(cb_today); mkdir -p "$b"
  rsync -a --exclude='.backup' ~/cashbot-files/ "$b/" 2>/dev/null || cp -r ~/cashbot-files/Apps "$b/"
  # prune older than 7 days
  find ~/cashbot-files/.backup -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \; 2>/dev/null
  echo "backup → $b  (work survives now; older than 7d pruned)"
}

# STEP 3: open it from any device (private static file view).
files_open() { cb_serve ~/cashbot-files 8090; echo "private file view — keep behind a tunnel, never public"; }

# --- END INJECTED CODE ---
# POINT FORWARD → SITES (09) to host from this folder, IDE (05) to edit live, SUPERFRACTAL (31) to index it.

case "$1" in
  tree)   files_build_tree ;;
  backup) files_backup ;;
  open)   files_open ;;
  *) echo "usage: $0 {tree|backup|open}" ;;
esac
