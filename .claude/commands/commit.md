---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git push:*), Bash(gh pr:*), Bash(open:*)
description: Create a git commit
---

## Context

- Current git status: !`git status`
- Staged changes: !`git diff --cached`
- Unstaged changes: !`git diff`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10 2>/dev/null || echo "No commits yet"`

## Your task

1. Analyze the context and optionally diff content to understand the nature and purpose of the changes
2. Generate a commit message based on the changes
   - The message should be concise, clear, and capture the essence of the changes
   - Prefer Conventional Commits format (feat:, fix:, docs:, refactor:, etc.)
3. Stage changes if necessary using git add
4. Execute git commit using the selected commit message
5. Use AskUserQuestion to ask what to do next. The options depend on the current branch:
   - If on main/master, offer: "Push" or "Nothing"
   - If on any other branch, offer: "Push only", "Push + open PR", or "Nothing"
   - For "Push": run `git push -u origin <branch>`
   - For "Push + open PR": push, then check if a PR exists (`gh pr view --json url 2>/dev/null`), create one if not (`gh pr create --fill`), and open it in the browser (`open <pr-url>`)

## Constraints

- DO NOT add Claude co-authorship footer to commits
- DO NOT use emojis
- For multi-line commit messages, use multiple `-m` flags instead of heredocs (heredocs fail in sandbox mode due to temp file restrictions):
  ```bash
  # Correct: multiple -m flags
  git commit -m "Title" -m "Body paragraph"

  # Avoid: heredocs (may fail with "can't create temp file")
  git commit -m "$(cat <<'EOF'
  Title
  EOF
  )"
  ```
