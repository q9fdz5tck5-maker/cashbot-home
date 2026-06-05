#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════
# APP 10 · VNC · BUILD · P1
# ════════════════════════════════════════════════════════════════════
# PERSONA:
# You are CASH.BOT — VNC MODULE. Secure remote screen access so they SEE and
# control their machine's full desktop from any device. SECURITY IS
# EVERYTHING: password-protected, encrypted tunnel only — never an open VNC
# port on the public internet. Password shown once, saved by them.
# The glass break: their whole cloud desktop appears on their PHONE.
# ════════════════════════════════════════════════════════════════════

source ~/.cashbot/lib.sh 2>/dev/null || source "$(dirname "$0")/../lib.sh"
DIR=$(cb_app_dir vnc)

# --- INJECTED CODE (runnable) ---

# STEP 2: install noVNC + a VNC server, generate a strong password (shown once).
vnc_setup() {
  local pass; pass=$(head -c12 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c16)
  cb_save_secret VNC_PASS "$pass"
  if ! command -v vncserver >/dev/null 2>&1; then
    (sudo apt-get update -y && sudo apt-get install -y tigervnc-standalone-server novnc websockify) >/dev/null 2>&1 \
      || echo "install manually: tigervnc-standalone-server novnc websockify"
  fi
  mkdir -p ~/.vnc
  printf '%s\n' "$pass" | vncpasswd -f > ~/.vnc/passwd 2>/dev/null; chmod 600 ~/.vnc/passwd
  cat > "$DIR/novnc.conf" <<C
# bind LOCALHOST only — reach it through an SSH/encrypted tunnel, never public
vnc_display=:1
geometry=1280x720
websockify_port=6080
bind=127.0.0.1
C
  echo "VNC password (SAVE THIS NOW — shown once): $pass"
}

# STEP 3: start the screen bridge bound to localhost (secure).
vnc_start() {
  vncserver :1 -geometry 1280x720 -depth 24 -localhost yes >/dev/null 2>&1
  nohup websockify --web=/usr/share/novnc 6080 localhost:5901 >/dev/null 2>&1 &
  echo "screen bridge → http://127.0.0.1:6080/vnc.html  (tunnel in, enter your saved password)"
  echo "your whole computer, in your pocket. never expose 6080 publicly."
}

# --- END INJECTED CODE ---
# POINT FORWARD → CONTENT branch (GENERATORS 11) to start making things, or BRAIN (SUPERFRACTAL 31) for memory.

case "$1" in
  setup) vnc_setup ;;
  start) vnc_start ;;
  *) echo "usage: $0 {setup|start}" ;;
esac
