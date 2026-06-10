#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════
# APP 03 · FAUCETHUB · EARN · P2
# ════════════════════════════════════════════════════════════════════
# PERSONA:
# You are CASH.BOT — FAUCETHUB MODULE. Get the person free TESTNET crypto
# so they practice with ZERO risk. HONEST: testnet tokens are worthless by
# design — for practice, not income. They ONLY ever paste their PUBLIC
# address into a faucet, never the secret backup words.
#
# THE ONE LAW: you can't learn money by reading about it. The glass break
# is the first free practice crypto landing + seeing a real on-chain tx.
# ════════════════════════════════════════════════════════════════════

source ~/.cashbot/lib.sh 2>/dev/null || source "$(dirname "$0")/../lib.sh"
DIR=$(cb_app_dir faucethub)

# --- INJECTED CODE (runnable) ---

# STEP 5: build the local list of working faucets, by chain, with date
# (mirrors real Faucet Hub syncing results to Files).
faucet_add() {  # usage: faucet_add sepolia https://faucet... working
  cb_csv_init "$DIR/faucets.csv" "chain,url,status,checked"
  cb_csv_row  "$DIR/faucets.csv" "$1,$2,${3:-untested},$(cb_today)"
  echo "saved faucet → $DIR/faucets.csv"
}

# Seed the directory with known public testnet faucets (30+ chains in the real app).
faucet_seed() {
  cb_csv_init "$DIR/faucets.csv" "chain,url,status,checked"
  while IFS= read -r row; do cb_csv_row "$DIR/faucets.csv" "$row,seeded,$(cb_today)"; done <<'ROWS'
sepolia,https://sepoliafaucet.com
sepolia,https://www.alchemy.com/faucets/ethereum-sepolia
holesky,https://holesky-faucet.pk910.de
base-sepolia,https://www.alchemy.com/faucets/base-sepolia
arbitrum-sepolia,https://www.alchemy.com/faucets/arbitrum-sepolia
polygon-amoy,https://faucet.polygon.technology
ROWS
  echo "seeded $(($(wc -l < "$DIR/faucets.csv")-1)) faucets → $DIR/faucets.csv"
}

# STEP 4: confirm the practice tokens arrived on a testnet (read-only).
faucet_check() {  # usage: faucet_check 0xADDR   (Sepolia)
  local wei; wei=$(curl -s https://rpc.sepolia.org \
    -H 'content-type: application/json' \
    -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"eth_getBalance\",\"params\":[\"$1\",\"latest\"]}" \
    | jq -r '.result')
  python3 -c "print('Sepolia practice balance:', int('${wei:-0x0}',16)/1e18,'ETH (test, no real value)')"
  echo "↑ a real blockchain tx, for free. That's the muscle before real funds."
}

# --- END INJECTED CODE ---
# POINT FORWARD → TRADE (02) to practice the bot with this, or PAY (04) to get paid for real.

case "$1" in
  seed)  faucet_seed ;;
  add)   faucet_add "$2" "$3" "$4" ;;
  check) faucet_check "$2" ;;
  *) echo "usage: $0 {seed|add <chain> <url> [status]|check <0xADDR>}" ;;
esac
