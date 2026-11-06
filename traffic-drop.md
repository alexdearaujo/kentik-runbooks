# Traffic drop investigation

**Trigger:** User reports or asks about a drop in traffic on a device, interface, or site.

## Time windows

- **Incident window:** from the start of the drop to its end, or to now if traffic has not recovered.
- **Baseline window:** the same time span one week earlier.

## Steps

1. **Flow**
   Pull bits/s and packets/s per interface/direction for both windows. Rank interfaces by delta. For the top
   contributors, break missing traffic down by src/dst prefix, ASN, app/port, BGP next-hop, and site tag. Note drop
   shape (cliff / decay / selective) and directionality. If it's a total drop, verify the failover path.
2. **SNMP**
   For affected interfaces (and LAG members), pull ifOperStatus, ifAdminStatus, ifLastChange, in/out octets and
   packets, errors, discards, CRC, queue drops. Pull device CPU, memory, temperature, PSU/fan. Compare SNMP byte rates
   to flow and flag mismatches.
3. **Syslog**
   Retrieve logs from 15 minutes before the incident window to 15 minutes after it. Extract: link/line-protocol
   up-down, optical alarms, BGP/OSPF/IS-IS state changes, hardware alarms, CoPP/high-CPU/process events, config
   commits, ACL/security hits. Order chronologically.
4. **Configuration**
   Diff running config from just before vs. just after the drop, and running vs. startup. Extract changes to
   interfaces, routing (BGP/route-maps/prefix-lists/statics), ACLs and QoS on the affected interface, L2 (STP,
   port-channel, VLAN), and security policy. Record commit timestamps and authors.
5. **Synthetic tests**
   List Kentik synthetic tests whose path traverses the device (match by hostname, mgmt IP, interface IPs in
   traceroute hops, or BGP-monitor tests on prefixes egressing the device). For each, pull loss, latency, jitter,
   app-layer success, and path stability for both windows. Tag each test: confirms outage, confirms degradation,
   path-shifted, or unaffected. If none cover the device, record the gap.
6. **Correlation**
   Build a single UTC timeline of all events from steps 1–5. Identify the earliest non-routine event. Require ≥2
   independent telemetry sources to agree before declaring a root cause; otherwise list competing hypotheses with
   supporting/conflicting evidence.

## Return

- **Summary:** root cause, scope, confidence (High/Med/Low)
- **Impact:** magnitude, duration, affected interfaces/prefixes/apps/customers
- **Timeline:** UTC-ordered events
- **Evidence:** specific findings per step (counter, log line, diff hunk, command excerpt, test ID)
- **Root cause and confidence**
- **Contributing factors**
- **Top talkers:** list the top contributors to interface utilization:

  | IP Address | Direction | Service / Port | Trend |
  | --- | --- | --- | --- |
  | | | | Increasing / Decreasing / New |

- **Failover path**
- **Recommended remediation:** fix, validation, rollback if applicable
- **Monitoring gaps**
