# BGP neighbor down

**Trigger:** User reports or asks about a BGP session down event.

## Steps

1. **Session details:** Look up the BGP session from inventory. Confirm peer IP, ASN, session type (eBGP/iBGP), and
   expected state.
2. **Event timeline:** Pull the session state change history. Note when it went down and whether it has flapped.
3. **Active alerts:** Check for any active BGP or device alerts related to this session or its host device.
4. **Device and interface reachability:** Confirm the local device and the peering interface are up and reachable. If
   either is down, stop here and link to the device or interface down runbook.
5. **Prefix impact:** Identify which prefixes were withdrawn as a result of this session going down. Note any that have
   no alternate path.
6. **Peer history:** Check if this peer has had prior instability (repeated flaps, holds, or resets) in the last 7 days.
7. **Recent changes:** Check for configuration changes, policy updates, or maintenance windows correlated with the
   event.
8. **Impact assessment:** Identify any traffic, services, or customers affected by the lost prefixes.
