---
name: release-note
description: Drafts the sprint release note email (Done, In-progress, Known issues, notes, next plan) from the sprint's GitLab tickets, for a person to review. Use when a sprint or release ends, or when asked for a release note.
---

# Release Note

Write the sprint release note email as a draft. A person reviews and sends it; never send it.

## Config and files

- **Config**: read the `ba` section of `qa.config.json` in the current folder. A field missing there? Read it from `ba-output/track-status.json` or `ba-output/release-note.json` (older setups: `track-ticket-status.json`, `draft-release-note.json`). Still missing? Ask for it and suggest `/ba:setup`.
- **Output**: every file goes to `ba-output/` in the current folder (create it if missing). Ask before saving anywhere else. A Google Doc is written only when the user gives its link.

## Steps

1. **Get the release.** Propose the products from `ba.sprintPrefixes` with each one's current sprint, and ask the user to confirm them and give the release date. No prefixes? Ask: "Which products and sprints are released, and on what date?" Several products released the same day go into **one note** (see Rules). The project name and build links come from `ba.releaseNote` (see Config). Missing? Ask for the project name and where the build links are (store links, version and build, Storybook, repository), then save only `project` and `links` (each link as a name and its location) to `ba-output/release-note.json` — no tokens, no personal data (not the sender name), and links are copied as text, never opened. Ask for the sender name on every run.
2. **Read each product's sprint tickets**: number, title, status, labels, comments. If GitLab can't be read, ask the user to paste the ticket list.
3. **Sort by status:**
   - **DONE** — closed or in the Done list.
   - **IN-PROGRESS** — started, not Done.
   - **KNOWN ISSUE** — open bugs, and Done stories that still carry the label `pending-questions` or a `Conflict –` line in their description (a team convention for open questions and conflicts); if tickets carry neither marker, only open bugs count.
4. **Write each line** as `<ticket #> <short title>`. Make an unclear title clear in the reader's words; skip purely internal work unless the reader needs it.
5. **NEXT PLAN**: "Continue working on in-progress tasks", then the planned work per product from the next sprint's tickets, if any.
6. **Fill NOTES** from the links and versions the user gave; leave `link` where one is missing.
7. **Write the key highlights**: one line per product, from the Done tickets.
8. **Write the draft.** Read `assets/template.md` from this skill's folder first, then write with it. Dates use the long form `Month DDth, YYYY` with the right ending (1st, 2nd, 3rd, 4th…). Always show the draft in chat and save it to `ba-output/release-note-<YYYY-MM-DD>.md`. If the user gave a Google Doc, also write it there (see Rules). Then **stop and show the progress line**.

## Rules

- Every line comes from a ticket or from what the user gave. Never invent a feature, a version or a link.
- Unclear ticket → add `Check: <what is unclear>` in chat for the reviewer; do not guess.
- Tickets not in the sprint are not included; list them in chat as "Not included" with the reason.
- **Same day, several products → one note.** One subject and intro naming all products, one key highlight per product, and each product as its own sub-heading in every section. Don't make separate notes unless the user asks.
- Draft only: never send or post it.
- **Google Doc**: if the user gives a Google Doc link, write directly into that doc with the Google Drive connector — keep its existing content and styles, add only the new content. Confirm the doc link before writing. If the doc can't be edited or the Google Drive connector is not installed, say so and give the text to paste.
- Chat in the user's language; the release note in English.

## Progress

The progress line only suggests the next step. The user can run any skill at any time.

```
<sprint>   ✔ release-note
Next: <n> products, <n> done, <n> in-progress, <n> known issues, <n> links missing. Review the draft, then reply changes, or stop.
```

- **Change request** → update the draft, then show the progress line again.
- **stop** → end here.
