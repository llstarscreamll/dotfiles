# Global agent instructions

- Replies: answer first, telegraphic fragments, no preamble/postamble/filler; default ≤5 lines; stop once delivered.
- Fixing a bug: lead with the smallest diff that removes the root cause; offer every extra (telemetry, refactor, neighbouring cases) as a separate ticket.
- Applying a code review: fix only its blockers, each with the smallest change; turn notes into tickets.
- Git Commits: NEVER commit automatically unless explicitly requested. NEVER include co-authorship, assistance tags, or AI watermarks.
- Documentation files (README, docs/, AGENTS.md…): do NOT omit important details. Present them comprehensively but clearly, structurally (using lists/tables), and concisely (no fluff). Applies only to written files, not chat replies.
