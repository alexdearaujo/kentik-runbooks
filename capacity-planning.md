# Capacity planning report

<!--
CUSTOMIZE BEFORE USE: replace every {{PLACEHOLDER}} with your own naming, then delete this comment.
{{WAN_IFACE_TAG}}           Interface description tag for WAN circuits (example: wan_iface)
{{INET_IFACE_TAG}}          Interface description tag for internet circuits (example: inet_iface)
{{DC_IFACE_TAG}}            Interface description tag for data center interconnects (example: dc_iface)
{{CLOUD_IFACE_TAG}}         Interface description tag for cloud circuits such as AWS Direct Connect (example: cloud_iface)
{{DC_VRF_MGMT}}             Data center VRF for management/internal traffic (example: VRF_A)
{{DC_VRF_MGMT_LINK_SPEED}}  Speed of each link in the management VRF pair (example: 10G)
{{DC_VRF_DATA}}             Data center VRF for data/internet traffic (example: VRF_B)
{{DC_VRF_DATA_LINK_SPEED}}  Speed of each link in the data VRF pair (example: 100G)
Also review the utilization thresholds (70%, 40%, 80%) against your own capacity policy.
-->

**Trigger:** User asks for the weekly capacity planning report.

## Steps

1. Get all sites from the site inventory.
2. Get all interfaces with relevant descriptions ({{WAN_IFACE_TAG}}, {{INET_IFACE_TAG}}, {{DC_IFACE_TAG}},
   {{CLOUD_IFACE_TAG}}) to identify circuit types.
3. Check interface utilization data from NMS.
4. Check for any existing capacity planning alerts.
5. Check flow data for those circuits for TOS markings and QoS validation. For this query, use a table-only
   visualization with the packets/s total metric to allow for 50,000 rows. Then filter out DSCP 0.
6. Compile the report.

## Interface descriptions

- Remote site connections have {{WAN_IFACE_TAG}} or {{INET_IFACE_TAG}} in the descriptions.
- Data center interconnect connections have {{DC_IFACE_TAG}}.
- Cloud connections have {{CLOUD_IFACE_TAG}}.

## Site types

### Standard sites (single router)

- Architecture: 1 router with 2 physical connections. A remote site typically has one {{INET_IFACE_TAG}} interface
  and one {{WAN_IFACE_TAG}} interface.

### Dual-homed sites (multi-router)

- Architecture: 2 routers, each with 1 connection. One device has the {{INET_IFACE_TAG}} interface and the other
  device has the {{WAN_IFACE_TAG}} interface.

### Standard and dual-homed site rules

- **Capacity rule:** An interface exceeds 70% utilization for the past week, or that circuit has a warning or
  critical status on a capacity planning report.
- **Redundant capacity rule:** If one connection exceeds 40% utilization, the site is at risk if a failover event
  would push the remaining link to 80% or more.
- **Redundancy rule:** Only one interface is active, or the secondary interface has no "up" status. List the reason
  as the site having only one connection or a down interface as the primary reason if that is the case.
- **QoS rule:** The flow traffic on the interfaces is not classified with 3 or more markings.

### Data centers (DC type)

- Architecture: 4 total connections split into two distinct failover pairs by VRF.
  - {{DC_VRF_MGMT}} (management/internal): 2x {{DC_VRF_MGMT_LINK_SPEED}} links. They operate as an Active/Standby or
    Active/Active pair.
  - {{DC_VRF_DATA}} (data/internet): 2x {{DC_VRF_DATA_LINK_SPEED}} links. They operate as a separate failover pair.

### Data center rules

- **Capacity rule:** Evaluate capacity per VRF. For example, a pair of 10G links carrying 12G in total is a failure,
  even if the other VRF's pair is idle. An interface exceeds 70% utilization for the past week, or that circuit has a
  warning or critical status on a capacity planning report.
- **Redundant capacity rule:** Failover lacks "redundancy capability" if the peak traffic in a VRF exceeds the
  capacity of a single link in that pair (for example, more than {{DC_VRF_MGMT_LINK_SPEED}} in {{DC_VRF_MGMT}}).
- **Redundancy rule:** Only one interface is active, or the secondary interface has no "up" status. List the reason
  as the site having only one connection or a down interface as the primary reason if that is the case.
- **QoS rule:** The flow traffic on the interfaces is not classified with 3 or more markings.

## Report format

Break the report into three sections.

### Section 1: Summary

- Show the number of sites at critical risk, at warning risk, and healthy. Use an icon for each to make the report
  more visual. Show it as a table: the first column is the title, the second column is the number this week with a
  trend indicator, the third column is last week.
- Next, show a site risk table for all sites. The table contains the site name, risk level, risk category (capacity,
  redundant capacity, QoS, or redundancy), the reason, and a next action. In the next action column, add an
  indicator for whether executive action is required.

### Section 2: Details

- Show a table for each of these circuit types:
  - Internet circuits (interface description contains {{INET_IFACE_TAG}})
  - WAN circuits (interface description contains {{WAN_IFACE_TAG}})
  - Cloud circuits (interface description contains {{CLOUD_IFACE_TAG}})
  - DC circuits (interface description contains {{DC_IFACE_TAG}})
- For each type, show the circuits whose 95th percentile utilization for the past week exceeds the capacity rule.
  In the circuit table, show the site name, device name, interface name, description, capacity, in and out p95
  values, and, if it's in a capacity plan, a link to that capacity plan.

### Section 3: Evidence

- Show a table of all circuits with issues, each with a clickable link to a query with the evidence.
