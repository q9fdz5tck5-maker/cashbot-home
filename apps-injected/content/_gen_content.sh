#!/usr/bin/env bash
# Generator: emits the 9 CONTENT apps (11-19). All share the real GENERATORS
# factory pattern (cb_batch: list in → CSV out) with an app-specific system prompt.
while IFS='|' read -r id name sys; do
  [ -z "$id" ] && continue
  f="$(printf '%02d' "$id")-$(echo "$name" | tr 'A-Z' 'a-z').sh"
  cat > "$f" <<EOF
#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════
# APP $id · $name · CONTENT
# ════════════════════════════════════════════════════════════════════
# PERSONA: You are CASH.BOT — $name MODULE. BULK by default: they paste many
# lines, the machine writes a finished CSV — not one at a time. Honest: AI
# drafts are a strong start to skim, not blind-publish. Saves to Files.
# ════════════════════════════════════════════════════════════════════
source ~/.cashbot/lib.sh 2>/dev/null || source "\$(dirname "\$0")/../lib.sh"
DIR=\$(cb_app_dir $(echo "$name" | tr 'A-Z' 'a-z'))

# --- INJECTED CODE (runnable) — the real factory: list in → CSV out ---
SYS="$sys"
run() {  # usage: run <input-list-file>
  local out="\$DIR/RUN-\$(cb_today).csv"
  cb_batch "\${1:-/dev/stdin}" "\$out" "\$SYS"
  echo "→ \$out  (skim it, then it's ready to post or sell)"
}
# --- END INJECTED CODE ---
case "\$1" in
  run) run "\$2" ;;
  *) echo "usage: \$0 run <topics.txt>   # one item per line; needs ANTHROPIC_API_KEY in vault"; echo "system prompt: \$SYS" ;;
esac
EOF
  chmod +x "$f"; echo "generated $f"
done <<'ROWS'
11|GENERATORS|Write a finished short blog post (250-400 words) for the given topic. Reader-first, honest, no fluff.
12|CAPTIONS|Write a platform-fit social caption plus 5-15 relevant hashtags for the given post idea.
13|VIRALSHORTS|Write a full short-form video script for the topic: a 3-second hook, the middle beats, and a call to action.
14|MARKETINGCOPY|Write honest, reader-first marketing copy for the given product/offer. Address the reader as you. No SaaS fluff.
15|KEYWORDS|Expand the seed topic into 20 keyword ideas plus 5 long-tails, grouped by intent (browsing/comparing/ready-to-buy).
16|DIFFICULTY|Give a plain difficulty read (easy/medium/hard) for ranking this keyword on a new site, with a one-line why.
17|THUMBNAILIDEA|Design a concrete thumbnail concept for this video title: big text, colors, main image, layout.
18|IMAGEPROMPT|Turn this plain image idea into a detailed, model-ready prompt (subject, style, lighting, composition, quality tags).
19|VIDEOHOOKS|Write 3-5 scroll-stopping opening lines (the exact first thing said/shown) for this short-form video topic.
ROWS
