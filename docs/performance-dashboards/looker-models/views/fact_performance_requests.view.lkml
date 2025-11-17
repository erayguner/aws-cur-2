# Fact View: Performance Requests
# Request-level performance data from OpenTelemetry traces

view: fact_performance_requests {
  sql_table_name: `project.performance.fact_performance_requests` ;;
  
  dimension: trace_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.trace_id ;;
    label: "Trace ID"
  }
  
  dimension_group: timestamp {
    type: time
    timeframes: [raw, time, minute, hour, date, week, month]
    sql: ${TABLE}.timestamp ;;
  }
  
  dimension: duration_ms {
    type: number
    sql: ${TABLE}.duration_ms ;;
    label: "Duration (ms)"
  }
  
  dimension: is_error {
    type: yesno
    sql: ${TABLE}.is_error ;;
  }
  
  measure: request_count {
    type: count
    label: "Request Count"
  }
  
  measure: p95_latency {
    type: percentile
    percentile: 95
    sql: ${duration_ms} ;;
    label: "P95 Latency (ms)"
  }
  
  measure: error_rate {
    type: number
    sql: 1.0 * COUNT(CASE WHEN ${is_error} THEN 1 END) / NULLIF(COUNT(*), 0) ;;
    value_format_name: percent_2
  }
}
