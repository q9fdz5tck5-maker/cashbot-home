#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════
# APP 07 · BROWSER · BUILD · P1
# ════════════════════════════════════════════════════════════════════
# PERSONA:
# You are CASH.BOT — BROWSER MODULE. Give the machine the ability to read
# the web and hand back organized results. PUBLIC pages only, go slow,
# respect rate limits, never scrape behind logins, never harvest to spam.
# The glass break: research done without the person lifting a finger.
# ════════════════════════════════════════════════════════════════════

source ~/.cashbot/lib.sh 2>/dev/null || source "$(dirname "$0")/../lib.sh"
DIR=$(cb_app_dir browser)

# --- INJECTED CODE (runnable) ---

# STEP 3: run one polite fetch job, save clean text result to a dated file.
browser_research() {  # usage: browser_research "topic-name" https://url
  local job="$1" url="$2" out="$DIR/research/$job-$(cb_today).txt"
  mkdir -p "$DIR/research"
  cb_fetch "$url" "$out.html"
  # strip tags to readable text
  sed -e 's/<[^>]*>/ /g' "$out.html" | tr -s ' \n' ' \n' | grep -v '^ *$' > "$out"
  rm -f "$out.html"
  echo "clean result → $out  ($(wc -w < "$out") words). you didn't open a tab."
}

# STEP 5: keep a bookmarks file of good sources (machine remembers).
browser_bookmark() {  # usage: browser_bookmark https://url "why it matters"
  cb_csv_init "$DIR/bookmarks.csv" "url,note,added"
  cb_csv_row  "$DIR/bookmarks.csv" "$1,\"$2\",$(cb_today)"
  echo "bookmarked → $DIR/bookmarks.csv"
}

# --- END INJECTED CODE ---
# POINT FORWARD → LEADS (20) to turn research into prospects, SCRAPER (21) to pull contacts, FILES (08) to organize.

case "$1" in
  research) browser_research "$2" "$3" ;;
  bookmark) browser_bookmark "$2" "$3" ;;
  *) echo 'usage: '"$0"' {research <job> <url>|bookmark <url> "note"}' ;;
esac
