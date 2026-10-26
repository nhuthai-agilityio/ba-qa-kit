---
name: draft-release-note
description: Drafts the sprint release note email from the GitLab tickets of a sprint — Done, In-progress and Known issues — plus build and link notes and the next plan, in the team template. Draft only, for a person to review before sending. Use when a sprint or release ends, or when asked for a release note.
---

# Draft Release Note

Write the sprint release note email as a draft. A person reviews and sends it; never send it.

## Steps

1. **Get the release.** If not given, ask: "Which products and sprints are released, and on what date?" Several products released the same day go into **one note** (see Rules). First run only, also ask the project name for the subject, the sender name, and where the build links are (store links, version and build, Storybook, repository). Save the answers to `ba-output/draft-release-note.json` (no tokens or personal data); later runs read that file instead of asking.
2. **Read each product's sprint tickets**: number, title, status, labels, comments. If GitLab can't be read, ask the user to paste the ticket list.
3. **Sort by status:**
   - **DONE** — closed or in the Done list.
   - **IN-PROGRESS** — started, not Done.
   - **KNOWN ISSUE** — open bugs, and Done stories that still carry the label `pending-questions` or a `Conflict –` line in their description (both are added by `write-stories-to-board`).
4. **Write each line** as `<ticket #> <short title>`. Make an unclear title clear in the reader's words; skip purely internal work unless the reader needs it.
5. **NEXT PLAN**: "Continue working on in-progress tasks", then the planned work per product from the next sprint's tickets, if any.
6. **Fill NOTES** from the links and versions the user gave; leave `link` where one is missing.
7. **Write the key highlights**: one line per product, from the Done tickets.
8. **Write the draft** with `assets/template.md` — into the user's Google Doc if one is given, otherwise in chat and saved to `ba-output/release-note-<YYYY-MM-DD>.md` (ask before saving anywhere else). Dates use the long form `Month DDth, YYYY` with the right ending (1st, 2nd, 3rd, 4th…). Read `assets/template.md` from this skill's folder. Show it, then **stop and show the progress line**.

## Rules

- Every line comes from a ticket or from what the user gave. Never invent a feature, a version or a link.
- Unclear ticket → add `Check: <what is unclear>` in chat for the reviewer; do not guess.
- Tickets not in the sprint are not included; list them in chat as "Not included" with the reason.
- **Same day, several products → one note.** One subject and intro naming all products, one key highlight per product, and each product as its own sub-heading in every section. Don't make separate notes unless the user asks.
- Draft only: never send or post it.
- **Google Doc**: if the user gives a Google Doc link, write directly into that doc with the Google Drive connector — keep its existing content and styles, add only the new content. Confirm the doc link before writing. If the doc can't be edited, give the text to paste.
- Chat in the user's language; the release note in English.

## Progress

```
<sprint>   ✔ draft-release-note
Next: <n> products, <n> done, <n> in-progress, <n> known issues, <n> links missing. Review the draft, then reply changes, or stop.
```

- **Change request** → update the draft, then show the progress line again.
- **stop** → end here.
