# Contributing

This guide is the standard for every change to this repository. It applies to people and to AI coding agents.

## Workflow

1. Create a branch from `main`. Name it `docs/<short-description>`, for example `docs/add-device-down-runbook`.
2. Add or change the runbook. Use the [runbook template](#runbook-template).
3. Add a new runbook to the table in [README.md](README.md#runbooks). If it uses a new data source, also update the
   data sources table.
4. Run the checks:

   ```sh
   ./scripts/check.sh
   ```

5. Open a pull request. Complete the checklist in the pull request template.

The same checks run on every pull request. A pull request with a failed check does not merge.

## Runbook template

Copy this template into a new file. Delete the sections that do not apply.

```markdown
# Device down

<!--
CUSTOMIZE BEFORE USE: replace every {{PLACEHOLDER}} with your own naming, then delete this comment.
{{CORE_TAG}}  Interface tag for core links (example: core-uplink)
-->

**Trigger:** User reports or asks about a device that is down or unreachable.

## Goal

One short paragraph. Say what the assistant must find out and what it must not do.

## Steps

1. **Step name:** One check. Say which data to use and what result is a problem.
2. **Step name:** If the condition is true, stop here and escalate to network engineering.

## Response

Say what the answer must contain and in which order. Give a fixed format for each outcome.
```

| Part | Required | Rule |
| --- | --- | --- |
| Title (`# ...`) | Yes | The first line of the file. Name the problem, not the tool. |
| `CUSTOMIZE BEFORE USE` comment | If the file has a `{{PLACEHOLDER}}` | Put it directly below the title. List each placeholder with an example. |
| `**Trigger:**` line | Yes | One sentence. Use the words that a user types. |
| `## Goal` | No | Use it to set limits on the assistant. |
| `## Steps` or `## Checks` | Yes | Use `Steps` when the order is important. Use `Checks` when each check is independent. |
| `## Response` | Recommended | Give the answer format. Show one example for each outcome. |

## File rules

- Name the file after the trigger, in kebab case: `device-down.md`.
- Keep each runbook self-contained. The assistant reads one runbook at a time. It cannot follow a link to rules in a
  different runbook. Copy a shared rule into each runbook that needs it.
- Keep lines at 120 characters or fewer. Tables and code blocks can be longer.

## Writing rules

The reader is an AI assistant first and a network engineer second. Write so that each sentence has one meaning.

- Write one instruction in each sentence. Use the imperative: "Check syslog", not "Syslog should be checked".
- Give exact thresholds and time windows: "above 80% for 15 minutes in the past 24 hours", not "high utilization".
- Put exact names in backticks: tool names, field names, metric names, and paths.
- Say when to stop and escalate. Say what the assistant must not do.
- Use the same word for the same thing in all of the runbook.
- Describe the current behavior. Do not write the history of the runbook. Put history in the commit message.

## Placeholders and private data

> [!WARNING]
> This repository is public. Do not commit real customer names, site names, interface tags, VRF names, saved filter
> names, IP addresses, or account IDs.

- Put each network-specific name in a `{{UPPER_SNAKE_CASE}}` placeholder.
- Use a made-up example in the `CUSTOMIZE BEFORE USE` comment.
- Use documentation addresses for IP examples: `192.0.2.0/24`, `198.51.100.0/24`, `203.0.113.0/24`, or `10.0.0.0/8`.

## Checks

[scripts/check.sh](scripts/check.sh) runs these checks:

| Check | Fails when |
| --- | --- |
| markdownlint | A file breaks a rule in [.markdownlint.jsonc](.markdownlint.jsonc). |
| Title | The first line of a runbook is not a level 1 heading (`#`). |
| Trigger | A runbook has no `**Trigger:**` line. |
| Placeholders | A runbook has a `{{PLACEHOLDER}}` but no `CUSTOMIZE BEFORE USE` comment. |
| Index | A runbook is not in the table in [README.md](README.md#runbooks). |

The script needs Node.js for `npx`. The checks do not find private data. The reviewer checks for private data.

## AI coding agents

[AGENTS.md](AGENTS.md) gives the rules to coding agents such as GitHub Copilot, Claude Code, Codex, and Cursor. Each
agent reads that file before it changes the repository. If you change a rule in this guide, change it in
[AGENTS.md](AGENTS.md) too.
