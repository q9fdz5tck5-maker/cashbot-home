#!/usr/bin/env bash
# CASH.BOT shared injection library — source this at the top of every app.
# Extracted from real app patterns (vultr-proxy.js, phase*-setup.html, os.html).
# Install: cp apps-injected/lib.sh ~/.cashbot/lib.sh ; then `source ~/.cashbot/lib.sh`

# --- PATTERN 0: secrets vault (never echoed, chmod 600) ---
cb_save_secret() { mkdir -p ~/.cashbot; printf '%s=%s\n' "$1" "$2" >> ~/.cashbot/credentials.env; chmod 600 ~/.cashbot/credentials.env; echo "saved $1 (hidden)"; }
cb_get_secret()  { grep -m1 "^$1=" ~/.cashbot/credentials.env 2>/dev/null | cut -d'=' -f2-; }

# --- PATTERN 1: app output dir + CSV ---
cb_app_dir() { d="$HOME/cashbot-files/Apps/$1"; mkdir -p "$d"; echo "$d"; }
cb_csv_init() { [ -f "$1" ] || printf '%s\n' "$2" > "$1"; }
cb_csv_row()  { printf '%s\n' "$2" >> "$1"; }
cb_today()    { date +%Y-%m-%d; }

# --- PATTERN 3: Claude batch worker (list in → CSV out) ---
cb_batch() { # INPUT_LIST OUTPUT_CSV "SYSTEM"
  local KEY; KEY=$(cb_get_secret ANTHROPIC_API_KEY)
  [ -z "$KEY" ] && { echo "no ANTHROPIC_API_KEY in vault — run: cb_save_secret ANTHROPIC_API_KEY sk-..."; return 1; }
  echo "input,output" > "$2"
  while IFS= read -r line; do [ -z "$line" ] && continue
    local out; out=$(curl -s https://api.anthropic.com/v1/messages \
      -H "x-api-key: $KEY" -H "anthropic-version: 2023-06-01" -H "content-type: application/json" \
      -d "$(jq -n --arg s "$3" --arg u "$line" '{model:"claude-opus-4-8",max_tokens:1024,system:$s,messages:[{role:"user",content:$u}]}')" \
      | jq -r '.content[0].text' | tr '\n' ' ')
    printf '%s,"%s"\n' "$line" "${out//\"/\"\"}" >> "$2"
  done < "$1"
  echo "wrote $(($(wc -l < "$2")-1)) rows → $2"
}

# --- PATTERN 4: polite public fetch ---
cb_fetch() { curl -s -A "cashbot/1.0 (+respectful)" --max-time 20 "$1" -o "$2"; sleep 2; echo "fetched $1 → $2"; }
cb_extract_emails() { grep -oiE '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}' "$1" | sort -u; }

# --- PATTERN 5: static serve ---
cb_serve() { local d="$1" p="${2:-8080}"; (cd "$d" && nohup python3 -m http.server "$p" >/dev/null 2>&1 &); echo "serving $d → http://localhost:$p"; }

# --- PATTERN 6: local brain ---
cb_brain_ask() { python3 ~/.cashbot/brain.py ask "$1" 2>/dev/null || echo "run SUPERFRACTAL app first to build the brain"; }

echo "cash.bot lib loaded — cb_* helpers ready"
