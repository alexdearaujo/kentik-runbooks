# Interface down

**Trigger:** User reports or asks about an interface down event.

## Steps

1. **Interface inventory:** Look up the interface details. Confirm admin status vs. operational status (is this
   expected to be up?).
2. **Event timeline:** Pull the interface state change history. Note when it went down and how many flaps have
   occurred.
3. **Active alerts:** Check for any active alerts on this interface or its parent device.
4. **Device reachability:** Confirm whether the device itself is reachable. If the device is down, stop here and
   escalate as a device outage.
5. **Neighbor and peer status:** Check the state of adjacent interfaces or routing peers (BGP, OSPF, etc.) to determine
   blast radius.
6. **Recent changes:** Check for any configuration changes or maintenance windows correlated with the down event.
7. **Impact assessment:** Identify any services, tunnels, or prefixes depending on this interface that are now affected.
8. **Traffic failover validation:** Use flow data to confirm that traffic successfully moved to another interface on
   the device or to another device at the site.
