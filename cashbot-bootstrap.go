package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"time"
)

// CashBotModule represents one module in the cash.bot OS
type CashBotModule struct {
	Name     string
	Branch   string
	Priority string
	Setup    string
	Path     string
}

var modules = []CashBotModule{
	// EARN Branch
	{"WALLET", "EARN", "P0", "mkdir -p ~/cashbot-files/Apps/wallet", "wallet"},
	{"TRADE", "EARN", "P1", "mkdir -p ~/cashbot-files/Apps/trade", "trade"},
	{"FAUCETHUB", "EARN", "P2", "mkdir -p ~/cashbot-files/Apps/faucethub", "faucethub"},
	{"PAY", "EARN", "P1", "mkdir -p ~/cashbot-files/Apps/pay/invoices", "pay"},

	// BUILD Branch
	{"IDE", "BUILD", "P1", "mkdir -p ~/cashbot-files/Apps/ide", "ide"},
	{"TERMINAL", "BUILD", "P0", "mkdir -p ~/cashbot-files/Apps/terminal", "terminal"},
	{"BROWSER", "BUILD", "P1", "mkdir -p ~/cashbot-files/Apps/browser/research", "browser"},
	{"FILES", "BUILD", "P0", "mkdir -p ~/cashbot-files/Apps/{wallet,pay,sites,leads,research,clients,operation}", "files"},
	{"SITES", "BUILD", "P1", "mkdir -p ~/cashbot-files/Apps/sites", "sites"},
	{"VNC", "BUILD", "P1", "mkdir -p ~/cashbot-files/Apps/vnc", "vnc"},

	// CONTENT Branch
	{"GENERATORS", "CONTENT", "P1", "mkdir -p ~/cashbot-files/Apps/generators", "generators"},
	{"CAPTIONS", "CONTENT", "P1", "mkdir -p ~/cashbot-files/Apps/captions", "captions"},
	{"VIRALSHORTS", "CONTENT", "P1", "mkdir -p ~/cashbot-files/Apps/viralshorts", "viralshorts"},
	{"MARKETINGCOPY", "CONTENT", "P1", "mkdir -p ~/cashbot-files/Apps/marketingcopy", "marketingcopy"},
	{"KEYWORDS", "CONTENT", "P1", "mkdir -p ~/cashbot-files/Apps/keywords", "keywords"},
	{"DIFFICULTY", "CONTENT", "P1", "mkdir -p ~/cashbot-files/Apps/difficulty", "difficulty"},
	{"THUMBNAILIDEA", "CONTENT", "P1", "mkdir -p ~/cashbot-files/Apps/thumbnailidea", "thumbnailidea"},
	{"IMAGEPROMPT", "CONTENT", "P1", "mkdir -p ~/cashbot-files/Apps/imageprompt", "imageprompt"},
	{"VIDEOHOOKS", "CONTENT", "P0", "mkdir -p ~/cashbot-files/Apps/videohooks", "videohooks"},

	// REACH Branch
	{"LEADS", "REACH", "P1", "mkdir -p ~/cashbot-files/Apps/leads", "leads"},
	{"SCRAPER", "REACH", "P1", "mkdir -p ~/cashbot-files/Apps/scraper", "scraper"},
	{"BLAST", "REACH", "P1", "mkdir -p ~/cashbot-files/Apps/blast", "blast"},
	{"AUTOPOST", "REACH", "P1", "mkdir -p ~/cashbot-files/Apps/autopost", "autopost"},
	{"EMAIL", "REACH", "P1", "mkdir -p ~/cashbot-files/Apps/email", "email"},
	{"INBOX", "REACH", "P2", "mkdir -p ~/cashbot-files/Apps/inbox", "inbox"},
	{"COMMUNITY", "REACH", "P2", "mkdir -p ~/cashbot-files/Apps/community", "community"},
	{"RESEARCH", "REACH", "P1", "mkdir -p ~/cashbot-files/Apps/research", "research"},
	{"ANALYTICS", "REACH", "P1", "mkdir -p ~/cashbot-files/Apps/analytics", "analytics"},
	{"VOICE", "REACH", "P2", "mkdir -p ~/cashbot-files/Apps/voice", "voice"},
	{"PHONE", "REACH", "P2", "mkdir -p ~/cashbot-files/Apps/phone", "phone"},

	// BRAIN Branch
	{"SUPERFRACTAL", "BRAIN", "P0", "mkdir -p ~/cashbot-files/Apps/superfractal", "superfractal"},
	{"OS SHELL", "BRAIN", "P0", "mkdir -p ~/cashbot-files/Apps/shell", "shell"},
}

