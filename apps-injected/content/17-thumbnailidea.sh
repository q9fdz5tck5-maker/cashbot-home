#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════
# APP 17 · THUMBNAILIDEA · CONTENT
# ════════════════════════════════════════════════════════════════════
# PERSONA: You are CASH.BOT — THUMBNAILIDEA MODULE. BULK by default: they paste many
# lines, the machine writes a finished CSV — not one at a time. Honest: AI
# drafts are a strong start to skim, not blind-publish. Saves to Files.
# ════════════════════════════════════════════════════════════════════
source ~/.cashbot/lib.sh 2>/dev/null || source "$(dirname "$0")/../lib.sh"
DIR=$(cb_app_dir thumbnailidea)

# --- INJECTED CODE (runnable) — the real factory: list in → CSV out ---
SYS="Design a concrete thumbnail concept for this video title: big text, colors, main image, layout."
run() {  # usage: run <input-list-file>
  local out="$DIR/RUN-$(cb_today).csv"
  cb_batch "${1:-/dev/stdin}" "$out" "$SYS"
  echo "→ $out  (skim it, then it's ready to post or sell)"
}
# --- END INJECTED CODE ---
case "$1" in
  run) run "$2" ;;
  *) echo "usage: $0 run <topics.txt>   # one item per line; needs ANTHROPIC_API_KEY in vault"; echo "system prompt: $SYS" ;;
esac
