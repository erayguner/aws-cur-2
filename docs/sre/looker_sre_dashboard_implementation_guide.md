# Looker SRE Dashboard Implementation Guide

**Version:** 1.0  
**Created:** 2025-11-17  
**Target Platform:** Looker / LookML  
**Integration:** AWS CUR 2.0 + CloudWatch + Prometheus/Datadog

---

## Overview

This guide provides practical LookML patterns and dashboard specifications for implementing the Reliability Engineering & SRE Dashboard framework using Looker, integrating AWS Cost and Usage Report (CUR) data with operational metrics from CloudWatch, Prometheus, or other monitoring platforms.

---

## Architecture

### Data Sources

1. **AWS CUR 2.0** (existing):
   - Infrastructure costs
   - Service usage metrics
   - Resource tagging data
   - Location: `/home/user/aws-cur-2/cur2.view.lkml`

2. **CloudWatch Metrics** (to be added):
   - Golden Signals (latency, errors, etc.)
   - Lambda invocations and errors
   - RDS performance metrics
   - ALB/NLB request metrics

3. **Prometheus/Datadog** (external):
   - Application-level metrics
   - Custom SLI metrics
   - Distributed tracing data (via API)

4. **Incident Management** (PagerDuty/Opsgenie API):
   - Incident history
   - MTTD/MTTR data
   - On-call schedule

5. **Deployment Pipeline** (CI/CD integration):
   - Deployment frequency
   - Success/failure rates
   - Rollback events

### Integration Patterns

```
┌─────────────────┐
│   Looker PDT    │ ← Query CloudWatch via Athena
│  (CloudWatch)   │
└─────────────────┘
        ↓
┌─────────────────┐
│  SRE Metrics    │ ← Join with CUR data
│  Combined View  │
└─────────────────┘
        ↓
┌─────────────────┐
│ SRE Dashboards  │
└─────────────────┘
```

---

## LookML View: SRE Metrics

### File: `sre_metrics.view.lkml`

