# Release Note Template

Used by `draft-release-note`. Replace this file to use a different template.

## Format

```
Subject: [<project>] <Product> Sprint <n> Release - <Month DDth, YYYY>
(several products the same day: [<project>] <Product A> & <Product B> Release - <Month DDth, YYYY>)

Hi all,

We hope you are doing well!

During this sprint, our team focused on delivering the planned features for <Product> Sprint <n>.
(several products: "...for <Product A> Sprint <n> and <Product B> Sprint <n>.")

Key highlights:
- <Product>: <one-line summary of what changed for users>.

Please find the detailed report below.

I. NOTES

<Product>
- Android
  - Download the app in the Play Store via the link
  - Version: <x.y> (build <n>)
- iOS
  - Please check your email inbox and install the app via TestFlight
  - Version: <x.y> (build <n>)
- <Other link>: link
- Source code
  - Repository: link
  - Tag: link

II. DONE
(one product: list directly. Several products: one sub-heading per product, as in NOTES.)
- <ticket #> <title>

III. IN-PROGRESS
- <ticket #> <title>

IV. KNOWN ISSUE
- <ticket #> <title> - <what goes wrong>

V. NEXT PLAN
- Continue working on in-progress tasks

<Product>
- <planned work for next sprint>

Thanks & Regards,
<Sender name>
```

## Rules

- **Several products released the same day** go into ONE note: list every product in the subject and the intro, one key highlight line per product, and one sub-heading per product in NOTES, DONE, IN-PROGRESS, KNOWN ISSUE and NEXT PLAN. A product with nothing in a section is left out of that section.
- **Subject**: `[<project>] <Product> Sprint <n> Release - <Month DDth, YYYY>`.
- **Key highlights**: one line per product, in the reader's words.
- **NOTES**: one block per product; build versions, store links and source code. Links the user doesn't give stay as `link` for the reviewer.
- **DONE / IN-PROGRESS / KNOWN ISSUE**: one line per ticket: `<ticket #> <title>`. Keep ticket titles short and clear.
- **NEXT PLAN**: first line "Continue working on in-progress tasks", then planned work per product.
- Drop a block that has nothing to say, but keep KNOWN ISSUE with "None" when there are none.

## Example

```
Subject: [ABC Project] Flash Mobile Sprint 16 Release - June 11th, 2026

Hi all,

We hope you are doing well!

During this sprint, our team focused on delivering the planned features for Flash Mobile Sprint 16.

Key highlights:
- Flash Mobile: Enhanced the experience with redesigned request flows, performance optimizations, bug fixes, and applied Evalite testing.

Please find the detailed report below.

I. NOTES

Flash Mobile
- Android
  - Download the app in the Play Store via the link
  - Version: 1.0 (build 82)
- iOS
  - Please check your email inbox and install the app via TestFlight
  - Version: 1.0 (build 212)
- Storybook: link
- Source code
  - Repository: link
  - Tag: link

II. DONE
- 4196 Fixed known issues from Sprint 15

III. IN-PROGRESS
- 4265 Exploring and applying AI tools to speed up the development process

IV. KNOWN ISSUE
- 4015 Chatbot - responded incorrectly when requesting statistics with multiple subjects

V. NEXT PLAN
- Continue working on in-progress tasks

Flash Mobile
- Update E2E test coverage for Time-off, Room Booking, and Reallocation requests

Thanks & Regards,
<Sender name>
```

## Example — two products, same day

```
Subject: [ABC Project] Flash Mobile & Kitchen Dashboard Release - June 11th, 2026

Hi all,

We hope you are doing well!

During this sprint, our team focused on delivering the planned features for Flash Mobile Sprint 16 and Kitchen Dashboard Sprint 8.

Key highlights:
- Flash Mobile: Redesigned request flows, performance optimizations, and bug fixes.
- Kitchen Dashboard: Improved answers for statistics questions.

Please find the detailed report below.

I. NOTES

Flash Mobile
- Android
  - Version: 1.0 (build 82)
- iOS
  - Version: 1.0 (build 212)

Kitchen Dashboard
- Repository: link
- New deployment address: link

II. DONE

Flash Mobile
- 4196 Fixed known issues from Sprint 15

Kitchen Dashboard
- 4310 Answers now cover statistics with one subject

III. IN-PROGRESS

Flash Mobile
- 4265 Exploring and applying AI tools to speed up the development process

IV. KNOWN ISSUE

Kitchen Dashboard
- 4015 Chatbot - responded incorrectly when requesting statistics with multiple subjects

V. NEXT PLAN
- Continue working on in-progress tasks

Flash Mobile
- Update E2E test coverage for Time-off, Room Booking, and Reallocation requests

Thanks & Regards,
<Sender name>
```
