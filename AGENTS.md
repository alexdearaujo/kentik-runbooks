# Agent instructions

This repository holds Markdown runbooks. An AI assistant with Kentik data reads one runbook at a time and follows it.

## Rules

Obey [CONTRIBUTING.md](CONTRIBUTING.md). Read it before you change a file. These rules are the most important:

1. Do not commit to `main`. Create a `docs/<short-description>` branch.
2. Use the runbook template in [CONTRIBUTING.md](CONTRIBUTING.md#runbook-template).
3. Keep each runbook self-contained. Do not tell the assistant to read a different runbook.
4. Do not add real customer names, site names, interface tags, IP addresses, or account IDs. Use a
   `{{PLACEHOLDER}}` and list it in the `CUSTOMIZE BEFORE USE` comment.
5. Add each new runbook to the table in [README.md](README.md#runbooks).
6. Do not invent Kentik tool names, field names, or metric names. Copy them from an existing runbook or from the
   user. If you are not sure that a name exists, ask the user.
7. Run `./scripts/check.sh`. Fix every failure before you say the work is done.

## Before you finish

Report the result of `./scripts/check.sh`. List each runbook that you added or changed.
