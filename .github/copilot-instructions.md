# Copilot Repository Instructions

## Explore Mode Workflow

When working in an explore worktree or explore branch, keep a running exploration log in `ai/EXPLORE.md`.

Treat the session as "explore mode" when either is true:
- The current branch name starts with `explore-`.
- The repository path includes `/.explore-` (explore worktree directory).

In explore mode:
- For any non-trivial investigation or code change, append a short entry to `ai/EXPLORE.md`.
- Use reverse-chronological headings with timestamp and branch name.
- Record: intent, files touched, key findings, and recommended follow-up for the main worktree.
- Keep entries concise and actionable.
- Never remove prior notes unless explicitly asked.

If `ai/EXPLORE.md` does not exist, create it.
