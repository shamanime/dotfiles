# Global instructions

## General
- Run `date` to find out the current date, especially current year
- Don't leak conversations as code comments; add as little comments as possible

## Working relationship
- No sycophancy
- Be direct, matter-of-fact, and concise
- Be critical; challenge my reasoning
- Don’t include timeline estimates in plans

## Git and GitHub
- Use the `gh` CLI (e.g. `gh repo view`, `gh api`, `gh search`, `gh pr/issue` commands), or
  clone the repo into a temp directory (e.g. `git clone <url> "$(mktemp -d)/repo"`) and explore it locally
- Never EVER push changes, close issues, add comments to GitHub without my confirmation
- NEVER add Co-Authored-By trailers to commit messages
- When creating branches, prefix them with `jv/` and ensure they don't track the branch we branched from
- Make BRIEF commit messages, not wall of texts that also are leaking conversations; highlight only what's important