```lkml
view: sre_metrics {
  sql_table_name: sre_monitoring.metrics ;;
  
  ## PRIMARY KEY
  
  dimension: metric_id {
    primary_key: yes
    type: string
    sql: CONCAT(${service_name}, '-', ${timestamp_raw}) ;;
  }
  
  ## DIMENSIONS
  
  dimension: service_name {
    type: string
    sql: ${TABLE}.service_name ;;
    description: "Name of the service being monitored"
  }
  
  dimension: service_tier {
    type: string
    sql: ${TABLE}.service_tier ;;
    description: "Service criticality tier (0=Critical, 1=High, 2=Medium, 3=Low)"
    
    case: {
      when: {
        sql: ${TABLE}.service_tier = '0' ;;
        label: "Tier 0 - Critical"
      }
      when: {
        sql: ${TABLE}.service_tier = '1' ;;
        label: "Tier 1 - High"
      }
      when: {
        sql: ${TABLE}.service_tier = '2' ;;
        label: "Tier 2 - Medium"
      }
      when: {
        sql: ${TABLE}.service_tier = '3' ;;
        label: "Tier 3 - Low"
      }
      else: "Unknown"
    }
  }
  
  dimension: environment {
    type: string
    sql: ${TABLE}.environment ;;
    description: "Environment (production, staging, development)"
  }
  
  dimension: region {
    type: string
    sql: ${TABLE}.aws_region ;;
    description: "AWS Region"
  }
  
  ## TIME DIMENSIONS
  
  dimension_group: timestamp {
    type: time
    timeframes: [
      raw,
      time,
      minute,
      minute5,
      minute15,
      hour,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.timestamp ;;
    description: "Timestamp of the metric observation"
  }
  
  ## GOLDEN SIGNALS: LATENCY
  
  dimension: latency_p50_ms {
    type: number
    sql: ${TABLE}.latency_p50 ;;
    description: "P50 latency in milliseconds"
    value_format_name: decimal_2
  }
  
  dimension: latency_p95_ms {
    type: number
    sql: ${TABLE}.latency_p95 ;;
    description: "P95 latency in milliseconds"
    value_format_name: decimal_2
  }
  
  dimension: latency_p99_ms {
    type: number
    sql: ${TABLE}.latency_p99 ;;
    description: "P99 latency in milliseconds"
    value_format_name: decimal_2
  }
  
  dimension: latency_p999_ms {
    type: number
    sql: ${TABLE}.latency_p999 ;;
    description: "P99.9 latency in milliseconds"
    value_format_name: decimal_2
  }
  
  ## GOLDEN SIGNALS: TRAFFIC
  
  dimension: requests_per_second {
    type: number
    sql: ${TABLE}.requests_per_second ;;
    description: "Requests per second"
    value_format_name: decimal_2
  }
  
  dimension: throughput_bytes_per_second {
    type: number
    sql: ${TABLE}.throughput_bytes_per_second ;;
    description: "Throughput in bytes per second"
    value_format_name: decimal_0
  }
  
  ## GOLDEN SIGNALS: ERRORS
  
  dimension: total_requests {
    type: number
    sql: ${TABLE}.total_requests ;;
    description: "Total number of requests"
  }
  
  dimension: error_requests {
    type: number
    sql: ${TABLE}.error_requests ;;
    description: "Number of error requests (4xx + 5xx)"
  }
  
  dimension: error_4xx {
    type: number
    sql: ${TABLE}.error_4xx ;;
    description: "Number of 4xx errors (client errors)"
  }
  
  dimension: error_5xx {
    type: number
    sql: ${TABLE}.error_5xx ;;
    description: "Number of 5xx errors (server errors)"
  }
  
  ## GOLDEN SIGNALS: SATURATION
  
  dimension: cpu_utilization_percent {
    type: number
    sql: ${TABLE}.cpu_utilization ;;
    description: "CPU utilization percentage"
    value_format_name: percent_2
  }
  
  dimension: memory_utilization_percent {
    type: number
    sql: ${TABLE}.memory_utilization ;;
    description: "Memory utilization percentage"
    value_format_name: percent_2
  }
  
  dimension: disk_utilization_percent {
    type: number
    sql: ${TABLE}.disk_utilization ;;
    description: "Disk utilization percentage"
    value_format_name: percent_2
  }
  
  dimension: network_utilization_percent {
    type: number
    sql: ${TABLE}.network_utilization ;;
    description: "Network utilization percentage"
    value_format_name: percent_2
  }
  
  ## SLO DIMENSIONS
  
  dimension: slo_availability_target {
    type: number
    sql: ${TABLE}.slo_availability_target ;;
    description: "Availability SLO target (e.g., 0.999 for 99.9%)"
    value_format_name: percent_3
  }
  
  dimension: slo_latency_p95_target_ms {
    type: number
    sql: ${TABLE}.slo_latency_p95_target ;;
    description: "P95 latency SLO target in milliseconds"
    value_format_name: decimal_0
  }
  
  ## MEASURES
  
  measure: count {
    type: count
    drill_fields: [service_name, timestamp_time]
  }
  
  ## LATENCY MEASURES
  
  measure: avg_latency_p50 {
    type: average
    sql: ${latency_p50_ms} ;;
    description: "Average P50 latency"
    value_format_name: decimal_2
  }
  
  measure: avg_latency_p95 {
    type: average
    sql: ${latency_p95_ms} ;;
    description: "Average P95 latency"
    value_format_name: decimal_2
  }
  
  measure: avg_latency_p99 {
    type: average
    sql: ${latency_p99_ms} ;;
    description: "Average P99 latency"
    value_format_name: decimal_2
  }
  
  measure: max_latency_p99 {
    type: max
    sql: ${latency_p99_ms} ;;
    description: "Maximum P99 latency observed"
    value_format_name: decimal_2
  }
  
  ## TRAFFIC MEASURES
  
  measure: avg_requests_per_second {
    type: average
    sql: ${requests_per_second} ;;
    description: "Average requests per second"
    value_format_name: decimal_2
  }
  
  measure: total_requests_sum {
    type: sum
    sql: ${total_requests} ;;
    description: "Total requests across time period"
    value_format_name: decimal_0
  }
  
  measure: avg_throughput_mbps {
    type: average
    sql: ${throughput_bytes_per_second} / 1048576.0 ;;
    description: "Average throughput in MB/s"
    value_format_name: decimal_2
  }
  
  ## ERROR MEASURES
  
  measure: total_errors {
    type: sum
    sql: ${error_requests} ;;
    description: "Total error requests"
    value_format_name: decimal_0
  }
  
  measure: error_rate {
    type: number
    sql: SAFE_DIVIDE(${total_errors}, ${total_requests_sum}) ;;
    description: "Error rate (errors / total requests)"
    value_format_name: percent_3
  }
  
  measure: availability_rate {
    type: number
    sql: 1.0 - SAFE_DIVIDE(${total_errors}, ${total_requests_sum}) ;;
    description: "Availability rate (1 - error rate)"
    value_format_name: percent_3
  }
  
  ## SATURATION MEASURES
  
  measure: avg_cpu_utilization {
    type: average
    sql: ${cpu_utilization_percent} ;;
    description: "Average CPU utilization"
    value_format_name: percent_2
  }
  
  measure: max_cpu_utilization {
    type: max
    sql: ${cpu_utilization_percent} ;;
    description: "Maximum CPU utilization"
    value_format_name: percent_2
  }
  
  measure: avg_memory_utilization {
    type: average
    sql: ${memory_utilization_percent} ;;
    description: "Average memory utilization"
    value_format_name: percent_2
  }
  
  measure: max_memory_utilization {
    type: max
    sql: ${memory_utilization_percent} ;;
    description: "Maximum memory utilization"
    value_format_name: percent_2
  }
  
  ## SLO COMPLIANCE MEASURES
  
  measure: slo_availability_gap {
    type: number
    sql: ${availability_rate} - ${slo_availability_target} ;;
    description: "Gap between actual availability and SLO target (positive = exceeding SLO)"
    value_format_name: percent_3
  }
  
  measure: slo_latency_gap {
    type: number
    sql: ${avg_latency_p95} - ${slo_latency_p95_target_ms} ;;
    description: "Gap between actual P95 latency and SLO target (negative = meeting SLO)"
    value_format_name: decimal_2
  }
  
  measure: slo_compliance_status {
    type: string
    sql: CASE
      WHEN ${availability_rate} >= ${slo_availability_target}
        AND ${avg_latency_p95} <= ${slo_latency_p95_target_ms}
      THEN '🟢 Meeting SLO'
      WHEN ${availability_rate} >= (${slo_availability_target} - 0.001)
        OR ${avg_latency_p95} <= (${slo_latency_p95_target_ms} * 1.1)
      THEN '🟡 At Risk'
      ELSE '🔴 Breaching SLO'
    END ;;
    description: "SLO compliance status indicator"
  }
  
  ## ERROR BUDGET MEASURES
  
  measure: error_budget_remaining {
    type: number
    sql: (1.0 - ${slo_availability_target}) - (1.0 - ${availability_rate}) ;;
    description: "Error budget remaining (positive = budget left)"
    value_format_name: percent_4
  }
  
  measure: error_budget_consumed_percent {
    type: number
    sql: SAFE_DIVIDE(
      (1.0 - ${availability_rate}),
      (1.0 - ${slo_availability_target})
    ) ;;
    description: "Percentage of error budget consumed"
    value_format_name: percent_2
  }
}
```

