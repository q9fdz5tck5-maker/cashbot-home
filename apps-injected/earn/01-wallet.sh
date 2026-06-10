#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════
# APP 01 · WALLET · EARN · P0
# Paste into a Claude terminal as a prompt-with-code, OR run directly.
# ════════════════════════════════════════════════════════════════════
#
# PERSONA (unchanged voice):
# You are CASH.BOT — WALLET MODULE. Stand up a simple, safe self-custody
# crypto wallet so money has one clean place to land — keys in their hands.
# ONE step per message, then stop. Secrets are sacred: the recovery phrase
# is the money — it goes on PAPER, offline, never pasted to anyone.
#
# THE ONE LAW: a person who can't receive money can't grow it. The glass
# break is the first $1 of crypto landing in a wallet that is theirs alone.
# ════════════════════════════════════════════════════════════════════

source ~/.cashbot/lib.sh 2>/dev/null || source "$(dirname "$0")/../lib.sh"
DIR=$(cb_app_dir wallet)

# --- INJECTED CODE (runnable) ---

# STEP 3 real code: store the PUBLIC receive address (safe to share).
# The secret phrase is NEVER handled here — only the public address.
wallet_set_address() {  # usage: wallet_set_address 0xABC... [chain]
  local addr="$1" chain="${2:-evm}"
  case "$addr" in
    0x*) [ ${#addr} -eq 42 ] || { echo "⚠ not a valid EVM address"; return 1; } ;;
    *)   [ ${#addr} -ge 26 ] || { echo "⚠ address looks too short"; return 1; } ;;
  esac
  cb_csv_init "$DIR/address.csv" "chain,address,added"
  cb_csv_row  "$DIR/address.csv" "$chain,$addr,$(cb_today)"
  echo "money-drop saved → $DIR/address.csv  (public address, safe to share)"
}

# STEP 4 real code: confirm crypto actually LANDED (read-only public RPC,
# no key needed). Mirrors os.html "never claim a transfer before it shows".
wallet_check_balance() {  # usage: wallet_check_balance 0xADDR
  local addr="$1"
  local wei; wei=$(curl -s https://eth.llamarpc.com \
    -H 'content-type: application/json' \
    -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"eth_getBalance\",\"params\":[\"$addr\",\"latest\"]}" \
    | jq -r '.result')
  [ "$wei" = "null" ] || [ -z "$wei" ] && { echo "couldn't read chain — try again in a minute"; return 1; }
  python3 - "$wei" <<'PY'
import sys; wei=int(sys.argv[1],16); print(f"balance: {wei/1e18:.6f} ETH")
PY
  echo "↑ if that number went up, real money landed in a wallet only you control. That's the glass break."
}

# --- END INJECTED CODE ---

# POINT FORWARD → TRADE (02) puts idle crypto to work, FAUCETHUB (03) gives
# free practice crypto. Each names the next.

# CLI: ./01-wallet.sh address 0x... | ./01-wallet.sh balance 0x...
case "$1" in
  address) wallet_set_address "$2" "$3" ;;
  balance) wallet_check_balance "$2" ;;
  *) echo "usage: $0 {address <0x..>|balance <0x..>}" ;;
esac
