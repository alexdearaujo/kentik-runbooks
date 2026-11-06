# Capacity Planning Report

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

## Steps

1. Get all sites from the site inventory
2. Get all interfaces with relevant descriptions ({{WAN_IFACE_TAG}}, {{INET_IFACE_TAG}}, {{DC_IFACE_TAG}}, {{CLOUD_IFACE_TAG}}) to identify circuit types
3. Check interface utilization data from NMS
4. Check for any existing capacity planning alerts
5. Check flow data for those circuits for TOS markings and qos validation. To do this query do a table only visualization using the packets/s total metric to allow for 50,000 rows. Then filter out DSCP 0.
6. Compile the report

-Interface Descriptions: Remote site connections have {{WAN_IFACE_TAG}} or {{INET_IFACE_TAG}} in the descriptions. Data Center interconnect connections have {{DC_IFACE_TAG}}. Cloud connections have {{CLOUD_IFACE_TAG}}.

### Standard Sites (Single Router)

--Architecture: 1 Router with 2 physical connections and a remote site will typically have one {{INET_IFACE_TAG}} interface and one {{WAN_IFACE_TAG}} interface.

### Dual-Homed Sites (Multi-Router)

--Architecture: 2 Routers, each with 1 connections. One device will have the {{INET_IFACE_TAG}} interface and the other device will have the {{WAN_IFACE_TAG}} interface.

### Standard and Dual-Homed Site Rules

--Capacity Rule: If an interface exceeds 70% utilization for the past week or if that circuit is a warning or critical status on a capacity planning report.
--Redundant Capacity Rule: If one connection exceeds 40% utilization, the site is at risk if a failover event would push the remaining link to 80%+
--Redundancy Rule: If only one interface is active or if the secondary interface has no "up" status. List the reason as the site having only one connection or a down interface as the primary reason if that is the case.
--QoS Rule: If the flow traffic on the interfaces are not successful classifying traffic with 3 or more markings.

### Data Centers (DC Type)

-Architecture: 4 total connections split into two distinct failover pairs by VRF.
--{{DC_VRF_MGMT}} (Management/Internal): 2x {{DC_VRF_MGMT_LINK_SPEED}} links. They operate as an Active/Standby or Active/Active pair.
--{{DC_VRF_DATA}} (Data/Internet): 2x {{DC_VRF_DATA_LINK_SPEED}} links. They operate as a separate failover pair

### Data Center Rules

--Capacity Rule: Capacity must be evaluated per VRF. For example, a pair of 10G links carrying 12G in total is a failure, even if the other VRF's pair is idle. If an interface exceeds 70% utilization for the past week or if that circuit is a warning or critical status on a capacity planning report.
--Redundant Capacity Rule: Failover lacks "redundancy capability" if the peak traffic in a VRF exceeds the capacity of a single link in that pair (e.g., more than {{DC_VRF_MGMT_LINK_SPEED}} in {{DC_VRF_MGMT}}).
--Redundancy Rule: If only one interface is active or if the secondary interface has no "up" status. List the reason as the site having only one connection or a down interface as the primary reason if that is the case.
--QoS Rule: If the flow traffic on the interfaces are not successful classifying traffic with 3 or more markings.

### Capacity Planning Report format

-The report should be broken down into three layers/sections.
-Section 1: Summary
-Number of sites that are at critical risk. Number of sites that are at warning risk. Number of sites that are healthy. Using icons for each to make the report more visual. Have it as a table where the first column is the title, second column is the number this week with an indicator of trend, third column is last week.
-Next place a site risk report table for all sites. The site table should contain the site name, risk level, the risk category (whether a capacity, redundant capacity, QoS risk or a redundancy issue) , the reason, and a next action. Under the next action column add an indicator for whether executive action is required.
-Section 2: Details
-Then list a table for each of the following circuit types: Internet Circuits (interface description contains {{INET_IFACE_TAG}}), WAN Circuits (interface description contains {{WAN_IFACE_TAG}}), Cloud Circuits (interface description contains {{CLOUD_IFACE_TAG}}), DC Circuits (interface description contains {{DC_IFACE_TAG}}). For each type,  shows circuits that are at 95th percentile utilization levels for the past week that exceed the capacity rule. In the circuit table, show the site name, device name, interface name, description, and the capacity, and and out p95 values and if it's in a capacity plan, a link to that capacity plan.
-Section 3: Evidence
-List a table of all circuits with issues and link to a query with the evidence that can be clicked on.