---

## LookML View: Incident Metrics

### File: `incidents.view.lkml`

```lkml
view: incidents {
  sql_table_name: sre_monitoring.incidents ;;
  
  ## PRIMARY KEY
  
  dimension: incident_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.incident_id ;;
    description: "Unique incident identifier"
  }
  
  ## DIMENSIONS
  
  dimension: severity {
    type: string
    sql: ${TABLE}.severity ;;
    description: "Incident severity (P0, P1, P2, P3, P4)"
    
    case: {
      when: {
        sql: ${TABLE}.severity = 'P0' ;;
        label: "P0 - Critical"
      }
      when: {
        sql: ${TABLE}.severity = 'P1' ;;
        label: "P1 - High"
      }
      when: {
        sql: ${TABLE}.severity = 'P2' ;;
        label: "P2 - Medium"
      }
      when: {
        sql: ${TABLE}.severity = 'P3' ;;
        label: "P3 - Low"
      }
      when: {
        sql: ${TABLE}.severity = 'P4' ;;
        label: "P4 - Informational"
      }
      else: "Unknown"
    }
  }
  
  dimension: service_name {
    type: string
    sql: ${TABLE}.service_name ;;
    description: "Affected service"
  }
  
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    description: "Incident status"
    
    case: {
      when: {
        sql: ${TABLE}.status = 'investigating' ;;
        label: "Investigating"
      }
      when: {
        sql: ${TABLE}.status = 'identified' ;;
        label: "Identified"
      }
      when: {
        sql: ${TABLE}.status = 'monitoring' ;;
        label: "Monitoring"
      }
      when: {
        sql: ${TABLE}.status = 'resolved' ;;
        label: "Resolved"
      }
      else: "Unknown"
    }
  }
  
  dimension: root_cause_category {
    type: string
    sql: ${TABLE}.root_cause_category ;;
    description: "Root cause category"
    
    case: {
      when: {
        sql: ${TABLE}.root_cause_category = 'deployment' ;;
        label: "Deployment/Code Change"
      }
      when: {
        sql: ${TABLE}.root_cause_category = 'infrastructure' ;;
        label: "Infrastructure Failure"
      }
      when: {
        sql: ${TABLE}.root_cause_category = 'dependency' ;;
        label: "Dependency Failure"
      }
      when: {
        sql: ${TABLE}.root_cause_category = 'capacity' ;;
        label: "Capacity/Load"
      }
      when: {
        sql: ${TABLE}.root_cause_category = 'configuration' ;;
        label: "Configuration Change"
      }
      else: "Other/Unknown"
    }
  }
  
  ## TIME DIMENSIONS
  
  dimension_group: incident_start {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.incident_start_time ;;
    description: "When the incident actually started"
  }
  
  dimension_group: detected {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.detected_time ;;
    description: "When the incident was detected"
  }
  
  dimension_group: acknowledged {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.acknowledged_time ;;
    description: "When on-call engineer acknowledged"
  }
  
  dimension_group: resolved {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.resolved_time ;;
    description: "When the incident was resolved"
  }
  
  ## DURATION DIMENSIONS
  
  dimension: mttd_minutes {
    type: number
    sql: TIMESTAMP_DIFF(${detected_raw}, ${incident_start_raw}, MINUTE) ;;
    description: "Mean Time To Detect (minutes)"
    value_format_name: decimal_1
  }
  
  dimension: mtta_minutes {
    type: number
    sql: TIMESTAMP_DIFF(${acknowledged_raw}, ${detected_raw}, MINUTE) ;;
    description: "Mean Time To Acknowledge (minutes)"
    value_format_name: decimal_1
  }
  
  dimension: mttr_minutes {
    type: number
    sql: TIMESTAMP_DIFF(${resolved_raw}, ${detected_raw}, MINUTE) ;;
    description: "Mean Time To Resolve (minutes)"
    value_format_name: decimal_1
  }
  
  dimension: total_duration_minutes {
    type: number
    sql: TIMESTAMP_DIFF(${resolved_raw}, ${incident_start_raw}, MINUTE) ;;
    description: "Total incident duration (minutes)"
    value_format_name: decimal_1
  }
  
  ## IMPACT DIMENSIONS
  
  dimension: customer_impacting {
    type: yesno
    sql: ${TABLE}.customer_impacting ;;
    description: "Did this incident impact customers?"
  }
  
  dimension: users_affected {
    type: number
    sql: ${TABLE}.users_affected ;;
    description: "Number of users affected"
  }
  
  dimension: error_budget_consumed_percent {
    type: number
    sql: ${TABLE}.error_budget_consumed ;;
    description: "Error budget consumed by this incident"
    value_format_name: percent_3
  }
  
  ## POSTMORTEM DIMENSIONS
  
  dimension: postmortem_completed {
    type: yesno
    sql: ${TABLE}.postmortem_completed ;;
    description: "Has postmortem been completed?"
  }
  
  dimension: action_items_count {
    type: number
    sql: ${TABLE}.action_items_count ;;
    description: "Number of action items from postmortem"
  }
  
  dimension: action_items_completed {
    type: number
    sql: ${TABLE}.action_items_completed ;;
    description: "Number of completed action items"
  }
  
  ## MEASURES
  
  measure: total_incidents {
    type: count
    description: "Total number of incidents"
  }
  
  measure: critical_incidents {
    type: count
    filters: [severity: "P0"]
    description: "Count of P0 (critical) incidents"
  }
  
  measure: high_severity_incidents {
    type: count
    filters: [severity: "P0,P1"]
    description: "Count of P0 and P1 incidents"
  }
  
  measure: customer_impacting_incidents {
    type: count
    filters: [customer_impacting: "yes"]
    description: "Count of customer-impacting incidents"
  }
  
  ## MTTD/MTTA/MTTR MEASURES
  
  measure: avg_mttd {
    type: average
    sql: ${mttd_minutes} ;;
    description: "Average Mean Time To Detect"
    value_format_name: decimal_1
  }
  
  measure: avg_mtta {
    type: average
    sql: ${mtta_minutes} ;;
    description: "Average Mean Time To Acknowledge"
    value_format_name: decimal_1
  }
  
  measure: avg_mttr {
    type: average
    sql: ${mttr_minutes} ;;
    description: "Average Mean Time To Resolve"
    value_format_name: decimal_1
  }
  
  measure: p50_mttr {
    type: percentile
    percentile: 50
    sql: ${mttr_minutes} ;;
    description: "P50 (median) MTTR"
  }
  
  measure: p95_mttr {
    type: percentile
    percentile: 95
    sql: ${mttr_minutes} ;;
    description: "P95 MTTR"
  }
  
  measure: max_mttr {
    type: max
    sql: ${mttr_minutes} ;;
    description: "Maximum MTTR"
  }
  
  ## TOTAL DOWNTIME
  
  measure: total_downtime_minutes {
    type: sum
    sql: ${total_duration_minutes} ;;
    description: "Total downtime in minutes"
    value_format_name: decimal_0
  }
  
  measure: total_downtime_hours {
    type: number
    sql: ${total_downtime_minutes} / 60.0 ;;
    description: "Total downtime in hours"
    value_format_name: decimal_2
  }
  
  ## ERROR BUDGET IMPACT
  
  measure: total_error_budget_consumed {
    type: sum
    sql: ${error_budget_consumed_percent} ;;
    description: "Total error budget consumed by incidents"
    value_format_name: percent_2
  }
  
  ## POSTMORTEM METRICS
  
  measure: postmortem_completion_rate {
    type: number
    sql: SAFE_DIVIDE(
      ${incidents_with_postmortem},
      ${total_incidents}
    ) ;;
    description: "Percentage of incidents with completed postmortems"
    value_format_name: percent_1
  }
  
  measure: incidents_with_postmortem {
    type: count
    filters: [postmortem_completed: "yes"]
    description: "Incidents with completed postmortems"
  }
  
  measure: avg_action_items_per_incident {
    type: average
    sql: ${action_items_count} ;;
    description: "Average action items per incident"
    value_format_name: decimal_1
  }
  
  measure: action_item_completion_rate {
    type: number
    sql: SAFE_DIVIDE(
      SUM(${action_items_completed}),
      SUM(${action_items_count})
    ) ;;
    description: "Percentage of action items completed"
    value_format_name: percent_1
  }
}
```

