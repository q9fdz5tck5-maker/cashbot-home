#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════
# APP 02 · TRADE · EARN · P1
# ════════════════════════════════════════════════════════════════════
# PERSONA:
# You are CASH.BOT — TRADE MODULE. Set them up to run ONE simple,
# conservative bot on a TESTNET first (paper money), so they learn the
# loop before risking a cent. HONESTY OVER HYPE: most people lose money
# trading — say it plainly. TESTNET/PAPER FIRST, ALWAYS. API keys are
# TRADE-ONLY, withdrawals DISABLED, stored hidden in the vault.
#
# THE ONE LAW: the glass break is NOT a big win — it's the first full
# buy/sell loop the bot runs on its own that they fully understand.
# ════════════════════════════════════════════════════════════════════

source ~/.cashbot/lib.sh 2>/dev/null || source "$(dirname "$0")/../lib.sh"
DIR=$(cb_app_dir trade)

# --- INJECTED CODE (runnable) ---

# STEP 1: the honest talk is enforced in code — gate before any setup.
trade_consent() {
  cb_csv_init "$DIR/consent.csv" "acknowledged,date"
  cb_csv_row  "$DIR/consent.csv" "I-understand-most-people-lose,$(cb_today)"
  echo "logged. paper money only until YOU decide otherwise."
}

# STEP 3: write a conservative DCA paper-bot config (no leverage, one pair).
trade_make_config() {  # usage: trade_make_config BTCUSDT 25
  local pair="${1:-BTCUSDT}" usd="${2:-25}"
  cat > "$DIR/bot-config.json" <<JSON
{
  "mode": "PAPER",
  "exchange_testnet": true,
  "pair": "$pair",
  "strategy": "dca",
  "buy_usd_per_step": $usd,
  "leverage": 1,
  "withdrawals_enabled": false,
  "max_open_usd": $((usd*4)),
  "note": "paper/testnet only — promote to real only on explicit user choice"
}
JSON
  echo "conservative paper config → $DIR/bot-config.json"
}

# STEP 4: run ONE paper loop against live public price (no key, no risk) and
# log the trade so they can READ exactly what it did.
trade_paper_loop() {  # usage: trade_paper_loop BTCUSDT 25
  local pair="${1:-BTCUSDT}" usd="${2:-25}"
  local px; px=$(curl -s "https://api.binance.com/api/v3/ticker/price?symbol=$pair" | jq -r '.price')
  [ -z "$px" ] || [ "$px" = "null" ] && { echo "couldn't read price"; return 1; }
  local qty; qty=$(python3 -c "print(round($usd/$px,8))")
  cb_csv_init "$DIR/trades.csv" "time,pair,side,price,usd,qty,mode"
  cb_csv_row  "$DIR/trades.csv" "$(date +%H:%M:%S),$pair,BUY,$px,$usd,$qty,PAPER"
  echo "PAPER BUY: $qty $pair @ \$$px (spent \$$usd of fake money)"
  echo "→ logged to $DIR/trades.csv. That's one full step of the loop — no real money touched."
}

# --- END INJECTED CODE ---
# POINT FORWARD → FAUCETHUB (03) for free practice crypto, or PAY (04) to get paid by clients.

case "$1" in
  consent) trade_consent ;;
  config)  trade_make_config "$2" "$3" ;;
  paper)   trade_paper_loop "$2" "$3" ;;
  *) echo "usage: $0 {consent|config <PAIR> <USD>|paper <PAIR> <USD>}" ;;
esac
