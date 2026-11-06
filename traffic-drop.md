# When investigating a traffic drop do the following

## Steps

1. Flow
Pull bits/s and packets/s per interface/direction for both windows. Rank interfaces by delta. For the top contributors, break missing traffic down by src/dst prefix, ASN, app/port, BGP next-hop, and site tag. Note drop shape (cliff / decay / selective) and directionality. If it's a total drop, verify the failover path.
2. SNMP
For affected interfaces (and LAG members), pull ifOperStatus, ifAdminStatus, ifLastChange, in/out octets and packets, errors, discards, CRC, queue drops. Pull device CPU, memory, temperature, PSU/fan. Compare SNMP byte rates to flow — flag mismatches.
3. Syslog
Retrieve logs from incident_window ±15 min. Extract: link/line-protocol up-down, optical alarms, BGP/OSPF/IS-IS state changes, hardware alarms, CoPP/high-CPU/process events, config commits, ACL/security hits. Order chronologically.
4. Configuration
Diff running config from just before vs. just after the drop, and running vs. startup. Extract changes to interfaces, routing (BGP/route-maps/prefix-lists/statics), ACLs and QoS on the affected interface, L2 (STP, port-channel, VLAN), and security policy. Record commit timestamps and authors.
5. Synthetic Tests
List Kentik synthetic tests whose path traverses the device (match by hostname, mgmt IP, interface IPs in traceroute hops, or BGP-monitor tests on prefixes egressing the device). For each, pull loss, latency, jitter, app-layer success, and path stability for both windows. Tag each test: confirms outage, confirms degradation, path-shifted, or unaffected. If none cover the device, record the gap.
6. Correlation
Build a single UTC timeline of all events from steps 1–6. Identify the earliest non-routine event. Require ≥2 independent telemetry sources to agree before declaring a root cause; otherwise list competing hypotheses with supporting/conflicting evidence.
7. Output

## Return

Summary — root cause, scope, confidence (High/Med/Low)
Impact — magnitude, duration, affected interfaces/prefixes/apps/customers
Timeline — UTC-ordered events
Evidence — specific findings per step (counter, log line, diff hunk, command excerpt, test ID)
Root Cause + confidence
Contributing Factors
Top Talkers — List the top contributors to interface utilization:

| IP Address | Direction | Service / Port | Trend |
| --- | --- | --- | --- |
| | | | Increasing / Decreasing / New |

Failover path
Recommended Remediation — fix, validation, rollback if applicable
Monitoring Gaps
