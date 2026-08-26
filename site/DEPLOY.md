# Lizard '13 website deployment

The website is intentionally static. No database or application server is required.

## Recommended layout

- `lizard13.com` — website
- `www.lizard13.com` — website alias
- `server.lizard13.com` — DNS-only record pointing at the FUT/game server public IP
- `discord.lizard13.com` — optional redirect to the Discord invite
- `status.lizard13.com` — reserved for a future player-facing status page

## Cloudflare Pages

Create a Pages project from the `Daye17A/lizard13` GitHub repository.

Use:

- Production branch: `main`
- Build command: leave empty / none
- Build output directory: `site`

Cloudflare Pages will serve `site/index.html` directly.

Before publishing publicly, replace both occurrences of:

`https://discord.gg/REPLACE_ME`

with the real permanent Discord invite.

## Custom domain

After the Pages deployment works on its generated `*.pages.dev` URL:

1. Open the Pages project in Cloudflare.
2. Go to **Custom domains**.
3. Add the apex domain, for example `lizard13.com`.
4. Add `www.lizard13.com` as an alias if desired.
5. Redirect `www` to the apex domain or vice versa so there is one canonical address.

## Game-server DNS

Create an A record:

- Type: `A`
- Name: `server`
- IPv4 address: the current public game-server address
- Proxy status: **DNS only**
- TTL: Auto

Do not expose the literal address in website source if it is not needed. The purpose of the hostname is to let the infrastructure address change later without shipping a new human-facing URL.

The launcher/server configuration can later move from a literal IP to `server.lizard13.com` after that change is tested separately.

## Discord subdomain

A friendly `discord.lizard13.com` URL can be implemented as a Cloudflare redirect rule pointing to the permanent Discord invite. This avoids baking the raw Discord invite into posters, videos and community posts.

## Downloads

For v1 the website links directly to:

`https://github.com/Daye17A/lizard13/releases/latest`

That keeps release distribution and update provenance in GitHub. A `download.lizard13.com` redirect can be added later without moving the actual binary hosting.

## Security notes

`site/_headers` applies basic browser hardening for the static website. Keep the website separate from the FUT service. Do not expose PostgreSQL, internal admin endpoints, server logs, credentials or internal monitoring through the public website.
