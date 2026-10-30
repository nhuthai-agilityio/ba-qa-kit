---
name: release-note
description: Drafts the sprint release note email (Done, In-progress, Known issues, notes, next plan) from the sprint's GitLab tickets, for a person to review. Use when a sprint or release ends, or when asked for a release note.
---

# Release Note

Write the sprint release note email as a draft. A person reviews and sends it; never send it.

Read first, from this plugin's folder: `${CLAUDE_PLUGIN_ROOT}/references/project-profile.md` (the **Board**, **Sprints** and **Release note** lines, reading the board, a missing line) and `${CLAUDE_PLUGIN_ROOT}/references/ba-files.md` (files, Google Doc).

## Input and output

- **Needs** (from the user): confirm the products, sprints and release date; the sender name.
- **Reads**: the profile's Sprints and Release note lines, and the tickets of each product's sprint and next sprint.
- **Writes**: `ba-output/release-note-<YYYY-MM-DD>.md` (a draft, never sent); the profile's Release note line, after go, when the project or links were missing.
- **Next**: a person reviews and sends the email.

## Steps

1. **Get the release.** Propose the products from the profile's Sprints line with each one's current sprint (its newest open `<prefix> - SPR <n>` milestone, as in `/ba-qa-kit:track-status`), and ask the user to confirm them and give the release date. No prefixes? Ask: "Which products and sprints are released, and on what date?" Several products released the same day go into **one note** (see Rules). The project name and build links come from the profile's Release note line. Missing or `?:`? Ask for the project name and where the build links are (store links, version and build, Storybook, repository), and offer to save them in that line — no tokens, no personal data (not the sender name), and links are copied as text, never opened. Ask for the sender name on every run.
2. **Read each product's sprint tickets**: number, web link (`web_url`), title, status, labels, comments. If GitLab can't be read, ask the user to paste the ticket list.
3. **Sort by status:**
   - **DONE** — closed or in the Done list.
   - **IN-PROGRESS** — started, not Done.
   - **KNOWN ISSUE** — open bugs, tickets with the profile's known-issue label (default `Known issue`), and Done stories that still carry the open-questions label (default `pending-questions`) or a `Conflict –` line in their description (a team convention for open questions and conflicts); if tickets carry neither marker, only open bugs count.
4. **Write each line** as `[#<n>](<ticket link>) <short title>`, so the ticket number opens the ticket. The link is the ticket's `web_url`; for a pasted list, build it from the Board line as `https://<host>/<group>/<project>/-/issues/<n>`. No board link known? Write `#<n>` and add a `Check:` line. Make an unclear title clear in the reader's words; skip purely internal work unless the reader needs it.
5. **NEXT PLAN**: "Continue working on in-progress tasks", then the planned work per product from the next sprint's tickets, if any.
6. **Fill NOTES** from the links and versions the user gave; leave `link` where one is missing.
7. **Write the key highlights**: one line per product, from the Done tickets.
8. **Write the draft.** Read `assets/template.md` from this skill's folder first, then write with it. Dates use the long form `Month DDth, YYYY` with the right ending (1st, 2nd, 3rd, 4th…). Always show the draft in chat and save it to `ba-output/release-note-<YYYY-MM-DD>.md`. The team keeps release notes in a Google Doc: also give the text to paste (see `ba-files.md`), and tell the user to paste it with **Edit > Paste from Markdown** so the ticket links stay clickable. Then **stop and show the progress line**.

## Rules

- Every line comes from a ticket or from what the user gave. Never invent a feature, a version or a link; ticket links come only from the ticket or the Board line.
- Unclear ticket → add `Check: <what is unclear>` in chat for the reviewer; do not guess.
- Tickets not in the sprint are not included; list them in chat as "Not included" with the reason.
- **Same day, several products → one note.** One subject and intro naming all products, one key highlight per product, and each product as its own sub-heading in every section. Don't make separate notes unless the user asks.
- Draft only: never send or post it.
- Chat in the user's language; the release note in English.

## Progress

The progress line only suggests the next step. The user can run any skill at any time.

```
<sprint>   ✔ release-note
Next: <n> products, <n> done, <n> in-progress, <n> known issues, <n> links missing. Review the draft, then reply changes, or stop.
```

- **Change request** → update the draft, then show the progress line again.
- **stop** → end here.
