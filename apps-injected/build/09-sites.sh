#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════
# APP 09 · SITES · BUILD · P1
# ════════════════════════════════════════════════════════════════════
# PERSONA:
# You are CASH.BOT — SITES MODULE. Host the websites they build — theirs
# and clients' — and put one live today. Be honest about cost (static can
# be free; a domain is a few $/yr). Never promise traffic. Do the deploy.
# The glass break: their site loads on the real internet at a real address.
# ════════════════════════════════════════════════════════════════════

source ~/.cashbot/lib.sh 2>/dev/null || source "$(dirname "$0")/../lib.sh"
DIR=$(cb_app_dir sites)

# --- INJECTED CODE (runnable) ---

# STEP 1+3: scaffold a clean one-pager and serve it live from the machine.
sites_new() {  # usage: sites_new mysite "My Headline"
  local name="$1" head="${2:-Live from my own machine}"
  local d="$DIR/$name"; mkdir -p "$d"
  cat > "$d/index.html" <<HTML
<!doctype html><meta name=viewport content="width=device-width,initial-scale=1">
<title>$name</title>
<body style="font-family:system-ui;display:grid;place-items:center;height:90vh;margin:0">
<div style="text-align:center"><h1>$head</h1>
<p style="color:#666">Built &amp; shipped from my own machine · $(cb_today)</p></div>
</body>
HTML
  cb_csv_init "$DIR/deployments.csv" "site,path,deployed,url"
  cb_csv_row  "$DIR/deployments.csv" "$name,$d,$(cb_today),http://localhost:8080"
  echo "site scaffolded → $d/index.html"
}

sites_deploy() {  # usage: sites_deploy mysite [port]
  cb_serve "$DIR/$1" "${2:-8080}"
  echo "live from your machine. for a public URL, push this folder to a free static host or point a domain at it."
}

# --- END INJECTED CODE ---
# POINT FORWARD → PAY (04) to bill the client, ANALYTICS (28) to measure visitors, MARKETINGCOPY (14) for sharper copy.

case "$1" in
  new)    sites_new "$2" "$3" ;;
  deploy) sites_deploy "$2" "$3" ;;
  *) echo 'usage: '"$0"' {new <name> "Headline"|deploy <name> [port]}' ;;
esac
