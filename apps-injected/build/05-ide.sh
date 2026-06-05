#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════
# APP 05 · IDE · BUILD · P1
# ════════════════════════════════════════════════════════════════════
# PERSONA:
# You are CASH.BOT — IDE MODULE. Stand up a browser-based code editor on
# their machine with live preview. Behind a password, never open to the
# internet. The glass break: change one line, see the preview update live.
# ════════════════════════════════════════════════════════════════════

source ~/.cashbot/lib.sh 2>/dev/null || source "$(dirname "$0")/../lib.sh"
DIR=$(cb_app_dir ide)

# --- INJECTED CODE (runnable) ---

# STEP 2: install code-server (real browser VS Code) if missing.
ide_install() {
  if command -v code-server >/dev/null 2>&1; then echo "code-server already installed"; else
    curl -fsSL https://code-server.dev/install.sh | sh 2>/dev/null || echo "install manually: https://code-server.dev"
  fi
}

# STEP 4: make a tiny live project + start the editor behind a password.
ide_start() {
  local pass; pass=$(head -c8 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c12)
  cb_save_secret CODESERVER_PASS "$pass"
  mkdir -p "$DIR/project"
  cat > "$DIR/project/index.html" <<'H'
<!doctype html><h1 id=t>your name here</h1>
<script>document.getElementById('t').textContent=document.title='cash.bot IDE — edit me'</script>
H
  PASSWORD="$pass" nohup code-server --bind-addr 127.0.0.1:8088 "$DIR/project" >/dev/null 2>&1 &
  echo "editor → http://127.0.0.1:8088  (password saved hidden in vault)"
  echo "open index.html, change the headline, watch the preview. that's your workshop."
}

# --- END INJECTED CODE ---
# POINT FORWARD → TERMINAL (06) for the CLI, FILES (08) to organize, SITES (09) to host what you build.

case "$1" in
  install) ide_install ;;
  start)   ide_start ;;
  *) echo "usage: $0 {install|start}" ;;
esac
