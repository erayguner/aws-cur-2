# Performance and Cost Correlation LookML Model
# Comprehensive model for performance optimization and APM dashboards

connection: "bigquery_production"
label: "Performance & Cost Analytics"

# Include all views
include: "/views/fact_performance_requests.view.lkml"
include: "/views/fact_performance_metrics_hourly.view.lkml"
include: "/views/fact_cost_hourly.view.lkml"
include: "/views/fact_performance_cost_joined.view.lkml"
include: "/views/dim_service.view.lkml"
include: "/views/dim_endpoint.view.lkml"
include: "/views/dim_region.view.lkml"
include: "/views/dim_time.view.lkml"
include: "/views/dim_user_segment.view.lkml"

# Datagroups for caching
datagroup: realtime_refresh {
  label: "Real-time (1 minute)"
  sql_trigger: SELECT FLOOR(UNIX_SECONDS(CURRENT_TIMESTAMP()) / 60) ;;
  max_cache_age: "1 minute"
}

datagroup: hourly_refresh {
  label: "Hourly refresh"
  sql_trigger: SELECT FLOOR(UNIX_SECONDS(CURRENT_TIMESTAMP()) / 3600) ;;
  max_cache_age: "1 hour"
}

datagroup: daily_refresh {
  label: "Daily refresh"
  sql_trigger: SELECT CURRENT_DATE() ;;
  max_cache_age: "24 hours"
}

# Explore: Real-Time Performance Monitoring
explore: performance_requests {
  label: "Real-Time Performance Monitoring"
  description: "Request-level performance data for real-time monitoring and detailed analysis"
  
  from: fact_performance_requests
  
  # Join service dimension
  join: service {
    type: left_outer
    sql_on: ${performance_requests.service_key} = ${service.service_key} ;;
    relationship: many_to_one
  }
  
  # Join endpoint dimension
  join: endpoint {
    type: left_outer
    sql_on: ${performance_requests.endpoint_key} = ${endpoint.endpoint_key} ;;
    relationship: many_to_one
  }
  
  # Join region dimension
  join: region {
    type: left_outer
    sql_on: ${performance_requests.region_key} = ${region.region_key} ;;
    relationship: many_to_one
  }
  
  # Join user segment
  join: user_segment {
    type: left_outer
    sql_on: ${performance_requests.user_segment_key} = ${user_segment.user_segment_key} ;;
    relationship: many_to_one
  }
  
  # Aggregate awareness for performance
  aggregate_table: hourly_rollup {
    query: {
      dimensions: [
        service.service_name,
        endpoint.endpoint_path,
        performance_requests.hour
      ]
      measures: [
        performance_requests.request_count,
        performance_requests.error_count,
        performance_requests.p95_latency,
        performance_requests.p99_latency
      ]
      filters: [
        performance_requests.timestamp_date: "7 days"
      ]
    }
    materialization: {
      datagroup_trigger: hourly_refresh
    }
  }
  
  # Use daily rollup for longer time ranges
  aggregate_table: daily_rollup {
    query: {
      dimensions: [
        service.service_name,
        performance_requests.timestamp_date
      ]
      measures: [
        performance_requests.request_count,
        performance_requests.p95_latency
      ]
      filters: [
        performance_requests.timestamp_date: "90 days"
      ]
    }
    materialization: {
      datagroup_trigger: daily_refresh
    }
  }
}

# Explore: Performance Metrics (Pre-Aggregated)
explore: performance_metrics {
  label: "Performance Metrics (Hourly)"
  description: "Pre-aggregated hourly performance metrics for fast dashboard queries"
  
  from: fact_performance_metrics_hourly
  
  join: service {
    type: left_outer
    sql_on: ${performance_metrics.service_key} = ${service.service_key} ;;
    relationship: many_to_one
  }
  
  join: endpoint {
    type: left_outer
    sql_on: ${performance_metrics.endpoint_key} = ${endpoint.endpoint_key} ;;
    relationship: many_to_one
  }
  
  join: region {
    type: left_outer
    sql_on: ${performance_metrics.region_key} = ${region.region_key} ;;
    relationship: many_to_one
  }
}

# Explore: Cost Analysis
explore: cost_metrics {
  label: "Cost Analysis"
  description: "Infrastructure cost data with service attribution"
  
  from: fact_cost_hourly
  
  join: service {
    type: left_outer
    sql_on: ${cost_metrics.service_key} = ${service.service_key} ;;
    relationship: many_to_one
  }
  
  join: region {
    type: left_outer
    sql_on: ${cost_metrics.region_key} = ${region.region_key} ;;
    relationship: many_to_one
  }
}

# Explore: Performance-Cost Correlation (PRIMARY)
explore: performance_cost {
  label: "Performance & Cost Correlation"
  description: "Unified view of performance metrics and infrastructure costs for optimization analysis"
  
  from: fact_performance_cost_joined
  
  # Service dimension
  join: service {
    type: left_outer
    sql_on: ${performance_cost.service_key} = ${service.service_key} ;;
    relationship: many_to_one
  }
  
  # Endpoint dimension
  join: endpoint {
    type: left_outer
    sql_on: ${performance_cost.endpoint_key} = ${endpoint.endpoint_key} ;;
    relationship: many_to_one
  }
  
  # Region dimension
  join: region {
    type: left_outer
    sql_on: ${performance_cost.region_key} = ${region.region_key} ;;
    relationship: many_to_one
  }
  
  # Time dimension for advanced time analysis
  join: time_dimension {
    type: left_outer
    sql_on: ${performance_cost.hour} = ${time_dimension.timestamp} ;;
    relationship: many_to_one
    from: dim_time
  }
  
  # Always filter to recent data by default
  sql_always_where: ${performance_cost.date} >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY) ;;
  
  # Conditionally join cost data (can analyze performance without cost)
  always_join: [service, region]
}

# Explore: Service-Level Performance Dashboard
explore: service_performance {
  label: "Service Performance Dashboard"
  description: "Service-centric view for engineering teams"
  
  from: fact_performance_metrics_hourly
  view_name: performance_metrics
  
  fields: [ALL_FIELDS*]
  
  join: service {
    type: left_outer
    sql_on: ${performance_metrics.service_key} = ${service.service_key} ;;
    relationship: many_to_one
  }
  
  join: endpoint {
    type: left_outer
    sql_on: ${performance_metrics.endpoint_key} = ${endpoint.endpoint_key} ;;
    relationship: many_to_one
  }
  
  join: region {
    type: left_outer
    sql_on: ${performance_metrics.region_key} = ${region.region_key} ;;
    relationship: many_to_one
  }
  
  # Join cost data for cost-per-request analysis
  join: cost_metrics {
    type: left_outer
    sql_on: ${performance_metrics.hour} = ${cost_metrics.hour}
        AND ${performance_metrics.service_key} = ${cost_metrics.service_key}
        AND ${performance_metrics.region_key} = ${cost_metrics.region_key} ;;
    relationship: one_to_one
    from: fact_cost_hourly
  }
}
