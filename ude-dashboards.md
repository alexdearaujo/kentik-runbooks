# UDE dashboards

**Trigger:** User asks to create or change a dashboard on an account with UDE enabled.

## Field names

Use ONLY exact, case-sensitive names. Names must belong to the panel's own measurement. Never reuse names from another
panel, from `synthetics_*` tools, or from memory.

Paths: `/traffic`, `/synthetics/{ping,dns,throughput,http,pageload}`, `/metrics/...`, `/bgp`, `/events`, `/cost`,
`/cloud/...`

For `/metrics/*`, `/bgp`, `/events`, `/cost` and `/cloud/*`: call `ude_explore` with the exact path first. Use only
returned names.

## Traffic

**Metrics:** `both_bits_per_sec`, `in_bits_per_sec`, `out_bits_per_sec`, `total_bytes`, `total_in_bytes`,
`total_out_bytes`, `both_pkts_per_sec`, `in_pkts_per_sec`, `out_pkts_per_sec`, `total_packets`, `total_in_packets`,
`total_out_packets`, `fps`, `total_fps`, `bytes_per_src_ip`, `total_bytes_per_src_ip`, `bytes_per_dst_ip`,
`max_sample_rate`, `avg_sample_rate`

**Dimensions:** `i_device_id` (Device), `i_device_site_name` (Site), `i_device_site_country`, `input_port`,
`output_port` (Interface), `inet_src_addr`, `inet_dst_addr`, `l4_src_port`, `l4_dst_port`, `protocol`,
`src_proto_port`, `dst_proto_port`, `application`, `src_as`, `dst_as`, `src_nexthop_asn`, `dst_nexthop_asn`,
`src_geo`, `dst_geo`, `src_cloud`, `dst_cloud`, `src_cdn`, `dst_cdn`, `i_trf_profile`, `dscp`, `tcp_flags`, `vlan_in`,
`vlan_out`, `Traffic` (total)

**Filter-only, never group by:** `i_device_name`, `i_device_label`, `i_input_interface_description`,
`i_output_interface_description`, `i_input_snmp_alias`, `i_output_snmp_alias`

- For other `/traffic` dimensions, call `ude_explore "/traffic"`.
- Group by device = `i_device_id`.
- Group by interface = `input_port` or `output_port`.

## Synthetics

For synthetics panels, use ONLY the measurement, metric and dimension names below. They are exact and case-sensitive.
Never use traffic names (`i_device_id` etc.) or names from the `synthetics_*` tools. Each measurement has its own
metric prefix; never mix them.

### Measurements and metrics

| Measurement | Metrics |
| --- | --- |
| `/synthetics/ping` | `ping_latency_avg`, `ping_jitter_avg`, `ping_packet_loss_pct`, `ping_latency_health`, `ping_jitter_health`, `ping_packet_loss_health` |
| `/synthetics/dns` | `dns_latency_avg`, `dns_latency_health`, `dns_code` |
| `/synthetics/throughput` | `throughput_bandwidth_avg` |
| `/synthetics/http` | `http_latency_avg`, `http_latency_health`, `http_status_code`, `http_response_size` |
| `/synthetics/pageload` | `pageload_latency_avg`, `pageload_latency_health`, `pageload_status_code`, `pageload_response_size` |

### Dimensions

All measurements: `test_id`, `src_agent`, `src_agent_site_id`, `src_agent_asn`, `src_agent_ip`, `src_agent_country`

| Measurement | Extra dimensions |
| --- | --- |
| ping, throughput | `dst_address`, `dst_agent`, `dst_agent_site_id`, `dst_agent_asn`, `dst_agent_ip`, `dst_agent_country`, `dst_task_target` |
| dns | `task_dns_resolver`, `task_dns_target_hostname` (no `dst_*` dimensions) |
| http, pageload | `dst_address`, `dst_task_target` (no `dst_agent*` dimensions) |

### Rules

- `*_health`, `*_status_code` and `dns_code` are enumerated codes, not averages. Don't use them as latency values.
- `test_id` and `src_agent` are integer IDs. Filter on IDs, not names.
- `ktlabel_syn_agent` and `ktlabel_syn_test` are for filters only. Never group by them.
- For dashboard variables on synthetics panels, use "custom" variables with `variableMappings` (`filterField`
  `src_agent` or `test_id`). Don't use guided variables like "Device".
- Filter `filterField` values are not validated, so use only the dimension names above.
- If you need a name that isn't listed, call `ude_explore` with the exact path (e.g. `"/synthetics/ping"`) and use only
  the names it returns. A vague query like `"synthetics"` returns only a list of paths.

## Mixed dashboards

- Choose metrics and dimensions per panel.
- Guided variables resolve per panel by measurement. Device, Site, Country and AS Number have no synthetics mapping.
  For synthetics panels, use custom variables with `variableMappings` on `src_agent` or `test_id`.
- Filter `filterField` values are not validated; use only listed names.

## Build rules

**Important:** follow these rules on every dashboard build.

### Dashboard build order

- Put every section BEFORE its children. `parent_panel_id` = the 0-based index of the section in the same panels
  array, as a string. The parent must be a top-level section (no `parent_panel_id`). Never nest a section in a
  section.
- Count indexes from 0. Re-check each child's index against the panels array before sending.
- Variables go in the first create call; `variableMappings` must use exact variable names. Guided variables auto-map; custom
  variables need explicit `variableMappings` on every UDE panel.
- `add_panels` cannot attach to an existing section by real ID. To add to an existing section: `add_panels` with no
  parent, then `update_panels` with `parent_panel_id` = real integer ID (from `describe_board`).
- After any `update_panels`, run `describe_board` and confirm variable mappings.
- If create fails, don't retry with different guesses. Fix the index list.

### Build incrementally

- Never send the whole dashboard in one call. First call: create with title, variables, ONE section and its children,
  including one panel per distinct measurement path in the dashboard. These are real content, not a test.
- Then add the remaining sections with one `add_panels` call per section (section first, then its children, indexes
  0-based within that call). Aim for about 8 panels or fewer per call.
- Keep configs minimal. Omit `sort`, `window`, `filters`, `limit`, `layout`, `chart` and `table` unless the user asked
  for them. Keep text panel markdown short.
- Before sending, check every metric and dimension in every panel against its own measurement's list. For any
  measurement not listed, call `ude_explore` with the exact path first.
- If a call fails with "Unsupported ..." or "Unknown measurement", fix EVERY panel on that measurement, not only the
  one reported. Only the first bad panel is reported. Resend only the failed batch.
- If `add_panels` fails, call `describe_board` before retrying to see what was created. Don't create a second board.
  If create fails with an error that isn't a validation error, tell the user and don't create another board.
