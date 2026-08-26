# Lizard '13

> **FIFA 13 Ultimate Team — 2013, back online.**

Lizard '13 is the Windows launcher for a **private, invite-only FIFA 13 Ultimate Team revival server**.

It exists so players can use a legitimate PC copy of FIFA 13 against a community-run replacement service after the original EA FUT infrastructure was retired.

Lizard '13 does **not** include FIFA 13, game executables, or EA-owned game files. It is not affiliated with, endorsed by, or connected to Electronic Arts.

---

## What you get

The revival is built around the original FIFA 13 client, so the game still provides the menus, cards, squads, Store presentation and gameplay you remember.

The private server currently supports the core shared FUT experience, including:

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

The project is still in **closed beta / pre-beta hardening**, so some original FUT surfaces are still being reconstructed and some newer systems are deliberately being tested before they are enabled for everyone.

---

## How to play

1. Download **`Lizard13.exe`** from [the latest release](../../releases/latest).
2. Put it somewhere convenient, such as your Desktop. Do **not** place it inside the FIFA 13 game folder.
3. Run Lizard '13.
4. If this is your first time, choose **Create account**. Otherwise sign in.
5. Press **Play** and let the launcher prepare FIFA 13 for the private server.
6. Enter Ultimate Team normally from FIFA 13.

You need a legitimate installed PC copy of FIFA 13.

For normal players there is no Python setup, source checkout, server configuration or manual hosts-file editing required.

---

## Your club is server-side

Your FUT club does not live inside `Lizard13.exe`.

Your account, club, coins, squad, items and market state live on the community server. That means you can sign in from another supported PC and continue with the same club.

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

Matchmaking is supported on the private server.

The current production gameplay transport uses a **relay** so matches can work even when home routers/NAT make direct peer-to-peer connectivity unreliable.

Direct P2P is being researched as a future optimisation, with relay intended to remain the safe fallback. Players do not need to configure this manually.

---

## Packs and special cards

The revival uses FIFA 13 card data rather than inventing modern replacement cards.

Historical base cards, transfer versions and special cards are being reconstructed so individual FUT cards retain the club they actually represented at the time.

The project is also developing a rotating live-special system so historical IF/TOTW, TOTS, MOTM and other cards are not all permanently available at once.

Because the economy is shared, pack supply and special-card availability are treated carefully. Changes are tested before being enabled on the live server.

---

## Updating

Lizard '13 checks for newer launcher releases and can update itself.

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
