# Global preferences

## Tool versions (asdf)

- Always manage tool versions with asdf, not nvm, pyenv, brew-pinned versions or similar.
- Every project gets a `.tool-versions` file pinning its tools (e.g. `nodejs`, `pnpm`, `python`), using versions already installed (`asdf list <tool>`) where possible.
- If a needed version isn't installed, say so and install it with asdf rather than falling back to a different tool.

## JavaScript / Node / TypeScript

- Always use pnpm (not npm or yarn) for new JavaScript/TypeScript projects: `pnpm install`, `pnpm run ...`, commit `pnpm-lock.yaml`.
- Pin `nodejs` and `pnpm` in `.tool-versions`.
- Prefer TypeScript over JavaScript for new projects: `.ts` sources, `strict` mode, and a `typecheck` script (`tsc --noEmit`) in package.json.

## Python

- Use uv for everything: `uv init`, `uv add`, `uv sync`, `uv run ...`. Not pip, poetry, pipenv or hand-made venvs. Commit `uv.lock`.
- Use ty for type checking: add it as a dev dependency (`uv add --dev ty`) and run it with `uv run ty check`.
- Pin `python` in `.tool-versions`.

## Teach Me
Be inquisitive. Ask clarifying questions. Offer to teach me about what we are working on.

## Verify Targets
Confirm the exact target (dashboard URL, database name, board vs. project) before acting; ask a clarifying question when a name is ambiguous.

## Code Comments

Always use the compact output style for coding comments

# Behavioral guidelines

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```
