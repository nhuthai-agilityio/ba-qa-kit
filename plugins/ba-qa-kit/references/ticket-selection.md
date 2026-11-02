# Picking tickets

Shared by `write-test-cases` and `verify`. Each skill adds its own options and checks on top of this.

## Input
The tickets, in one of these ways:
- `--tickets 12,15`, or just `12`: these tickets.
- `--label "ready to test","bug fix"`: tickets with at least one of these labels.
- `--milestone "Sprint 1","Sprint 2"`: tickets in one of these milestones (Jira: sprint or fix version).
- `--label … --milestone …`: tickets that match both.

Names with spaces go in quotes. Tickets given together with a label or milestone? Ask which to use. Nothing given? Ask which tickets.

## Find the tickets
Read the board the profile's way. For labels, search each label and merge the results without duplicates. Only parent tickets (not bugs, not `QA test cases` sub-issues). A label or milestone not found? List the names that exist, and stop.

## Latest `QA test cases` sub-issue
The child item of the ticket with the test-cases label (the profile's Labels line) or a title that starts with `QA test cases – #<n>`, with the highest version (the number after `– v`; no suffix = v1). Two with the same version, or a version that cannot be read? Ask which one to use.

## Confirm
More than one ticket, or a label or milestone was used? Show the skill's table and wait. One ticket by number: skip the table.
