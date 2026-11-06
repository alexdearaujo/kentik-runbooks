# Redundancy analysis report

<!--
CUSTOMIZE BEFORE USE: replace every {{PLACEHOLDER}} with your own naming, then delete this comment.
{{WAN_IFACE_TAG}}   Interface description tag for WAN circuits (example: wan_iface)
{{INET_IFACE_TAG}}  Interface description tag for internet circuits (example: inet_iface)
-->

**Trigger:** User asks for the WAN site redundancy report.

Follow the redundancy rules below and generate a report of the WAN sites that have redundancy risk.

## Site types

- **Standard site (single router):** 1 router with 2 physical connections, typically one {{INET_IFACE_TAG}} interface
  and one {{WAN_IFACE_TAG}} interface.
- **Dual-homed site (multi-router):** 2 routers, each with 1 connection. One device has the {{INET_IFACE_TAG}}
  interface and the other device has the {{WAN_IFACE_TAG}} interface.

## Redundancy rules

- **Redundancy rule:** Only one interface is active, or the secondary interface has no "up" status. List the reason
  as the site having only one connection or a down interface as the primary reason if that is the case.
- **Redundant capacity rule:** If one connection exceeds 40% utilization, the site is at risk if a failover event
  would push the remaining link to 80% or more.

## Report format

Break the report into three sections.

### Section 1: Summary

- Show the number of sites at critical risk, at warning risk, and healthy. Use an icon for each to make the report
  more visual. Show it as a table: the first column is the title, the second column is the number this week with a
  trend indicator, the third column is last week.
- Next, show a site risk table for all sites. The table contains the site name, risk level, risk category
  (redundancy), the reason, and a next action. In the next action column, add an indicator for whether executive
  action is required.

### Section 2: Details

- Show a table of sites, the interfaces involved, and whether the lack of redundancy is due to a change in the past
  week: either a traffic increase or a link going down.

### Section 3: Evidence

- Show a table of all circuits with issues, each with a clickable link to a query with the evidence.
