---
name: docs-gardening
description: "Turn a docs folder into evergreen documentation: classify, route the work log out, rename, relink."
disable-model-invocation: true
metadata:
  credits:
    - idea: doc-gardening agent
      source: "https://openai.com/index/harness-engineering/"
    - idea: classify, split, place, cross-link, deliver an organization map
      source: "https://skills.lc/ModernNomad-98/Project-Aegis/modernnomad-98-project-aegis-claude-skills-diataxis-doc-organizer-skill-md"
    - idea: edit docs only, after approval
      source: "https://github.com/P-manBrown/tascon-backend/pull/640"
---

# Docs gardening

Leave the target as **evergreen** documentation: every line describes the system as it is now, in the present tense, in a file a reader can find by its name. The **work log** (how the team got here) leaves the repo for the place that already records it.

Target: the paths in the arguments; with none, `docs/`. Edit documentation and the references that point at it (links, comments, paths in messages). Code behaviour stays as it is.

## Steps

### 1. Inventory

List every file in the target and every reference to it from anywhere in the repo (`git grep` on each file name and path). Done when each file has its list of incoming references, empty or not.

### 2. Classify

Read every section and give it exactly one label:

| Label                                            | Content                                                                                                                           |
| ------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- |
| `tutorial`, `how-to`, `reference`, `explanation` | Diátaxis modes, as defined in [`technical-writing`](../technical-writing/SKILL.md)                                                |
| `decision`                                       | A choice with context, alternatives considered, consequences                                                                      |
| `limitation`                                     | A lasting constraint or known risk of the system as built                                                                         |
| `work log`                                       | Status tables, dated test evidence, "corrections from the original plan", session narrative, pending items, who-did-what          |
| `cache`                                          | A copy of data that has a source of truth in the repo (a spec, config, generated file); keep it only when the lookup is expensive |

While reading, check each factual claim against the code and flag the ones the code no longer supports as **stale**. Stale is a flag on a claim, not a label: a stale claim keeps its section's label.

Done when no section is unlabelled, no section carries two labels (a section serving two modes is split first), and every stale claim is flagged.

### 3. Map

Build one table: section, label, destination, target file name. Destinations:

- Diátaxis modes: one file per mode and topic. The folder's `README.md` opens with one paragraph on the topic and indexes the other files.
- `decision`: one ADR per decision (Status, Date, Context, Decision, Alternatives, Consequences). When the repo already has ADRs, follow their folder, numbering, and template; otherwise use `<target>/adr/NNNN-<title>.md`. The date is the decision's, found in `git log`.
- `limitation`: a "Known limitations" section in the topic's `explanation` file.
- `work log`: evidence to the PR description (the current branch's open PR, or a draft for the next one); open pending items to tickets; history to git, which already has it. Pending items that describe a lasting limitation become `limitation`.
- `cache`: a link to the source of truth.
- Stale claims: rewrite from the code, or list as a code question when the code looks wrong.

File names: English, lowercase kebab-case (`login-observability.md`), whatever language the content is in. Files that platforms recognize by name keep their conventional case: `README.md`, `CHANGELOG.md`, `CONTRIBUTING.md`, `SECURITY.md`, `LICENSE`.

Show the table and wait. Done when the user approves it; apply their corrections to the table before step 4.

### 4. Execute

- Move and rename with `git mv`. A rename that changes only letter case goes through a temporary name (`a.md` → `a.tmp.md` → `A.md`), so case-insensitive file systems record it.
- Write each file in its mode, applying [`technical-writing`](../technical-writing/SKILL.md). Present tense; dates appear only in ADR metadata.
- Delete the old files once their content has a destination. Work-log content leaves the repo only through the step 6 drafts, so keep it in those drafts before deleting.
- Update every reference from step 1.

Done when `git grep` finds no old file name or path, and every relative link in the target resolves to an existing file.

### 5. Verify

Run the repo's own checks that touch docs (formatter, linter, link checker; find them in the package manifest, Makefile, or CI config). Done when they pass or each failure is shown to predate the change.

### 6. Report

- The target tree.
- ADRs created.
- Work log routed: what goes to the PR description (draft the text), and the pending items as ticket-ready entries: title, context, steps, acceptance criterion. Create the tickets only when the user asks and names the project, issue type, and parent.
- Stale claims left as code questions.
- Files outside the target that reference it and that you changed.
- Old path → new path for every moved file, so the user can fix links from outside the repo (wikis, tickets, bookmarks).
