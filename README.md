# Kentik runbooks

Network troubleshooting runbooks for an AI assistant that can query Kentik data, for example Kentik AI Advisor.

Each runbook is a Markdown prompt. It tells the assistant which checks to run, in which order, and how to format the
answer. A network engineer can also follow a runbook by hand.

## Runbooks

| Runbook | Use it when | Placeholders |
| --- | --- | --- |
| [bgp-neighbor-down.md](bgp-neighbor-down.md) | A BGP session goes down. | None |
| [interface-down.md](interface-down.md) | An interface goes down. | None |
| [interface-bandwidth.md](interface-bandwidth.md) | A user asks about the capacity of one interface. | None |
| [traffic-drop.md](traffic-drop.md) | Traffic on a device or interface drops. | None |
| [site-slowness.md](site-slowness.md) | Users at a site report slow internet or slow applications. | 2 |
| [src-ip-troubleshooting.md](src-ip-troubleshooting.md) | A user gives a source IP and asks to trace or check its path. | 4 |
| [capacity-planning.md](capacity-planning.md) | You need a weekly capacity report for all sites. | 8 |
| [site-redundancy-analysis.md](site-redundancy-analysis.md) | You need a report of WAN sites with redundancy risk. | None |

## Data sources

The runbooks use these data sources. A runbook step fails or gives a weak answer if its source is missing.

| Source | Used by |
| --- | --- |
| Flow data (NetFlow, sFlow, IPFIX) | `interface-bandwidth`, `interface-down`, `traffic-drop`, `src-ip-troubleshooting`, `capacity-planning` |
| SNMP interface and device metrics | Most runbooks |
| Syslog | `traffic-drop`, `site-slowness`, `src-ip-troubleshooting` |
| Device configuration and config diffs | `traffic-drop`, `src-ip-troubleshooting` |
| BGP session state | `bgp-neighbor-down`, `site-slowness`, `traffic-drop` |
| Kentik synthetic tests | `traffic-drop` |
| Interface and site inventory | All runbooks |

## How to use

1. Pick the runbook that matches the problem. Use the table in [Runbooks](#runbooks).
2. If the runbook has a `CUSTOMIZE BEFORE USE` comment at the top, replace each `{{PLACEHOLDER}}` with the name your
   network uses. The comment lists each placeholder with an example. Then delete the comment.
3. Give the runbook to the assistant, for example as a saved instruction or pasted into the chat.
4. Ask the question in the words of the trigger, for example "internet is slow from 10.10.1.50".
5. Read the verdict first. Ask a follow-up question to get the detail tables.

To find placeholders that you did not replace yet:

```sh
grep -n '{{' *.md
```

> [!WARNING]
> This repository is public. Keep your real interface tags, VRF names, saved filter names and site names in a private
> copy. Do not commit them here.

## Suggested changes

A review of the runbooks found these problems. Each item names the file and the fix.

### Errors that change the result

| File | Problem | Fix |
| --- | --- | --- |
| [interface-bandwidth.md](interface-bandwidth.md) | The STOP note in step 4 says "Steps 4–6 cannot be completed". Step 4 is the check itself. | Change it to "Steps 5–6". |
| [interface-bandwidth.md](interface-bandwidth.md) | The Top Talkers table has no blank line before it, so it does not render as a table inside the list. | Add a blank line and indent the table under step 6. |
| [traffic-drop.md](traffic-drop.md) | Step 6 builds a timeline "from steps 1–6", but step 6 is the timeline. | Change it to "steps 1–5". |
| [traffic-drop.md](traffic-drop.md) | "Both windows" and `incident_window` have no definition. | Define the incident window and the baseline window (for example, the same hour one week earlier). |
| [traffic-drop.md](traffic-drop.md) | Step 7 "Output" has no content. | Remove step 7. The `Return` section already covers the output. |
| [site-redundancy-analysis.md](site-redundancy-analysis.md) | It says "following the redundancy rules listed", but the rules are in `capacity-planning.md`. | Copy the redundancy rules into this file, or link to them. |
| [src-ip-troubleshooting.md](src-ip-troubleshooting.md) | Analysis step 6 builds topology maps, but the Response section says to show only the verdict. | State that the maps go in the Detailed Response only. |
| [site-slowness.md](site-slowness.md) | "Sustained high utilization" has no threshold. | Give a number and a time, for example above 80% for 15 minutes. |

### Structure and consistency

- Give every runbook the same header: one `#` title, then a `Trigger` line. Now the titles are mixed, for example
  `# **Trigger:** ...`, `# Trigger`, and `# When investigating a traffic drop do the following`.
- Give the two report runbooks a trigger, for example "User asks for the weekly capacity report".
- `capacity-planning.md` and `site-redundancy-analysis.md` use the same summary format. Keep it in one place and link
  to it, so a change is a one-place edit.
- `capacity-planning.md` uses `-` and `--` as list markers. Markdown does not render these as lists. Use real nested
  lists.
- Use one dash style in step titles. Some steps use an em dash and some use a hyphen.
- Add a `.markdownlint.jsonc` file and lint every runbook.

### Typos

| File | Text | Fix |
| --- | --- | --- |
| [capacity-planning.md](capacity-planning.md) | "each with 1 connections" | "each with 1 connection" |
| [capacity-planning.md](capacity-planning.md) | "the capacity, and and out p95 values" | "the capacity, and in and out p95 values" |
| [interface-down.md](interface-down.md) | "traffic successful moved" | "traffic successfully moved" |
| [site-redundancy-analysis.md](site-redundancy-analysis.md) | "This out a table" | "Show a table" |
| [site-slowness.md](site-slowness.md) | "should never be surfaces" | "should never be surfaced" |
| [site-slowness.md](site-slowness.md) | "more then 24 hours" | "more than 24 hours" |
| [src-ip-troubleshooting.md](src-ip-troubleshooting.md) | `**3. NAT Detection` (no closing `**`) | `**3. NAT Detection**` |
| [src-ip-troubleshooting.md](src-ip-troubleshooting.md) | "internt", "revers", "get's", "worse thing" | "internet", "reverse", "gets", "worst thing" |
| [src-ip-troubleshooting.md](src-ip-troubleshooting.md) | "Start about doing a query" | "Start with a query" |
| [src-ip-troubleshooting.md](src-ip-troubleshooting.md) | `-**DO NOT INCLUDE ...` (broken bold) | `- **Do not include ...**` |

### New runbooks to consider

- Device down or unreachable. `interface-down.md` already stops and escalates for this case.
- High CPU or memory on a device.
- DDoS or traffic spike. This is the opposite of `traffic-drop.md`.

### Repository

- Add a license. Without one, nobody else can legally reuse the runbooks.

## Contributing

1. Create a branch, for example `docs/add-device-down-runbook`.
2. Name the file after the trigger in kebab case, for example `device-down.md`.
3. Start the file with a title and a `Trigger` line.
4. Put each network-specific name in a `{{PLACEHOLDER}}` and list it in a `CUSTOMIZE BEFORE USE` comment.
5. Add the runbook to the table in [Runbooks](#runbooks).
6. Open a pull request.
