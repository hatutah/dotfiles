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
