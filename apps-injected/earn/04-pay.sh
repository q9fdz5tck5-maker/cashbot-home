#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════
# APP 04 · PAY · EARN · P1
# ════════════════════════════════════════════════════════════════════
# PERSONA:
# You are CASH.BOT — PAY MODULE. Get them sending a clean, professional
# invoice and paid TODAY using simple external links only (PayPal.me +
# optional crypto address). NEVER build a card form, NEVER take card
# numbers, NEVER use payment API keys. Bill what was agreed — no hidden fees.
#
# THE ONE LAW: work isn't done until you're paid. The glass break is the
# first real invoice out + money back, clean and on the record.
# ════════════════════════════════════════════════════════════════════

source ~/.cashbot/lib.sh 2>/dev/null || source "$(dirname "$0")/../lib.sh"
DIR=$(cb_app_dir pay); mkdir -p "$DIR/invoices"

# --- INJECTED CODE (runnable) ---

# STEP 3: build a clean, mobile-friendly HTML invoice with external pay
# links only (paypal.me/handle/AMOUNT + optional crypto address).
pay_invoice() {  # usage: pay_invoice "Client" "Logo redesign" 250 myhandle [0xADDR]
  local client="$1" job="$2" amt="$3" handle="$4" crypto="$5"
  local f="$DIR/invoices/$(echo "$client" | tr ' ' '-')-$(cb_today).html"
  local crypto_html=""
  [ -n "$crypto" ] && crypto_html="<p>Or pay in crypto: <code>$crypto</code></p>"
  cat > "$f" <<HTML
<!doctype html><meta name=viewport content="width=device-width,initial-scale=1">
<body style="font-family:system-ui;max-width:600px;margin:40px auto;padding:0 16px">
<h2>Invoice</h2>
<p><b>To:</b> $client<br><b>For:</b> $job<br><b>Date:</b> $(cb_today)</p>
<table style="width:100%;border-collapse:collapse;margin:16px 0">
<tr style="border-bottom:1px solid #ccc"><td style="padding:8px">$job</td>
<td style="padding:8px;text-align:right"><b>\$$amt</b></td></tr></table>
<p><a href="https://paypal.me/$handle/$amt"
 style="background:#0070ba;color:#fff;padding:12px 20px;border-radius:6px;text-decoration:none">
 Pay \$$amt with PayPal</a></p>
$crypto_html
<p style="color:#666">Thanks! — tap to pay, takes a second.</p>
</body>
HTML
  # plain-text copy they can paste into a message
  printf 'Invoice for %s — %s: $%s\nPay: https://paypal.me/%s/%s\n' \
    "$client" "$job" "$amt" "$handle" "$amt" > "${f%.html}.txt"
  cb_csv_init "$DIR/ledger.csv" "date,client,job,amount,status"
  cb_csv_row  "$DIR/ledger.csv" "$(cb_today),$client,$job,$amt,SENT"
  echo "invoice → $f"
  echo "text copy → ${f%.html}.txt"
  echo "open it, review, send the client either the link or the text. That's a real business now."
}

# STEP 5: mark paid only when money actually lands (honest ledger).
pay_mark_paid() {  # usage: pay_mark_paid "Client"
  local tmp; tmp=$(mktemp)
  awk -F',' -v c="$1" 'BEGIN{OFS=","}{if($2==c&&$5=="SENT")$5="PAID";print}' "$DIR/ledger.csv" > "$tmp" && mv "$tmp" "$DIR/ledger.csv"
  echo "marked $1 PAID in ledger. clean, on-the-record. name the win."
}

# --- END INJECTED CODE ---
# POINT FORWARD → LEADS (20) to land more clients to bill, TRADE (02) to grow idle funds.

case "$1" in
  invoice)  shift; pay_invoice "$@" ;;
  paid)     pay_mark_paid "$2" ;;
  *) echo 'usage: '"$0"' {invoice "Client" "Job" AMT handle [0xADDR]|paid "Client"}' ;;
esac
