# Interface Bandwidth Investigation

**Trigger:** User asks to investigate a specific interface for capacity.

---

1. **Interface Inventory** — Look up the interface details from the interface inventory.
2. **NMS Utilization** — Check utilization data for the interface (peak, average, % of capacity).
3. **Capacity Alerts** — Check for any active or recent capacity alerts on this interface.
4. **Flow Data Check** — Verify flow data is being collected for this interface.
   > ⚠️ **CRITICAL — STOP if no flow data.** This interface does not have flow data collected. Steps 4–6 cannot be completed.
5. **QoS Analysis** — Query flow data for DSCP/CoS markings and traffic distribution.
6. **Top Talkers** — List the top contributors to interface utilization:
| IP Address | Direction | Service / Port | Trend |
|---|---|---|---|
| | | | Increasing / Decreasing / New |
