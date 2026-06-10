# CASH.BOT — CODE INJECTION LIBRARY

Reusable, **real runnable code patterns** extracted from the actual cash.bot apps
(`cashbot-starter.zip` → `vultr-proxy.js`, `tier-1/phase*-setup.html`, `os.html`).

Every one of the 122 app prompts gets wrapped around one or more of these blocks so the
prompt **executes real code** instead of just describing a task.

> Rule of injection: the persona/prompt stays on top (the "who you are + one step at a
> time" voice). Below it, an `INJECTED CODE` block holds the literal commands the agent
> runs. Same shape as the real `buildDeployPrompt()` pattern.

---

## PATTERN 0 — Secrets vault (every app that touches a key)

Source: `vultr-proxy.js` (`KEY_FILE = ~/.cashbot/...`), `phase2-setup.html` (`saveApiKeyExplicit`).

```bash
# Save a secret — never echoed back, chmod 600, lives only on the machine
cb_save_secret() {  # usage: cb_save_secret NAME VALUE
  mkdir -p ~/.cashbot
  printf '%s=%s\n' "$1" "$2" >> ~/.cashbot/credentials.env
  chmod 600 ~/.cashbot/credentials.env
  echo "saved $1 (hidden)"
}
# Read a secret into a shell var without printing it
cb_get_secret() { grep -m1 "^$1=" ~/.cashbot/credentials.env | cut -d'=' -f2-; }
```

## PATTERN 1 — App output folder + CSV writer (every CONTENT/REACH app)

Source: real apps sync to `~/cashbot-files/Apps/<app>/` (FILES module).

```bash
cb_app_dir() { d=~/cashbot-files/Apps/"$1"; mkdir -p "$d"; echo "$d"; }
cb_csv_init() { [ -f "$1" ] || printf '%s\n' "$2" > "$1"; }   # file, header
cb_csv_row()  { printf '%s\n' "$2" >> "$1"; }                  # file, row
```

## PATTERN 2 — Local API proxy (any app calling a 3rd-party API from the browser)

Source: `vultr-proxy.js` — Node HTTP server on `:8765`, CORS, reads key from vault, proxies.

```javascript
// ~/.cashbot/proxy.js  — generic: node proxy.js <UPSTREAM_HOST> <KEY_NAME>
const http=require('http'),https=require('https'),fs=require('fs');
const [HOST,KEYNAME]=process.argv.slice(2);
const key=(fs.readFileSync(process.env.HOME+'/.cashbot/credentials.env','utf8')
  .match(new RegExp('^'+KEYNAME+'=(.+)','m'))||[])[1];
http.createServer((req,res)=>{
  res.setHeader('Access-Control-Allow-Origin','*');
  const up=https.request({hostname:HOST,path:req.url,method:req.method,
    headers:{Authorization:'Bearer '+key,'Content-Type':'application/json'}},
    u=>{res.writeHead(u.statusCode);u.pipe(res);});
  req.pipe(up);
}).listen(8765,()=>console.log('proxy → '+HOST+' on :8765'));
```

## PATTERN 3 — Claude batch worker (every CONTENT generator: 11 apps)

The factory pattern: list in → CSV out, one Claude call per line.

```bash
# cb_batch INPUT_LIST OUTPUT_CSV "SYSTEM PROMPT"  — needs ANTHROPIC_API_KEY in vault
cb_batch() {
  KEY=$(cb_get_secret ANTHROPIC_API_KEY)
  : > "$2"; echo "input,output" > "$2"
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    out=$(curl -s https://api.anthropic.com/v1/messages \
      -H "x-api-key: $KEY" -H "anthropic-version: 2023-06-01" \
      -H "content-type: application/json" \
      -d "$(jq -n --arg s "$3" --arg u "$line" '{model:"claude-opus-4-8",max_tokens:1024,system:$s,messages:[{role:"user",content:$u}]}')" \
      | jq -r '.content[0].text' | tr '\n' ' ')
    printf '%s,"%s"\n' "$line" "${out//\"/\"\"}" >> "$2"
  done < "$1"
  echo "wrote $(($(wc -l < "$2")-1)) rows → $2"
}
```

## PATTERN 4 — Polite public fetch / scrape (BROWSER, SCRAPER, RESEARCH, LEADS)

Source: os.html BROWSER module rules (public only, rate-limited).

```bash
cb_fetch() {  # url, outfile — 1 req, UA set, 2s courtesy delay
  curl -s -A "cashbot/1.0 (+respectful)" --max-time 20 "$1" -o "$2"
  sleep 2; echo "fetched $1 → $2"
}
cb_extract_emails() { grep -oiE '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}' "$1" | sort -u; }
```

## PATTERN 5 — Static deploy + serve (SITES, ANALYTICS, COMMUNITY, OS SHELL)

```bash
cb_serve() { d="$1"; p="${2:-8080}"; cd "$d" && nohup python3 -m http.server "$p" >/dev/null 2>&1 & echo "serving $d → http://localhost:$p"; }
```

## PATTERN 6 — Local RAG brain (SUPERFRACTAL + BRAIN apps)

Source: os-brain.txt SUPERFRACTAL module (Ollama, 100% local).

```bash
cb_brain_index() {  # indexes ~/cashbot-files into a local vector store via Ollama
  command -v ollama >/dev/null || curl -fsSL https://ollama.ai/install.sh | sh
  ollama pull nomic-embed-text 2>/dev/null; ollama pull llama3.2 2>/dev/null
  python3 ~/.cashbot/brain.py index ~/cashbot-files
}
cb_brain_ask() { python3 ~/.cashbot/brain.py ask "$1"; }
```

---

## INJECTION TEMPLATE (applied to all 122)

```
<PERSONA PROMPT — unchanged voice: one law, one step, name the win>

--- INJECTED CODE (runnable) ---
# load the shared library
source ~/.cashbot/lib.sh

<APP-SPECIFIC REAL CODE built from the patterns above>

--- END INJECTED CODE ---

<POINT-FORWARD line — names the next app>
```

Each app file in `apps-injected/<branch>/<app>.sh` is **directly runnable** and also
copy-pasteable into a Claude terminal as a prompt-with-code.
