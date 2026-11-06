# Interface bandwidth investigation

**Trigger:** User asks to investigate a specific interface for capacity.

## Steps

1. **Interface inventory:** Look up the interface details from the interface inventory.
2. **NMS utilization:** Check utilization data for the interface (peak, average, % of capacity).
3. **Capacity alerts:** Check for any active or recent capacity alerts on this interface.
4. **Flow data check:** Verify flow data is being collected for this interface.

   > ⚠️ **CRITICAL: STOP if no flow data.** This interface does not have flow data collected. Steps 5 and 6 cannot be
   > completed.

5. **QoS analysis:** Query flow data for DSCP/CoS markings and traffic distribution.
6. **Top talkers:** List the top contributors to interface utilization:

   | IP Address | Direction | Service / Port | Trend |
   | --- | --- | --- | --- |
   | | | | Increasing / Decreasing / New |
