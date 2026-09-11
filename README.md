# Lizard '13

> **FIFA 13 Ultimate Team — 2013, back online.**

Lizard '13 is a **FIFA 13 Ultimate Team revival** with a Windows launcher, shared community server and MyFUT web panel. It is currently in **BETA with invite-only access during testing**.

It exists so players can use a legitimate PC copy of FIFA 13 against a community-run replacement service after the original EA FUT infrastructure was retired.

Lizard '13 does **not** include FIFA 13, game executables, or EA-owned game files. It is not affiliated with, endorsed by, or connected to Electronic Arts.

[Website](https://lizard13.com) · [MyFUT](https://myfut.lizard13.com) · [Discord](https://lizard13.com/discord) · [Download the launcher](../../releases/latest)

## Latest major update — 10–11 September 2026

- **Live hybrid transfer market:** human auctions alongside recognisable **LIZARD FC AI** listings, funded AI buyers, real card resales and more consumable stock.
- **Funded bids:** coins are reserved when you bid, released when you are outbid and used to settle the auction if you win.
- **Broader player pricing:** 84 explicit desirable/meta/historical player anchors, position-aware fallback prices and bounded automatic learning from qualifying human trades.
- **MyFUT trading tools for staff:** real player names, Human/AI auction filters, a separate Sales section, card histories, treasury reporting and CSV export.
- **Discord linking:** connect your account through launcher Settings or MyFUT, with Beta Tester role assignment after linking and membership requirements.
- **Promo round administration:** staff can configure and schedule stock-limited pack rounds without restarting the server for each event. Final FIFA client presentation checks remain.

The [combined Discord changelog](https://discord.com/channels/1547283448597585932/1547290504121552990/1547757325937283169) separates major features from fixes and records the remaining rollout checks.

---

## What you get

The revival is built around the original FIFA 13 client, so the game still provides the menus, cards, squads, Store presentation and gameplay you remember.

The community server currently supports the core shared FUT experience, including:

- account creation and sign-in;
- persistent clubs, coins and inventories;
- FUT hub and Store;
- Bronze, Silver and Gold packs;
- FIFA 13 special cards;
- squad building and chemistry;
- transfer market buying, selling, bidding and offers;
- watch list and unassigned items;
- leaderboards and tournaments;
- matchmaking and relayed online matches.

The launcher also supports friendship requests by Lizard username. MyFUT brings
club and leaderboard information to your browser using the same Lizard account.

The project is currently in **BETA**. Access is invite-only during this testing phase while stability, capacity and remaining client flows are improved.

---

## How to play

1. Download **`Lizard13.exe`** from [the latest release](../../releases/latest).
2. Put it somewhere convenient, such as your Desktop. Do **not** place it inside the FIFA 13 game folder.
3. Run Lizard '13.
4. If this is your first time, choose **Create account**. Otherwise sign in.
5. Press **Play** and let the launcher prepare FIFA 13 for the community server.
6. Enter Ultimate Team normally from FIFA 13.

You need a legitimate installed PC copy of FIFA 13.

New registration requires a beta invite. Joining Discord alone does not grant
game access. You can link Discord from launcher Settings or the MyFUT Discord
account page. Mandatory linking before FUT entry is not enabled in the current rollout.

For normal players there is no Python setup, source checkout, server configuration or manual hosts-file editing required.

---

## Your club is server-side

Your FUT club does not live inside `Lizard13.exe`.

Your account, club, coins, squad, items and market state live on the community server. That means you can sign in from another supported PC and continue with the same club.

**Beta accounts, clubs, items and progress will not transfer when Lizard '13 goes
live.** Normal launcher updates during beta do not reset your club.

The launcher can remember an authorised PC after sign-in so you do not have to type your password every time.

### Keep your recovery code

When an account is created, a recovery code is provided for account recovery.

**Keep it somewhere safe.** Do not post it in Discord, screenshots, support logs, or public issue reports.

---

## What Lizard '13 actually does

Lizard '13 is more than a shortcut, but it is intentionally player-facing rather than a development toolkit.

It handles the work required to point the retail FIFA 13 client at the revival service, including things such as:

- account sign-in;
- server bootstrap;
- FIFA/runtime checks;
- compatibility preparation;
- updates;
- launching/attaching the helper components required by the old client.

The server then handles the FUT account, club, economy, market and matchmaking state.

Gameplay itself still runs in FIFA 13.

---

## Online matches

Matchmaking is supported on the community server.

The current production gameplay transport uses a **relay** so matches can work even when home routers/NAT make direct peer-to-peer connectivity unreliable.

Direct P2P is being researched as a future optimisation, with relay intended to remain the safe fallback. Players do not need to configure this manually.

### Launcher friends

Search by Lizard registration username, send or accept requests, and manage
friendships in the launcher. The native FIFA friend-list and Play a Friend Online
invitation journey remain a separate client-validation task. Launcher friendship
management does not yet establish that every native invitation flow works.

---

## The hybrid transfer market

Human and AI listings share the market. **LIZARD FC AI** identifies the AI seller;
human listings are prioritised in discovery. AI buyers spend from a finite,
shared treasury, buy only eligible listings within their limits, and can resell
the same physical card. They will not buy every auction you list.

- **Bids reserve coins immediately.** Raising your own bid reserves only the
  difference. Being outbid releases the hold; a winning auction settles from the
  coins already held.
- **AI sales refill the treasury.** Their full proceeds return without seller
  tax. The **5% seller tax on human sales** also funds the treasury.
- **Stock and prices are controlled.** Consumables can have multiple copies
  available. Player price anchors and position-aware fallback values are beta
  economy settings, not recovered historical EA sale prices.
- **Automatic learning needs genuine activity.** Only qualifying human cash
  trades inform it, with minimum evidence and limited movement per rolling day.
  AI transactions do not drive the estimator. Staff can tune or pause automation.

New auctions and bids follow FIFA's native coin increment ladder. Existing
auctions keep their terms; changing an anchor is not a reason to rewrite a bid
that someone has already funded.

---

## MyFUT and Discord

[MyFUT](https://myfut.lizard13.com) is the browser panel for Lizard players. Sign in
with your launcher account to view your club and leaderboards or link Discord.

**Staff tools are separate from the player view.** Authorised staff use MFA to
manage invites and players, inspect named Human/AI auctions and completed sales,
follow a card through purchases and resales, export reports, and manage market
prices, stock, budgets and Promo pack rounds.

Discord linking is **one Lizard account to one Discord account**. It persists
across launcher updates, new devices and club resets. The approval flow runs in
your browser and can join the community with your consent; Lizard does not ask
for your Discord password. Complete any community membership screening so the
Beta Tester role can be assigned.

The [community Discord](https://lizard13.com/discord) has #help-desk and
#bug-reports. #changelog covers **Server, MyFUT, Launcher and Website** updates.
Opt into **Release Updates** for notifications; **Lizard TOTW** notifications
follow the separate hourly rotation feed.

---

## Packs and special cards

The revival uses FIFA 13 card data rather than inventing modern replacement cards.

Historical base cards, transfer versions and special cards are being reconstructed so individual FUT cards retain the club they actually represented at the time.

Lizard TOTW rotates a 23-card team every hour from historical IF/TOTW, TOTS, MOTM and other special cards, controlling which active specials can be newly packed.

Because the economy is shared, pack supply and special-card availability are treated carefully. Changes are tested before being enabled on the live server.

Staff can create reusable Promo pack templates with composition, prices,
start/end times, stock and per-account limits. Saving a template does not open a
sale. Scheduled rounds appear only when published and active. The custom Promo
artwork/name-delivery update is deployed; final in-game appearance and refresh
still require verification. No specific pack event or price is promised by this README.

---

## Updating

Lizard '13 checks for newer launcher releases and can update itself.

At the **11 September 2026** documentation update, the public launcher release is
**[v2026.09.10.1](../../releases/tag/v2026.09.10.1)**. The
[latest release page](../../releases/latest) remains the current download source.

If an update is offered, install it before reporting a problem. Old launcher builds are one of the easiest ways to end up testing behaviour that has already been fixed.

Your club is server-side, so replacing or updating the launcher does not reset your FUT progress.

---

## Windows SmartScreen / antivirus warnings

Lizard '13 is a small community project and may not have the reputation/signing history Windows expects from commercial software.

### SmartScreen

Windows may show a SmartScreen warning for an unsigned or low-reputation build.

If you trust the release source, choose **More info** and then **Run anyway**.

### Antivirus

The launcher performs compatibility/attachment work around the FIFA 13 process. Security software can reasonably consider that behaviour suspicious in general and may quarantine the launcher or helper.

If that happens, verify that you downloaded the executable from this repository's release page before allowing it.

If you are uncomfortable bypassing a security warning, do not do it blindly. Ask the server host for help.

---

## If something goes wrong

When reporting a problem, send the host:

- your Lizard '13 version;
- exactly what the launcher displayed;
- whether FIFA itself started;
- whether you reached the FUT hub;
- what you were doing immediately before the failure;
- any support/trace bundle the launcher asks you to provide.

Do **not** send:

- your password;
- recovery code;
- device/auth secrets;
- screenshots containing those values.

### Useful distinction

If FIFA never launches, the problem is probably in launcher/bootstrap/compatibility setup.

If FIFA launches but FUT fails, the trace from that attempt is usually much more useful than reinstalling or randomly changing files.

---

## Current project stage

Lizard '13 is not being presented as a finished public replacement for EA FUT.

The server is being rolled out gradually while the project proves:

- reliability under concurrent players;
- matchmaking and relay capacity;
- database backup/recovery;
- monitoring and crash recovery;
- account/session hardening;
- pack economy and special-card rotation;
- remaining authentic FIFA 13 client flows.

The goal is a stable shared FIFA 13 FUT community, not a temporary offline demo.

---

## For developers / researchers

This repository is intentionally the lightweight **player-facing launcher repository**.

The main FIFA 13 revival/server repository contains the protocol research, server code, reverse-engineering notes, catalogue tooling, tests and operations documentation.

If you are contributing to the server itself, use that repository rather than treating this launcher README as the technical source of truth.

---

## Legal

Lizard '13 is an independent preservation/revival project and is **not affiliated with or endorsed by Electronic Arts**.

FIFA, FIFA 13 and Ultimate Team are trademarks/properties of their respective owners.

This launcher does not provide the FIFA 13 game. Players are expected to use a legitimately obtained installation.
