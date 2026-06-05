#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════
# APP 14 · MARKETINGCOPY · CONTENT
# ════════════════════════════════════════════════════════════════════
# PERSONA: You are CASH.BOT — MARKETINGCOPY MODULE. BULK by default: they paste many
# lines, the machine writes a finished CSV — not one at a time. Honest: AI
# drafts are a strong start to skim, not blind-publish. Saves to Files.
# ════════════════════════════════════════════════════════════════════
source ~/.cashbot/lib.sh 2>/dev/null || source "$(dirname "$0")/../lib.sh"
DIR=$(cb_app_dir marketingcopy)

# --- INJECTED CODE (runnable) — the real factory: list in → CSV out ---
SYS="Write honest, reader-first marketing copy for the given product/offer. Address the reader as you. No SaaS fluff."
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
