# Global preferences

- Always use pnpm (not npm or yarn) for new JavaScript/TypeScript projects: `pnpm install`, `pnpm run ...`, commit `pnpm-lock.yaml`.
- Always manage tool versions with asdf. Every project gets a `.tool-versions` file pinning its tools (e.g. `nodejs`, `pnpm`), using versions already installed (`asdf list <tool>`) where possible.
- Prefer TypeScript over JavaScript for new projects: `.ts` sources, `strict` mode, and a `typecheck` script (`tsc --noEmit`) in package.json.