---

## Sample Dashboard: Golden Signals

### File: `golden_signals.dashboard.lookml`

```lkml
- dashboard: golden_signals_service_health
  title: "Golden Signals: Service Health at a Glance"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Monitor latency, traffic, errors, and saturation per Google SRE best practices"
  
  elements:
  
  ## SUMMARY TILES
  
  - name: total_services
    title: "Total Services"
    model: sre_monitoring
    explore: sre_metrics
    type: single_value
    fields: [sre_metrics.service_name, sre_metrics.count]
    filters:
      sre_metrics.timestamp_date: 1 days
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    value_format: "#,##0"
    font_size: medium
    text_color: "#3A4245"
    row: 0
    col: 0
    width: 4
    height: 2
    
  - name: services_meeting_slo
    title: "Services Meeting SLO"
    model: sre_monitoring
    explore: sre_metrics
    type: single_value
    fields: [sre_metrics.service_name, sre_metrics.availability_rate, sre_metrics.slo_availability_target]
    filters:
      sre_metrics.timestamp_date: 1 days
      sre_metrics.availability_rate: ">= sre_metrics.slo_availability_target"
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: progress_percentage
    comparison_reverse_colors: false
    value_format: "#,##0"
    font_size: medium
    row: 0
    col: 4
    width: 4
    height: 2
    
  - name: avg_error_rate
    title: "Avg Error Rate (24h)"
    model: sre_monitoring
    explore: sre_metrics
    type: single_value
    fields: [sre_metrics.error_rate]
    filters:
      sre_metrics.timestamp_date: 1 days
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    value_format: "0.000%"
    font_size: medium
    custom_color: "#E52592"
    row: 0
    col: 8
    width: 4
    height: 2
    
  - name: avg_p95_latency
    title: "Avg P95 Latency (24h)"
    model: sre_monitoring
    explore: sre_metrics
    type: single_value
    fields: [sre_metrics.avg_latency_p95]
    filters:
      sre_metrics.timestamp_date: 1 days
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    value_format: "#,##0.00\" ms\""
    font_size: medium
    row: 0
    col: 12
    width: 4
    height: 2
    
  ## GOLDEN SIGNALS TABLE
  
  - name: golden_signals_by_service
    title: "Golden Signals by Service (Last 24 Hours)"
    model: sre_monitoring
    explore: sre_metrics
    type: looker_grid
    fields: [
      sre_metrics.service_name,
      sre_metrics.service_tier,
      sre_metrics.avg_latency_p95,
      sre_metrics.avg_requests_per_second,
      sre_metrics.error_rate,
      sre_metrics.avg_cpu_utilization,
      sre_metrics.avg_memory_utilization,
      sre_metrics.slo_compliance_status
    ]
    filters:
      sre_metrics.timestamp_date: 1 days
    sorts: [sre_metrics.error_rate desc]
    limit: 500
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    series_labels:
      sre_metrics.service_name: "Service"
      sre_metrics.service_tier: "Tier"
      sre_metrics.avg_latency_p95: "P95 Latency (ms)"
      sre_metrics.avg_requests_per_second: "RPS"
      sre_metrics.error_rate: "Error Rate"
      sre_metrics.avg_cpu_utilization: "CPU %"
      sre_metrics.avg_memory_utilization: "Memory %"
      sre_metrics.slo_compliance_status: "SLO Status"
    table_theme: gray
    limit_displayed_rows: false
    enable_conditional_formatting: true
    conditional_formatting: [
      {
        type: along a scale...
        value:
        background_color:
        font_color:
        color_application:
          collection_id: legacy
          palette_id: legacy_diverging1
        bold: false
        italic: false
        strikethrough: false
        fields: [sre_metrics.error_rate]
      },
      {
        type: along a scale...
        value:
        background_color:
        font_color:
        color_application:
          collection_id: legacy
          palette_id: legacy_sequential3
        bold: false
        italic: false
        strikethrough: false
        fields: [sre_metrics.avg_cpu_utilization, sre_metrics.avg_memory_utilization]
      }
    ]
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    row: 2
    col: 0
    width: 24
    height: 8
    
  ## LATENCY TREND
  
  - name: latency_trend
    title: "P95 Latency Trend (7 Days)"
    model: sre_monitoring
    explore: sre_metrics
    type: looker_line
    fields: [sre_metrics.timestamp_date, sre_metrics.service_name, sre_metrics.avg_latency_p95]
    pivots: [sre_metrics.service_name]
    fill_fields: [sre_metrics.timestamp_date]
    filters:
      sre_metrics.timestamp_date: 7 days
      sre_metrics.service_tier: "Tier 0 - Critical,Tier 1 - High"
    sorts: [sre_metrics.timestamp_date desc, sre_metrics.service_name]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical1
    series_types: {}
    row: 10
    col: 0
    width: 12
    height: 6
    
  ## ERROR RATE TREND
  
  - name: error_rate_trend
    title: "Error Rate Trend (7 Days)"
    model: sre_monitoring
    explore: sre_metrics
    type: looker_line
    fields: [sre_metrics.timestamp_date, sre_metrics.service_name, sre_metrics.error_rate]
    pivots: [sre_metrics.service_name]
    fill_fields: [sre_metrics.timestamp_date]
    filters:
      sre_metrics.timestamp_date: 7 days
      sre_metrics.service_tier: "Tier 0 - Critical,Tier 1 - High"
    sorts: [sre_metrics.timestamp_date desc, sre_metrics.service_name]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: Error Rate, orientation: left, series: [{axisId: sre_metrics.error_rate,
            id: sre_metrics.error_rate, name: Error Rate}], showLabels: true, showValues: true,
        valueFormat: 0.00%, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    color_application:
      collection_id: legacy
      palette_id: legacy_categorical1
    series_types: {}
    row: 10
    col: 12
    width: 12
    height: 6
```

