# 🎰 CASH.BOT CROWNS — Quick Start Guide

## What is CROWNS?
**A system that automates your daily bonus claiming + builds an affiliate website + generates passive income from 20+ platforms.**

Spend 30 minutes daily. Earn $20-50/day in free bonuses + referral commissions.

---

## 📱 STEP 0: Download the Mobile App (Start Here!)

**File:** `cashbot-mobile-app.html`

1. Go to this repo
2. Download `cashbot-mobile-app.html` 
3. Save to phone (Chrome: ⋮ → Save Page)
4. Open in Safari/Chrome on phone
5. Add to home screen (Bookmark → Add to Home Screen)

**That's it.** You now have a pocket-sized interface with:
- Daily bonus checklist
- All affiliate links ready to tap
- Copy-paste prompts for Claude terminal
- Earnings tracker

---

## 🚀 STEP 1: Setup Phase (TODAY) — Takes 1-2 hours

### 1A: Sign up for services (all free, you get bonuses!)

| Platform | Affiliate Link | Purpose | Bonus |
|----------|---|---|---|
| **Vultr** (server) | https://www.vultr.com/?ref=9896825-9J | Always-on machine | $12 credit |
| **Google** (sheets) | https://sheets.google.com | Earnings tracking | Free |
| **GoHighLevel** (email) | https://www.self.inc/refer/I663N5ZO | Send broadcasts | Free tier |
| **SoFi** (banking) | https://www.sofi.com/invite/money | Stack bonuses | $425 total |
| **Honeygain** (passive) | https://join.honeygain.com/CENTRFAD3A | Background income | $3 instant |

### 1B: Deploy Server & Setup Access

**Prompt to run on Claude terminal:**

```
You are CASH.BOT — INFRASTRUCTURE BUILDER.

Step 1: On Vultr account, create Ubuntu 22.04 server (2GB RAM, $12/mo region closest to you).

Step 2: When ready, SSH to server (IP shown in Vultr console):
  ssh root@[IP]
  apt update && apt install -y tightvncserver xfce4 xfce4-goodies
  vncserver :1 -geometry 1280x720 -depth 24
  (Set password when prompted)

Step 3: Test RDP connection from phone:
  - Install Microsoft Remote Desktop (free app)
  - New connection → IP:5901 → login with your VNC password
  - You should see desktop

Step 4: Install Claude CLI on server:
  curl https://install.claude.sh | bash
  claude --version (should work)
  
Step 5: Give me the IP address + VNC password when everything works.
```

---

## 💰 STEP 2: Daily Money-Making Routine (5-30 min/day)

### Option A: Passive (5 minutes) — Just set & forget

1. **Install Honeygain daemon** (earns $3-15/mo in background)
   - https://join.honeygain.com/CENTRFAD3A
   - Install → Login → It runs 24/7

2. **Sign up SoFi** ($425 in bonuses)
   - Banking: https://www.sofi.com/invite/money (check + save + invest + crypto products)
   - Get: $25-$400 per product when you set up direct deposit

3. **Fetch app** (scan receipts, earn gift cards)
   - https://referral.fetch.com/vvv3/referralqr?code=3AX5JU
   - Every receipt = 5 points = toward gift cards

**Daily earnings: $10-20 from passive + Fetch**

### Option B: Active (30 minutes) — Claim casino bonuses daily

