# Kentik runbooks

Network troubleshooting runbooks for an AI assistant that can query Kentik data, for example Kentik AI Advisor.

Each runbook is a Markdown prompt. It tells the assistant which checks to run, in which order, and how to format the
answer. A network engineer can also follow a runbook by hand.

> [!IMPORTANT]
> This is not an official Kentik product. The Kentik product team does not support it. The Kentik Professional
> Services team wrote the first runbooks. Anyone can add a runbook. See [Contributing](#contributing).

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
| [site-redundancy-analysis.md](site-redundancy-analysis.md) | You need a report of WAN sites with redundancy risk. | 2 |
| [ude-dashboards.md](ude-dashboards.md) | A user asks to build a dashboard on an account with UDE enabled. | None |

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

## Suggested runbooks

- Device down or unreachable. `interface-down.md` already stops and escalates for this case.
- High CPU or memory on a device.
- DDoS or traffic spike. This is the opposite of `traffic-drop.md`.

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md). It has the runbook template, the writing rules, and the checks. AI coding
agents read the same rules from [AGENTS.md](AGENTS.md).

Run the checks before you open a pull request:

```sh
./scripts/check.sh
```

## License

[CC BY 4.0](LICENSE). You can share and adapt the runbooks if you give credit.