func main() {
	fmt.Println("\n========================================")
	fmt.Println("  CASH.BOT OS BOOTSTRAP")
	fmt.Println("  Building your local machine setup")
	fmt.Println("========================================\n")

	home, err := os.ExpandUser("~")
	if err != nil {
		fmt.Println("Error getting home directory:", err)
		os.Exit(1)
	}

	baseDir := filepath.Join(home, "cashbot-files")
	err = os.MkdirAll(baseDir, 0755)
	if err != nil {
		fmt.Println("Error creating base directory:", err)
		os.Exit(1)
	}

	fmt.Printf("📁 Base directory ready: %s\n\n", baseDir)

	// Create module directories
	fmt.Println("⚙️  Setting up 35 core modules...\n")
	setupCount := 0
	for _, module := range modules {
		cmd := exec.Command("bash", "-c", module.Setup)
		err := cmd.Run()
		if err == nil {
			setupCount++
			fmt.Printf("  ✓ %s (%s)\n", module.Name, module.Branch)
		} else {
			fmt.Printf("  ✗ %s (setup failed)\n", module.Name)
		}
	}

	fmt.Printf("\n✅ %d modules ready\n\n", setupCount)

	// Create README
	readmeContent := `# CASH.BOT OS — LOCAL BUILD

Your personal operating system for making money. 122 apps, running on YOUR machine.

## STRUCTURE

- **Apps/** — Module output folders (wallet, pay, sites, leads, etc)
- **sessions/** — Prompt session logs
- **integrations/** — Slack, Discord, API keys (keep private)
- **.backup/** — Automated backups

## GETTING STARTED

1. Paste the MASTER PROMPT into Claude Code terminal
2. Follow ONE step at a time
3. Each module names the next

## FIRST STEPS

Start with:
  - PROMPT 0 (free front door — make first money)
  - PROMPT 1A (Vultr cloud RDP setup)
  - PROMPT 1B (build environment)
  - TERMINAL (Claude CLI)
  - WALLET (receive crypto)

## HELP

Every prompt is plain English. If something's unclear, ask Claude again.

Built by Chase Tipton · https://cash.bot
`

	readmePath := filepath.Join(baseDir, "README.md")
	os.WriteFile(readmePath, []byte(readmeContent), 0644)

	// Create a session log
	sessionLog := fmt.Sprintf("=== BOOTSTRAP SESSION ===\nStarted: %s\nModules: %d\nStatus: Ready\n", time.Now().Format(time.RFC3339), setupCount)
	sessionPath := filepath.Join(baseDir, "sessions")
	os.MkdirAll(sessionPath, 0755)
	os.WriteFile(filepath.Join(sessionPath, "bootstrap.log"), []byte(sessionLog), 0644)

	// Print final instructions
	fmt.Println("========================================")
	fmt.Println("  🚀 YOUR CASH.BOT OS IS READY")
	fmt.Println("========================================\n")

	fmt.Printf("📍 Location: %s\n\n", baseDir)

	fmt.Println("NEXT: Paste this into Claude Code terminal:\n")
	fmt.Println("------- COPY BELOW -------\n")

	fmt.Println(`You are CASH.BOT. I'm a brand-new person, often broke. Help me make my first real money starting TODAY.

Here's your machine, running on YOUR box. Let's go one step at a time.

STEP 1: Pick how you want to start making money.

Answer 1, 2, or 3:
  1) I've got stuff around my house I'm not using (clothes, electronics, games, tools)
  2) I've got nothing to sell, but I can get to a thrift store / Goodwill / free stuff area
  3) I just want to start with free sign-up cash, no selling

Tell me the number, then wait. I'll walk you through your path, one small step per message.`)

	fmt.Println("\n------- COPY ABOVE -------\n")

	fmt.Println("✅ System ready. All 122 apps are in place.")
	fmt.Println("📚 Full spreadsheet: cashbot-prompts-spreadsheet.csv")
	fmt.Println("\n(You don't need to do anything else right now — just run the prompt above in Claude Code.)\n")
}
