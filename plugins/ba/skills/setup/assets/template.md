# Setup Checklist Template

Used by `setup`. Replace this file to use a different checklist.

## Format

```markdown
Setup · <BA / QA / Both>

Connectors
- <✔ / ✖ / ○> GitLab: <Connected / Not connected: <how to connect> / Not checked>
- <✔ / ✖ / ○> Google Drive: <...>
- <✔ / ✖ / ○> Claude in Chrome: <...>

Tickets
- <✔ / ✖ / ○> GitLab project <group/project>: <readable / not readable / not checked>

Files
- <✔ / ✖> qa.config.json: <written / unchanged / missing: <fields>>
- <✔ / ✖> ba-output/track-ticket-status.json: <...>
- <✔ / ✖> ba-output/draft-release-note.json: <...>

Missing: <short list, or "nothing">
```

## Rules

- ✔ ready, ✖ missing, ○ not needed for this role or not checked.
- Show only the lines the role needs.
- Keep it under 20 lines. No secrets, no personal data, no production URLs.

## Example

```markdown
Setup · Both

Connectors
- ✔ GitLab: Connected
- ✖ Google Drive: Not connected: add it in Settings → Connectors, then restart
- ✔ Claude in Chrome: Connected

Tickets
- ✔ GitLab project hr/hr-app: readable

Files
- ✔ qa.config.json: written
- ✔ ba-output/track-ticket-status.json: unchanged
- ✖ ba-output/draft-release-note.json: missing: links

Missing: Google Drive connector, release note build links
```
