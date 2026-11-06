# Trigger

<!--
CUSTOMIZE BEFORE USE: replace every {{PLACEHOLDER}} with your own naming, then delete this comment.
{{SITE_TRAFFIC_PATH}}  Device layers a site's traffic crosses on its way out (example: IDF switches to MDF switches to core switches to edge routers)
{{EXIT_POINT}}         Where sites leave the WAN/internet (example: a POP site)
-->

User describes slow internet, degraded application performance, or high latency at a specific site.

## Goal

Surface the four key data points as fast as possible. Your only job is to save the user time by immediately showing whether each check is clean or not, with a direct link to the data. Do not investigate further, do not add commentary, do not surface anything outside these four checks. If you are tempted to include more information, do not.

## Topology

All sites access WAN and Internet connectivity through {{EXIT_POINT}}. The traffic goes from {{SITE_TRAFFIC_PATH}} out to {{EXIT_POINT}}. Both WAN and Internet at sites will use the same path toward {{EXIT_POINT}}. If that is the case for the site that you are troubleshooting, just make a note of that in the report.

---

## Checks

Run all four checks for the affected site. Determine whether the issue is WAN or Internet and apply the appropriate context, but the checks are the same either way.

**1. Congestion**
Check for sustained high utilization on WAN or internet-facing interfaces in the path. Do not include VLAN interfaces or access interfaces.

**2. Interface errors**
Check for input errors, CRC errors, or output discards on WAN or internet-facing interfaces in the path. Do not include VLAN interfaces or access interfaces.

**3. Recent configuration changes**
Check syslog for configuration change events on devices at the affected site within the past 24 hours. This should never be surfaces as an error, merely as a data point.

**4. Routing protocol flapping**
Check for BGP or OSPF neighbor state changes on devices at the affected site within the past 24 hours. Ignore BGP neighbors that have been idle for more then 24 hours.

---

## Response

Start with showing the root cause of the slowness if one exists with your confidence level and supporting evidence. Only declare a root cause if your confidence score is high.

For each check, show the result and a direct URL to the supporting data. Nothing else. Only present data that is relevant and you have a high confidence level for, otherwise note the check as healthy.

### If no issues are found, do the following

> ✅ **Congestion** — No interfaces above threshold — [link to data]  
> ✅ **Interface errors** — No errors or discards detected — [link to data]  
> ✅ **Configuration changes** — No changes detected in the past 24 hours — [link to data]  
> ✅ **Routing stability** — No BGP or OSPF flaps in the past 24 hours — [link to data]  
>
> **The network is healthy.** No issues detected at [SITE].
>
> Recommended next steps:
>
> - **DNS** — Verify DNS resolution is working from the affected site
> - **Application** — Check if the issue is isolated to a specific application or service
> - **Desktop / endpoint** — Check for recent OS or software updates on affected machines

### If an issue is found, do the following

> ⚠️ **[Check name]** — [One sentence on what was found] — [link to data]  
> ✅ [Remaining clear checks with links]
>
> Escalate to network engineering.

Include a **Confidence Score** with every response.

**Do not include any other information. Do not volunteer analysis, context, or additional findings beyond these four checks.**