---

## Implementation Checklist

### Phase 1: Data Integration (Weeks 1-2)
- [ ] Set up CloudWatch data export to S3
- [ ] Configure Athena to query CloudWatch metrics
- [ ] Create PDT in Looker for CloudWatch data
- [ ] Integrate PagerDuty API for incident data
- [ ] Join SRE metrics with CUR data (cost attribution)

### Phase 2: Core Views (Weeks 3-4)
- [ ] Create `sre_metrics.view.lkml` (Golden Signals)
- [ ] Create `incidents.view.lkml` (MTTD/MTTR)
- [ ] Create `deployments.view.lkml` (DORA metrics)
- [ ] Create `slo_tracking.view.lkml` (SLO/Error Budget)
- [ ] Test all measures and dimensions

### Phase 3: Dashboards (Weeks 5-6)
- [ ] Build Golden Signals dashboard
- [ ] Build Incident Management dashboard
- [ ] Build SLO/Error Budget dashboard
- [ ] Build DORA Metrics dashboard
- [ ] Build On-Call Health dashboard

### Phase 4: Alerts & Automation (Weeks 7-8)
- [ ] Configure Looker alerts for SLO breaches
- [ ] Set up error budget depletion alerts
- [ ] Create scheduled PDF reports for executives
- [ ] Integrate with Slack for real-time alerts
- [ ] Document all dashboards and views

---

## Next Steps

1. **Review** this implementation guide with SRE and platform teams
2. **Prioritize** data sources (start with CloudWatch + PagerDuty)
3. **Pilot** with 2-3 critical services
4. **Iterate** based on team feedback
5. **Scale** to all services

---

## Support & Resources

- **LookML Docs**: https://docs.looker.com/
- **Google SRE Book**: https://sre.google/sre-book/table-of-contents/
- **DORA Metrics**: https://dora.dev/
- **OpenTelemetry**: https://opentelemetry.io/

---

**END OF DOCUMENT**
