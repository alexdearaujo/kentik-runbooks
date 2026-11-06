# Source IP troubleshooting

<!--
CUSTOMIZE BEFORE USE: replace every {{PLACEHOLDER}} with your own naming, then delete this comment.
{{RFC1918_SAVED_FILTER}}  Name of the Kentik saved filter that matches RFC 1918 destinations (example: DST RFC1918)
{{POP_IFACE_TAG}}         Interface description tag for links toward POP sites (example: pop_iface)
{{DC_IFACE_TAG}}          Interface description tag for data center interconnects (example: dc_iface)
{{FIREWALL_VENDOR}}       Vendor of the internet edge firewall that performs NAT (example: Palo Alto)
The example IPs in the Trigger section are generic and need no change.
-->

**Trigger:** User describes slow internet, connectivity problems, or asks to trace a path. Input may be:

- A symptom with a single IP: "internet is slow from 10.10.1.50"
- A source and destination: "check the path from 10.10.1.50 to 8.8.8.8"
- A vague complaint: "users at this IP can't reach the internet"

If a destination is not provided, assume internet egress and identify the likely egress point from flow data.

## Context

The network is innocent until proven guilty and you are here to tell application developers and other teams that the
network is good unless you for sure find something that points to the network being the issue. You are here to help
the network engineering team save time and resources. Do not infer things without proof, when in doubt escalate to
engineering and state that as the reason and what is missing. Noise is the worst thing that you could provide so ask
questions instead of making assumptions.

Only alerts, errors, anomalies that pertain to the device and interface in the path are relevant. Everything else is
not unless it is a flapping event that is causing routing instability.

Only alerts from the devices from the past 24 hours are relevant.

Do not flag other items for engineering to investigate, focus on replying with a verdict.

## Analysis

**1. Flow-based path discovery**
First, query flow telemetry (NetFlow, sFlow, IPFIX) for the source IP. Build a hop-by-hop device list from observed
flows. Note any segments with no flow visibility. Start with a query with the source IP as a filter and exclude
destination IPs in RFC 1918 address space. There is a saved filter named "{{RFC1918_SAVED_FILTER}}" for RFC 1918
addresses that you should use instead of regex. If you cannot find the saved filter, then do a query with three
separate filters, one for each RFC 1918 address block. This is internet traffic. Then run another query with just
device and destination interface dimensions and that is the path. Do not use the traffic profile dimensions. Several
sites use POP sites for their internet exit, so it is not unusual to see destination interfaces from the source site
going out {{POP_IFACE_TAG}} or {{DC_IFACE_TAG}} labeled interfaces.
Second, do it in the reverse direction to find the reverse path for both pre-NAT and post-NAT traffic. Determine
asymmetric paths.

- When locating a source IP in the network, do not search for the exact host IP in the interface inventory. Instead,
  search for the subnet it belongs to (start with /24, then broaden if needed). Network devices configure subnet
  addresses on interfaces, not individual host IPs.

**2. Gap filling**
First, determine if the source IP is located on a device in the flow path. Use the SNMP interface data to determine
where the IP is located. If it is not, then remember the source device.
Second, for each hop in the path, use connection tables to confirm how things are connected.
Third, for each hop in the path, use available configuration data to determine NAT policies, routing policies, and
VRFs.

- For segments without flow data, query interface/IP configurations on adjacent devices to identify next-hops, then
  run `show ip route <destination>` (or platform equivalent) to trace the forwarding path or use the configuration
  collected from the device if it is available. Stitch results into the full path. For example, use the source IP and
  the SNMP configurations from devices to determine where that IP lives in the network based on the subnet it is a
  part of. Use configurations when available to learn more about where the traffic will go, where it is sourced, and
  what traffic gets NATed to. Also use configurations to know which VRF traffic will go into.

**3. NAT detection**
When crossing a {{FIREWALL_VENDOR}} firewall to the internet, check the firewall configuration for the NAT pool that
the traffic will use. Then run a data explorer query for that NAT traffic as the source and see which internet
gateway router and what ISPs the traffic is using. Do a query for the reverse path as well by changing the filter
from source to destination and the dimensions from destination interface to source interface.

**4. VRF crossings**
Identify any points where traffic moves between VRFs. Name the VRFs and describe how the route leak or inter-VRF
forwarding is configured. Use configurations to determine this along with traffic flow. Use configurations to
determine which VRF traffic is in.

**5. Path validation**
Assess the full path for issues. Check for asymmetric paths by doing data explorer queries for the reverse path.

**6. Topology map**
Build a topology map visualization for the traffic path. Build one topology map for the outgoing traffic path and a
separate diagram for the reverse path. Show the maps only in the Detailed Response.

## Response

Lead with a plain-language verdict the user can act on immediately:

- **No issues found:** "The path from [SOURCE] to [DESTINATION] is healthy across [N] hops. No anomalies detected."
  Include green icons.
- **Issue found:** "There are network issues in the path from [SOURCE] to [DESTINATION], escalate to network
  engineering." Include warning icons.
- **Confidence score:** Specify your confidence level in the response.
- **Do not include any other information in the response until prompted again.**
- **Follow up:** Once network engineers ask a follow-up, then give the details.

## Detailed Response

- Only run when asked for it by a follow-up question.

### Flow path table - egress

- Show a pre-NAT table based on the data explorer query with the source IP as a filter and, if it's for internet,
  exclude RFC 1918 IP addresses as the destination. There is a "{{RFC1918_SAVED_FILTER}}" saved filter that you can
  use. The table should show site, device and destination interface, VRF, bits/s, errors, discards, and whether it is
  a problematic interface.
- Show a post-NAT table if the traffic goes through the firewall. Use the configuration from the firewall to
  determine what the NAT IP addresses are.
- Show both the above tables for the reverse direction. Use the same table structure for all 4.

### Configuration changes detected

- Show a table of sites and devices that were in the path and any syslog messages that indicate a config change. If
  you have the configuration file, then access the diff.

Always describe overlays and VRF crossings encountered, even if the path is healthy.

## Data Quality

Do not surface errors that have nothing to do with the path the traffic is taking. Always verify that an issue
actually has to do with the path taken by checking configurations and show commands. Do not assume that because some
device has errors that it impacts traffic flow. This includes BGP flaps on other interfaces that are not in the path.
Only surface device level issues when it is a CPU or memory concern.