**Run this prompt on Claude terminal (on your phone's RDP connection to server):**

```
You are CASH.BOT — DAILY BONUS CLAIMER.

Right now it's [time]. Open these links in Chrome on my server and wait 3 seconds on each (ready to claim bonuses):

1. https://crowncoinscasino.com/?utm_campaign=8a0fea69-022f-479b-8b09-48e8460469a6&utm_source=friends → Click "Daily Bonus"
2. https://www.rolla.com/?raf=1177873 → Click "Spin Now"
3. https://realprize.com/refer/2018465 → Click "Claim Bonus"
4. https://www.spinblitz.com/lp/raf?r=0935b0ad%2F2735495799 → Click "Play Now"
5. https://www.mcluck.com/lp/raf?r=5ac6645c%2F2735506871 → Click "Claim Coins"
6. https://casino.click/?modal=iqs-sign-up&ReferenceCode=632453&AffiliatePlatformId=200 → Click "Bonus"
7. https://play.babacasino.com/#/?referral_id=071466df7d98f97fe7b1ed91bf8e2ff7&inv_referral=true&fb_source=invite → Click "Daily Spin"
8. https://www.ignitioncasino.eu/welcome/P63874DF/join → Click "Get Bonus"
9. https://www.wowvegas.com/?raf=12433217 → Click "Claim Bonus"

Log to Google Sheets: time + casino + bonus amount

Tell me when all are done + show total earned today.
```

**Daily earnings: $10-40 in casino bonuses**

---

## 🔨 STEP 3: Build Your Affiliate Website (Weekend)

### 3A: Run website builder prompt

```
You are CASH.BOT — WEBSITE BUILDER.

Create an HTML landing page with:
1. Header: "Earn Free Casino Bonuses + Passive Income"
2. Section 1 - Featured Casinos (cards for each, link to signup)
3. Section 2 - Daily Earnings Potential ($20-50 calculation)
4. Section 3 - How It Works (3 steps)
5. Section 4 - All affiliate links organized by category
6. Mobile responsive, dark theme, conversion-focused

Use these links:
- Casinos: [CrownCoins, Rolla, RealPrize, SpinBlitz, McLuck, Casino.click, BabaCasino, Ignition, WowVegas]
- Earning Apps: [Honeygain, Fetch, Mistplay, Opus.Pro, SoFi]

Output: HTML file I can upload to server.
```

### 3B: Deploy on Vultr server

```
You are CASH.BOT — WEB DEPLOYER.

SSH to my Vultr server [IP].

1. Install nginx: apt install -y nginx
2. Create: /var/www/mysite/index.html (paste the landing page HTML I gave you)
3. Start nginx: systemctl start nginx
4. Visit http://[IP] in browser → page should load

Then register domain:
  - Go to Namecheap (or GoDaddy)
  - Buy domain-name.com (~$3/yr) with referral code
  - Point nameservers to Vultr
  - Site now at domain-name.com

For SSL: apt install certbot && certbot certonly --nginx -d domain-name.com
```

---

## 📊 STEP 4: Start Earning from Your Website (Ongoing)

### Option 1: Organic Traffic (Free, slow)
- **SEO**: Write blog post "Best Free Casino Bonuses 2025" → ranks on Google
- **Social**: Post on TikTok/Instagram/Reddit daily → drive traffic
- **Content**: YouTube shorts showing bonuses → embed link

### Option 2: Paid Ads (Fast, costs $5-20/day)
```
You are CASH.BOT — AD BUYER.

Set up Google Ads for my landing page.

Budget: $5/day
Target keywords: "free casino bonus", "earn money online", "passive income"
Ad copy: "Earn $20-50 daily from free casino bonuses + passive income. Join now!"

Track: clicks + signups + earnings per click. If ROAS > 2x, scale to $20/day.
```

### Option 3: Email Marketing (Most profitable)
1. Setup GoHighLevel: https://www.self.inc/refer/I663N5ZO
2. Collect emails via lead magnet ("Free Guide: $500/month passive income")
3. Send weekly email: "Best bonus this week is [casino] → [link]"
4. Track open rates + clicks + conversions

---

## 💵 EARNINGS TARGETS

### Conservative (Passive only)
- Honeygain: $5-15/mo
- SoFi bonuses: $425 one-time
- Fetch: $20-50/mo
- **Monthly: $25-65**

### Moderate (Daily bonus claims)
- Casino bonuses: $300-600/mo
- Referral commissions: $200-500/mo
- Passive: $50/mo
- **Monthly: $550-1150**

### Aggressive (Website + Ads + Email)
- Casino bonuses: $300-600/mo
- Referral signups (10/mo × $50 commission): $500/mo
- Ads ROAS (2x return on $300 spend): $300/mo
- Passive: $50/mo
- **Monthly: $1150-1450**
- **Profit after costs** (server $12 + domain $1 + ads $300): **$837-1137/mo**

---

## 📋 ALL AFFILIATE LINKS (Copy/Paste into mobile app)

### Casinos
- https://crowncoinscasino.com/?utm_campaign=8a0fea69-022f-479b-8b09-48e8460469a6&utm_source=friends
- https://www.rolla.com/?raf=1177873
- https://realprize.com/refer/2018465
- https://www.spinblitz.com/lp/raf?r=0935b0ad%2F2735495799
- https://www.mcluck.com/lp/raf?r=5ac6645c%2F2735506871
- https://casino.click/?modal=iqs-sign-up&ReferenceCode=632453&AffiliatePlatformId=200
- https://play.babacasino.com/#/?referral_id=071466df7d98f97fe7b1ed91bf8e2ff7&inv_referral=true&fb_source=invite
- https://www.ignitioncasino.eu/welcome/P63874DF/join
- https://www.wowvegas.com/?raf=12433217

### Passive/Earning Apps
- https://join.honeygain.com/CENTRFAD3A (Honeygain)
- https://referral.fetch.com/vvv3/referralqr?code=3AX5JU (Fetch)
- https://mistplay.onelink.me/ZGRQ/yi5xdpjq (Mistplay)
- https://www.opus.pro/?via=790569 (Opus.Pro)

### Banking/Crypto
- https://www.sofi.com/invite/money?gcp=547822fd-2195-4f86-b2ba-b5f489050d21&isAliasGcp=false (SoFi - $425 bonuses)

### Infrastructure/Tools
- https://www.vultr.com/?ref=9896825-9J (Vultr - $12/mo server)
- https://www.self.inc/refer/I663N5ZO (GoHighLevel - email CRM)

---

## 🎯 YOUR STEP-BY-STEP ROADMAP

### Day 1
- [ ] Download mobile app to phone
- [ ] Sign up for Honeygain (passive income starts)
- [ ] Sign up for SoFi (claim $425 bonuses)
- [ ] Deploy Vultr server + test RDP from phone

### Day 2-3
- [ ] Install Claude on server
- [ ] Run daily bonus claimer prompt
- [ ] Start daily routine (30 min)
- [ ] Build landing page website

### Day 4-5
- [ ] Deploy site on Vultr domain
- [ ] Setup Google Sheets tracking
- [ ] Setup GoHighLevel email
- [ ] Make first social posts with link

### Week 2+
- [ ] Run ads if organic traffic slow
- [ ] Build email list
- [ ] Track earnings daily
- [ ] Optimize best-performing links
- [ ] Scale spending on winning channels

---

## 💬 PROMPTS TO COPY-PASTE

All prompts are in the mobile app. Just:
1. Open cashbot-mobile-app.html on phone
2. Tap the prompt you need
3. Click "Copy Prompt"
4. Open Claude Code terminal (or RDP terminal on server)
5. Paste + Enter

---

## 🏆 Success Metrics

**Track these:**
- Daily bonuses claimed (spreadsheet)
- Signups to your site (analytics)
- Email list size (CRM)
- Revenue per channel (attribution)
- Profit after costs (accounting)

**Goal: $1,000/mo by month 3**
- Month 1: $200-300 (setup + learning)
- Month 2: $400-600 (scaling + optimization)
- Month 3: $1,000+ (multiple channels working)

---

## ⚠️ IMPORTANT LEGAL NOTES

✅ **DO:**
- Disclose affiliate links ("these links may give me commission")
- Only promote legitimate casinos/apps (read reviews first)
- Pay taxes on earnings
- Respect terms of service (don't automate in ways they forbid)

❌ **DON'T:**
- Mislead people (no fake earnings claims)
- Use deceptive practices
- Violate casino/app ToS with aggressive automation
- Spam or harass people

**You're good if you: promote honestly, disclose links, follow rules, pay taxes.**

---

## 🚀 Let's Go!

1. **Download the mobile app** (above)
2. **Sign up for Vultr + Honeygain** (links above)
3. **Run Setup Prompt on server** (copy-paste from app)
4. **Start daily routine** (30 min/day)
5. **Build website** (weekend)
6. **Drive traffic** (social + ads)
7. **Watch money roll in** (daily earnings)

**Questions?** Re-read this guide or check the mobile app prompts.

**Your goal:** $1,000/month passive income by month 3. You got this. 🎯

---

**Last Updated:** June 5, 2026  
**Version:** CROWNS v1.0  
**Status:** Ready to Deploy
