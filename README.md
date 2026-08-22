# Lizard '13

*FIFA 13 Ultimate Team — 2013, back online.*

This is the launcher for a **private, invite-only FIFA 13 Ultimate Team server**
run for a small group of friends. It is not affiliated with, endorsed by, or
connected to EA.

You need a legitimate installed copy of FIFA 13. This launcher ships no game
files — it only points your existing installation at a private server instead of
EA's, which was shut down years ago.

## How to play

1. Download **`Lizard13.exe`** from
   [the latest release](../../releases/latest).
2. Put it anywhere **except** your FIFA 13 folder — your Desktop is fine.
3. Run it, **sign in** with the player name and password you chose — or press
   **Create account** if this is your first time — and press **Play**.

There is nothing else to install. No Python, no .NET, no config files. The
server address is built in.

Your club lives on the server, not in the launcher, so you can sign in from
another PC and it will be exactly where you left it. This PC remembers you after
the first sign-in; the password is only asked for again on a machine that has
not seen you before.

**Keep your recovery code.** It is shown once when you create your account and
saved to a text file beside it. It is the way back in if you forget your
password.

## Two warnings, so you don't think it's a virus

**Windows SmartScreen will block it the first time.** The launcher is unsigned —
code-signing certificates cost a few hundred pounds a year, which is not worth it
for a private group. Click **More info**, then **Run anyway**.

**Your antivirus may object.** The launcher attaches a helper to the game while it
starts, which technically is process injection, and that is a behaviour antivirus
software is right to be suspicious of in general. It is how the launcher signs you
in without you having to edit game files by hand. If your antivirus quarantines
it, you will need to allow it explicitly.

If either of those is a dealbreaker for you, that is a completely reasonable
position — ask the host to walk you through it rather than clicking past warnings
you are not comfortable with.

## If it doesn't work

Send the host:

- what the launcher said, exactly
- whether the game reached the FUT screens or failed earlier
- which release you downloaded (the version tag on this page)

That last one matters more than it sounds. Most "it's broken" reports turn out to
be an old build, and the version tag is the fastest way to rule that out.

## Updating

The launcher checks for a newer release when it starts and offers to install it.
Updating keeps your sign-in, your settings and your recovery code — the account
is on the server, not in the file.

One exception: if you are still on a build from before this was named Lizard '13,
its updater is looking for a file that no longer exists and will quietly tell you
that you are up to date. Download `Lizard13.exe` from the latest release by hand
once, and it will keep itself current from then on.
