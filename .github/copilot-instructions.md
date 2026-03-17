# Copilot Repository Instructions

## Explore Mode Workflow

When working in an explore worktree or explore branch, keep a running exploration log in `ai/EXPLORE.md`.

Treat the session as "explore mode" when either is true:
- The current branch name starts with `explore-`.
- The repository path includes `/.explore-` (explore worktree directory).

In explore mode:
- For any non-trivial investigation or code change, append a short entry to `ai/EXPLORE.md`.
- Use reverse-chronological format (newest entries first).
- Record: brief description, files touched, key findings, and recommended follow-up.
- Keep entries concise and actionable.
- Never remove prior notes unless explicitly asked.

If `ai/EXPLORE.md` does not exist, create it.

### EXPLORE.md Format

Use this structure for each entry:

```markdown
## YYYY-MM-DD HH:MMZ - branch-name

Brief description of what you're investigating

**Files touched:** path/to/file1.js, path/to/file2.py

**Key findings:**
- Finding 1
- Finding 2
- Finding 3

**Follow-up:** Recommended next steps for main worktree
```

Example:
```markdown
## 2026-03-17 15:30Z - explore-main

Investigating authentication flow

**Files touched:** src/auth/index.js, tests/auth.test.js

**Key findings:**
- OAuth tokens expire after 1 hour
- No refresh token mechanism exists
- Token validation happens on every request

**Follow-up:** Add refresh token support in main worktree
```
