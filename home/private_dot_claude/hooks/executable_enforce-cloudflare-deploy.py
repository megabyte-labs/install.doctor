#!/usr/bin/env python3
"""
PostToolUse hook — Cloudflare deploy enforcement gate.

Fires after Write|Edit|MultiEdit creates/edits a Cloudflare-deployable surface
(wrangler.toml / wrangler.jsonc / wrangler.json / cloudflare.config.ts). Surfaces a
system-reminder (exit-code-2 stderr) that deploy is MANDATORY and kills the two
rationalizations that have skipped deploy in the past:

  1. "env var unset => no credentials => BLOCKED_EXTERNAL"  — FALSE. The get-secret
     broker is the source of truth for creds; an unset env var proves nothing. You MUST
     run `get-secret CLOUDFLARE_API_TOKEN` (+ CLOUDFLARE_ACCOUNT_ID) before ever writing
     BLOCKED_EXTERNAL for a Cloudflare credential.
  2. "greenfield / first slice => no deployed surface yet => defer deploy" — FALSE. The
     Prime Directive deploys a skeleton to *.workers.dev on the FIRST pass. "No URL yet"
     means create one now, not defer.

Reads the harness hook-input JSON from stdin. Spec:
https://docs.claude.com/en/docs/claude-code/hooks

Determinism beats documentation — this is the enforcement arm of
rules/verification-loop.md § Auth fallback + skill 08. Without it, the rule is aspirational.
"""

from __future__ import annotations
import json
import sys
from pathlib import Path

CF_CONFIG_NAMES = {
    "wrangler.toml",
    "wrangler.jsonc",
    "wrangler.json",
    "cloudflare.config.ts",
}


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0  # never block on malformed input

    if payload.get("tool_name", "") not in {"Write", "Edit", "MultiEdit"}:
        return 0

    target = (
        payload.get("tool_input", {}).get("file_path")
        or payload.get("tool_input", {}).get("path")
        or ""
    )
    if not target or Path(target).name not in CF_CONFIG_NAMES:
        return 0

    print(
        f"[cloudflare-deploy-gate] {Path(target).name} written => this repo has a "
        "Cloudflare-deployable surface, so deploy is MANDATORY this session "
        "(rules/verification-loop.md + skill 08; 'No deploy = not shipped').\n"
        "  1. Resolve creds via `get-secret CLOUDFLARE_API_TOKEN` + `CLOUDFLARE_ACCOUNT_ID` "
        "(fall back to CLOUDFLARE_API_KEY/EMAIL, then `wrangler login`). An UNSET ENV VAR IS "
        "NOT 'no creds' — the broker is the source of truth and holds the CF creds.\n"
        "  2. Greenfield/first-pass is NOT exempt: provision D1 (`wrangler d1 create`), apply "
        "migrations --remote, `wrangler deploy` to *.workers.dev, then curl the live /health.\n"
        "  3. Only after the broker AND `wrangler login` BOTH fail may you write "
        "BLOCKED_EXTERNAL — and then with the exact failing command as evidence.\n"
        "This is a warning, not a block.",
        file=sys.stderr,
    )
    return 2


if __name__ == "__main__":
    sys.exit(main())
