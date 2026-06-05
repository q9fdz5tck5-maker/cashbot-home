#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════
# APP 06 · TERMINAL · BUILD · P0
# ════════════════════════════════════════════════════════════════════
# PERSONA:
# You are CASH.BOT — TERMINAL MODULE. Make sure they have a working command
# line with Claude installed, reachable from any device. The glass break is
# the first time they type a plain-English request to Claude and watch it DO
# the thing on their machine. Claude key lives in the env, never echoed.
# ════════════════════════════════════════════════════════════════════

source ~/.cashbot/lib.sh 2>/dev/null || source "$(dirname "$0")/../lib.sh"
DIR=$(cb_app_dir terminal)

# --- INJECTED CODE (runnable) ---

# STEP 1: confirm Claude is there (real check, like phase apps verify a tool).
term_check() {
  if command -v claude >/dev/null 2>&1; then
    echo "claude present: $(claude --version 2>/dev/null || echo installed)"
  else
    echo "claude not found — installing CLI..."
    curl -fsSL https://claude.ai/install.sh | bash 2>/dev/null || \
      npm install -g @anthropic-ai/claude-code 2>/dev/null || \
      echo "install manually: npm i -g @anthropic-ai/claude-code"
  fi
}

# STEP 2: persist the key to the shell profile (shown once, never echoed back).
term_set_key() {  # usage: term_set_key sk-ant-...
  cb_save_secret ANTHROPIC_API_KEY "$1"
  grep -q 'cashbot/credentials.env' ~/.bashrc 2>/dev/null || \
    echo 'export ANTHROPIC_API_KEY=$(grep -m1 ^ANTHROPIC_API_KEY= ~/.cashbot/credentials.env|cut -d= -f2-)' >> ~/.bashrc
  echo "key saved to vault + wired into ~/.bashrc (loads every new shell)"
}

# STEP 3: first real command — prove the machine obeys plain words.
term_first_command() {
  mkdir -p ~/projects && printf '%s\n' "$(whoami)" > ~/projects/hello.txt
  cb_csv_init "$DIR/commands.log" "time,command,result"
  cb_csv_row  "$DIR/commands.log" "$(date +%H:%M:%S),make hello.txt,$(cat ~/projects/hello.txt)"
  echo "made ~/projects/hello.txt → $(cat ~/projects/hello.txt)"
  echo "you just told the machine what to do in plain words and it did it. that's the OS."
}

# --- END INJECTED CODE ---
# POINT FORWARD → FILES (08) to organize output, BROWSER (07) to research, VNC (10) to watch the screen.

case "$1" in
  check) term_check ;;
  key)   term_set_key "$2" ;;
  first) term_first_command ;;
  *) echo "usage: $0 {check|key <sk-ant-..>|first}" ;;
esac
