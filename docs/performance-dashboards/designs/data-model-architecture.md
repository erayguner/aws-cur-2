# Performance Data Model Architecture (2025-2035)

## Executive Summary
A robust data model is the foundation of effective performance and cost correlation dashboards. This architecture defines dimensional modeling, aggregation strategies, and data pipeline design for the next decade.

## 1. Data Architecture Overview

### 1.1 Architectural Layers

```
┌─────────────────────────────────────────────┐
│ Presentation Layer (Looker Dashboards)     │
├─────────────────────────────────────────────┤
│ Semantic Layer (LookML Models)             │
├─────────────────────────────────────────────┤
│ Aggregation Layer (Materialized Views)     │
├─────────────────────────────────────────────┤
│ Integration Layer (ETL/ELT Pipelines)      │
├─────────────────────────────────────────────┤
│ Data Warehouse (BigQuery/Snowflake)        │
├─────────────────────────────────────────────┤
│ Raw Data Layer (S3/GCS Data Lake)          │
├─────────────────────────────────────────────┤
│ Data Sources (CloudWatch, APM, CUR, Logs)  │
└─────────────────────────────────────────────┘
```

### 1.2 Data Flow

```
Performance Data Sources:
- OpenTelemetry Traces → Trace Collector → BigQuery
- CloudWatch Metrics → Firehose → S3 → BigQuery
- Application Logs → Fluentd → BigQuery
- RUM Data → Analytics SDK → BigQuery

Cost Data Sources:
- AWS CUR → S3 → Athena → BigQuery
- Azure Cost → API → BigQuery
- GCP Billing → BigQuery (native export)

Unified Model:
- Join performance + cost data by time, service, tags
- Aggregate into hourly/daily rollups
- Expose via Looker semantic layer
```

## 2. Dimensional Model Design

### 2.1 Star Schema Architecture

**Fact Tables:**
- `fact_performance_requests` - Request-level performance data
- `fact_performance_metrics_hourly` - Hourly aggregated metrics
- `fact_cost_hourly` - Hourly cost data
- `fact_performance_cost_joined` - Combined performance + cost

**Dimension Tables:**
- `dim_service` - Service metadata
- `dim_endpoint` - API endpoint information
- `dim_region` - Geographic regions
- `dim_environment` - Environment (prod, staging, dev)
- `dim_time` - Time dimension (date, hour, day_of_week)
- `dim_user_segment` - User cohorts (free, premium, enterprise)
- `dim_resource` - Infrastructure resources (EC2, Lambda, RDS)

**Bridge Tables:**
- `bridge_service_resource` - Many-to-many service ↔ resource
- `bridge_trace_cost` - Trace ↔ cost allocation

### 2.2 Fact Table: Performance Requests

```sql
CREATE TABLE fact_performance_requests (
  -- Identifiers
  trace_id STRING NOT NULL,
  span_id STRING NOT NULL,
  parent_span_id STRING,
  
  -- Time
  timestamp TIMESTAMP NOT NULL,
  hour TIMESTAMP NOT NULL,  -- Truncated to hour for joins
  date DATE NOT NULL,
  
  -- Dimensions (foreign keys)
  service_key INT64,
  endpoint_key INT64,
  region_key INT64,
  environment_key INT64,
  user_segment_key INT64,
  
  -- Performance Metrics
  duration_ms FLOAT64,
  http_status_code INT64,
  is_error BOOLEAN,
  
  -- Request Context
  request_size_bytes INT64,
  response_size_bytes INT64,
  user_id STRING,
  session_id STRING,
  
  -- Technical Details
  host_name STRING,
  container_id STRING,
  pod_name STRING,
  
  -- Attributes (JSON for flexibility)
  span_attributes JSON,
  resource_attributes JSON
)
PARTITION BY DATE(timestamp)
CLUSTER BY service_key, endpoint_key, hour;
```

**Partitioning Strategy:**
- **Partition by date:** Efficient time-range queries
- **Cluster by service, endpoint, hour:** Fast aggregation and filtering

**Retention:**
- Raw data: 90 days (detailed analysis)
- Aggregated hourly: 2 years (trend analysis)
- Aggregated daily: 10 years (long-term trends)

### 2.3 Fact Table: Performance Metrics Hourly

```sql
CREATE TABLE fact_performance_metrics_hourly (
  -- Time
  hour TIMESTAMP NOT NULL,
  date DATE NOT NULL,
  
  -- Dimensions
  service_key INT64,
  endpoint_key INT64,
  region_key INT64,
  environment_key INT64,
  
  -- Aggregated Performance Metrics
  request_count INT64,
  error_count INT64,
  error_rate FLOAT64,
  
  -- Latency Percentiles (pre-calculated)
  duration_p50_ms FLOAT64,
  duration_p75_ms FLOAT64,
  duration_p90_ms FLOAT64,
  duration_p95_ms FLOAT64,
  duration_p99_ms FLOAT64,
  duration_p999_ms FLOAT64,
  duration_avg_ms FLOAT64,
  duration_max_ms FLOAT64,
  
  -- Throughput
  requests_per_second FLOAT64,
  
  -- Data Transfer
  total_request_bytes INT64,
  total_response_bytes INT64,
  avg_request_bytes FLOAT64,
  avg_response_bytes FLOAT64,
  
  -- Metadata
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY date
CLUSTER BY service_key, endpoint_key;
```

**Materialization:**
- Incremental updates every 5 minutes
- Process only new data since last run
- Handle late-arriving data (up to 1 hour delay)

### 2.4 Fact Table: Cost Hourly

```sql
CREATE TABLE fact_cost_hourly (
  -- Time
  hour TIMESTAMP NOT NULL,
  date DATE NOT NULL,
  
  -- Dimensions
  service_key INT64,
  region_key INT64,
  environment_key INT64,
  resource_key INT64,
  
  -- Cost Metrics
  compute_cost FLOAT64,
  storage_cost FLOAT64,
  network_cost FLOAT64,
  database_cost FLOAT64,
  other_cost FLOAT64,
  total_cost FLOAT64,
  
  -- Usage Metrics
  compute_hours FLOAT64,
  storage_gb_hours FLOAT64,
  network_gb FLOAT64,
  
  -- Resource Details
  instance_count INT64,
  instance_type STRING,
  
  -- Metadata
  cost_source STRING,  -- 'aws_cur', 'azure_cost', 'gcp_billing'
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY date
CLUSTER BY service_key, resource_key;
```

### 2.5 Fact Table: Performance-Cost Joined

```sql
CREATE TABLE fact_performance_cost_joined (
  -- Time
  hour TIMESTAMP NOT NULL,
  date DATE NOT NULL,
  
  -- Dimensions
  service_key INT64,
  endpoint_key INT64,
  region_key INT64,
  environment_key INT64,
  
  -- Performance Metrics
  request_count INT64,
  error_count INT64,
  error_rate FLOAT64,
  duration_p95_ms FLOAT64,
  requests_per_second FLOAT64,
  
  -- Cost Metrics
  total_cost FLOAT64,
  compute_cost FLOAT64,
  network_cost FLOAT64,
  
  -- Derived Metrics
  cost_per_request FLOAT64,
  cost_per_successful_request FLOAT64,
  requests_per_dollar FLOAT64,
  
  -- Efficiency Score
  performance_efficiency_score FLOAT64,  -- (RPS / P95) / Cost
  
  -- Metadata
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY date
CLUSTER BY service_key;

-- Calculation logic
-- performance_efficiency_score = (requests_per_second / duration_p95_ms) / total_cost * 1000
```

**Update Frequency:**
- Real-time cost data not available (CUR lags by 24h)
- Join performance data (current hour) with cost data (24h ago)
- For real-time view, use estimated cost based on resource usage

## 3. Dimension Tables

### 3.1 Dimension: Service

```sql
CREATE TABLE dim_service (
  service_key INT64 NOT NULL,  -- Surrogate key
  service_name STRING NOT NULL,  -- Business key
  service_type STRING,  -- 'web', 'api', 'worker', 'batch'
  team_name STRING,
  team_contact STRING,
  cost_center STRING,
  business_unit STRING,
  
  -- Technical Details
  language STRING,  -- 'java', 'python', 'go'
  framework STRING,  -- 'spring-boot', 'django', 'gin'
  deployment_type STRING,  -- 'kubernetes', 'lambda', 'ec2'
  
  -- SLA
  sla_latency_p95_ms FLOAT64,
  sla_availability_percent FLOAT64,
  sla_error_rate_percent FLOAT64,
  
  -- Metadata
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  is_active BOOLEAN
)
CLUSTER BY service_name;
```

### 3.2 Dimension: Endpoint

```sql
CREATE TABLE dim_endpoint (
  endpoint_key INT64 NOT NULL,
  service_key INT64,  -- FK to dim_service
  
  endpoint_path STRING,  -- '/api/v1/users/{id}'
  endpoint_method STRING,  -- 'GET', 'POST', 'PUT', 'DELETE'
  endpoint_category STRING,  -- 'read', 'write', 'search'
  
  -- Business Context
  business_criticality STRING,  -- 'critical', 'high', 'medium', 'low'
  revenue_impacting BOOLEAN,
  
  -- Performance Expectations
  expected_latency_p95_ms FLOAT64,
  expected_traffic_rps FLOAT64,
  
  -- Metadata
  created_at TIMESTAMP,
  is_active BOOLEAN
);
```

### 3.3 Dimension: Region

```sql
CREATE TABLE dim_region (
  region_key INT64 NOT NULL,
  
  region_code STRING,  -- 'us-east-1', 'eu-west-1'
  region_name STRING,  -- 'US East (N. Virginia)'
  cloud_provider STRING,  -- 'aws', 'azure', 'gcp'
  
  -- Geography
  continent STRING,
  country STRING,
  city STRING,
  latitude FLOAT64,
  longitude FLOAT64,
  
  -- Compliance
  data_residency_compliant BOOLEAN,
  gdpr_compliant BOOLEAN,
  
  -- Cost
  region_cost_multiplier FLOAT64,  -- Relative cost (us-east-1 = 1.0)
  
  -- Metadata
  created_at TIMESTAMP
);
```

### 3.4 Dimension: Time

```sql
CREATE TABLE dim_time (
  time_key INT64 NOT NULL,  -- YYYYMMDDHH
  
  timestamp TIMESTAMP NOT NULL,
  date DATE NOT NULL,
  hour INT64,  -- 0-23
  day_of_week INT64,  -- 1=Monday, 7=Sunday
  day_of_month INT64,
  day_of_year INT64,
  week_of_year INT64,
  month INT64,
  quarter INT64,
  year INT64,
  
  -- Business Calendar
  is_weekend BOOLEAN,
  is_holiday BOOLEAN,
  holiday_name STRING,
  is_business_hours BOOLEAN,  -- 9am-5pm local time
  
  -- Time Buckets
  time_of_day STRING,  -- 'morning', 'afternoon', 'evening', 'night'
  shift STRING,  -- 'day', 'evening', 'night' (for on-call analysis)
  
  -- Metadata
  created_at TIMESTAMP
);
```

### 3.5 Dimension: User Segment

```sql
CREATE TABLE dim_user_segment (
  user_segment_key INT64 NOT NULL,
  
  segment_name STRING,  -- 'free', 'premium', 'enterprise'
  segment_tier INT64,  -- 1, 2, 3 (ordinal)
  
  -- SLA
  sla_latency_p95_ms FLOAT64,
  sla_support_response_hours INT64,
  
  -- Features
  features_enabled JSON,
  
  -- Metadata
  created_at TIMESTAMP
);
```

## 4. Aggregation Strategy

### 4.1 Pre-Aggregation Tables

**Hourly Rollups (fact_performance_metrics_hourly):**
- **Purpose:** Fast dashboard queries (avoid scanning billions of rows)
- **Granularity:** Hour, service, endpoint, region
- **Update:** Every 5 minutes (incremental)
- **Retention:** 2 years

**Daily Rollups:**
```sql
CREATE TABLE fact_performance_metrics_daily AS
SELECT
  DATE(hour) as date,
  service_key,
  endpoint_key,
  region_key,
  environment_key,
  
  SUM(request_count) as request_count,
  SUM(error_count) as error_count,
  SUM(error_count) / SUM(request_count) as error_rate,
  
  -- Percentiles: re-aggregate from hourly percentiles (approximate)
  APPROX_QUANTILES(duration_p95_ms, 100)[OFFSET(95)] as duration_p95_ms,
  
  AVG(requests_per_second) as avg_requests_per_second
FROM fact_performance_metrics_hourly
GROUP BY 1, 2, 3, 4, 5;
```

**Weekly/Monthly Rollups:**
- For long-term trend analysis
- Historical comparison (year-over-year)
- Capacity planning

### 4.2 Real-Time Aggregation

**Streaming Aggregation (for live dashboards):**
```sql
-- Materialize view updated every 1 minute
CREATE MATERIALIZED VIEW mv_performance_realtime AS
SELECT
  TIMESTAMP_TRUNC(timestamp, MINUTE) as minute,
  service_key,
  
  COUNT(*) as request_count,
  SUM(CASE WHEN is_error THEN 1 ELSE 0 END) as error_count,
  
  APPROX_QUANTILES(duration_ms, 100)[OFFSET(50)] as p50_ms,
  APPROX_QUANTILES(duration_ms, 100)[OFFSET(95)] as p95_ms,
  APPROX_QUANTILES(duration_ms, 100)[OFFSET(99)] as p99_ms
FROM fact_performance_requests
WHERE timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)
GROUP BY 1, 2;
```

### 4.3 Aggregate Awareness in Looker

**LookML Configuration:**
```lkml
explore: performance_requests {
  # Use pre-aggregated hourly table when possible
  aggregate_table: hourly_rollup {
    query: {
      dimensions: [service_name, endpoint_path, hour]
      measures: [request_count, p95_latency]
      timezone: "UTC"
    }
    materialization: {
      datagroup_trigger: hourly_refresh
    }
  }
  
  # Use daily rollup for longer time ranges
  aggregate_table: daily_rollup {
    query: {
      dimensions: [service_name, date]
      measures: [request_count, p95_latency]
      filters: [
        fact_performance_requests.date: "7 days ago for 90 days"
      ]
    }
    materialization: {
      datagroup_trigger: daily_refresh
    }
  }
}
```

## 5. Cost Attribution Model

### 5.1 Tag-Based Attribution

**Tagging Strategy:**
```
Resource Tags (all cloud resources):
- service: "api-gateway", "user-service", "payment-service"
- environment: "production", "staging", "development"
- team: "platform", "growth", "data"
- cost_center: "engineering", "sales", "marketing"
```

**Direct Attribution:**
```sql
-- AWS CUR data with tags
SELECT
  line_item_usage_start_date,
  resource_tags_user_service as service,
  SUM(line_item_unblended_cost) as cost
FROM aws_cur
WHERE resource_tags_user_service IS NOT NULL
GROUP BY 1, 2;
```

### 5.2 Proportional Attribution

**Shared Resources:**
- VPC, NAT Gateway, Load Balancer costs shared across services
- Allocate proportionally based on usage (request count, data transfer)

```sql
-- Proportional allocation of NAT Gateway cost
WITH nat_cost AS (
  SELECT
    DATE(line_item_usage_start_date) as date,
    SUM(line_item_unblended_cost) as total_nat_cost
  FROM aws_cur
  WHERE line_item_product_code = 'AmazonEC2'
    AND line_item_usage_type LIKE '%NatGateway%'
  GROUP BY 1
),
service_traffic AS (
  SELECT
    date,
    service_key,
    SUM(total_response_bytes) as bytes_transferred
  FROM fact_performance_metrics_hourly
  GROUP BY 1, 2
)
SELECT
  st.date,
  st.service_key,
  nc.total_nat_cost * (st.bytes_transferred / SUM(st.bytes_transferred) OVER (PARTITION BY st.date)) as allocated_nat_cost
FROM service_traffic st
JOIN nat_cost nc ON st.date = nc.date;
```

### 5.3 Activity-Based Costing

**Database Cost Allocation:**
- Allocate RDS cost based on query count or CPU time per service

```sql
-- Allocate database cost by query count
WITH db_cost AS (
  SELECT date, SUM(database_cost) as total_db_cost
  FROM fact_cost_hourly
  WHERE resource_type = 'rds'
  GROUP BY 1
),
service_queries AS (
  SELECT
    date,
    service_key,
    COUNT(*) as query_count  -- From database query logs
  FROM fact_database_queries
  GROUP BY 1, 2
)
SELECT
  sq.date,
  sq.service_key,
  dc.total_db_cost * (sq.query_count / SUM(sq.query_count) OVER (PARTITION BY sq.date)) as allocated_db_cost
FROM service_queries sq
JOIN db_cost dc ON sq.date = dc.date;
```

## 6. Data Pipeline Architecture

### 6.1 ETL/ELT Pipeline Design

**Approach:** ELT (Extract, Load, Transform) for BigQuery

```
Data Sources → Load to BigQuery (raw) → Transform in BigQuery → Serve to Looker
```

**Pipeline Orchestration:**
- **Tool:** Apache Airflow, Prefect, or dbt Cloud
- **Schedule:** 
  - Real-time: OpenTelemetry traces (streaming via Pub/Sub)
  - Hourly: CloudWatch metrics, application logs
  - Daily: AWS CUR, Azure cost data (once available)

**DAG Structure:**
```python
# Airflow DAG (simplified)
with DAG('performance_cost_pipeline', schedule_interval='@hourly') as dag:
  
  # Extract
  extract_cloudwatch_metrics = CloudWatchToGCSOperator(...)
  extract_traces = PubSubToGCSOperator(...)
  extract_cur_data = S3ToGCSOperator(...)
  
  # Load
  load_cloudwatch = GCSToBigQueryOperator(table='raw_cloudwatch_metrics', ...)
  load_traces = GCSToBigQueryOperator(table='raw_traces', ...)
  load_cur = GCSToBigQueryOperator(table='raw_cur_data', ...)
  
  # Transform
  transform_performance = BigQueryOperator(
    sql='sql/transform_performance_hourly.sql',
    destination_table='fact_performance_metrics_hourly',
    write_disposition='WRITE_APPEND'
  )
  
  transform_cost = BigQueryOperator(
    sql='sql/transform_cost_hourly.sql',
    destination_table='fact_cost_hourly',
    write_disposition='WRITE_APPEND'
  )
  
  join_performance_cost = BigQueryOperator(
    sql='sql/join_performance_cost.sql',
    destination_table='fact_performance_cost_joined',
    write_disposition='WRITE_APPEND'
  )
  
  # Dependencies
  [extract_cloudwatch_metrics, extract_traces] >> load_cloudwatch >> transform_performance
  extract_cur_data >> load_cur >> transform_cost
  [transform_performance, transform_cost] >> join_performance_cost
```

### 6.2 Incremental Processing

**Watermark-Based Incremental Load:**
```sql
-- Only process new data since last run
CREATE OR REPLACE TABLE fact_performance_metrics_hourly AS
SELECT * FROM fact_performance_metrics_hourly
WHERE hour < TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), HOUR)  -- Exclude current incomplete hour

UNION ALL

SELECT
  TIMESTAMP_TRUNC(timestamp, HOUR) as hour,
  DATE(timestamp) as date,
  service_key,
  endpoint_key,
  region_key,
  environment_key,
  
  COUNT(*) as request_count,
  SUM(CASE WHEN is_error THEN 1 ELSE 0 END) as error_count,
  
  APPROX_QUANTILES(duration_ms, 100)[OFFSET(95)] as duration_p95_ms,
  
  COUNT(*) / 3600 as requests_per_second  -- Hourly average
FROM fact_performance_requests
WHERE timestamp >= (
  SELECT MAX(hour) FROM fact_performance_metrics_hourly
)
AND timestamp < TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), HOUR)
GROUP BY 1, 2, 3, 4, 5, 6;
```

### 6.3 Data Quality and Validation

**Data Quality Checks:**
```sql
-- Validate no duplicate hours
SELECT hour, service_key, COUNT(*)
FROM fact_performance_metrics_hourly
GROUP BY 1, 2
HAVING COUNT(*) > 1;

-- Validate no null critical fields
SELECT COUNT(*)
FROM fact_performance_requests
WHERE timestamp IS NULL OR service_key IS NULL;

-- Validate reasonable values
SELECT COUNT(*)
FROM fact_performance_requests
WHERE duration_ms < 0 OR duration_ms > 300000;  -- >5 minutes is suspicious

-- Validate cost data availability
SELECT date, COUNT(DISTINCT service_key)
FROM fact_cost_hourly
WHERE date >= CURRENT_DATE - 7
GROUP BY 1
ORDER BY 1;
```

**Alerting on Data Quality Issues:**
- Missing data (expected hourly load didn't run)
- Data anomalies (sudden 10x increase in request count)
- Schema changes (new fields, type changes)

## 7. Performance Optimization

### 7.1 BigQuery Optimization

**Partitioning:**
- All fact tables partitioned by date
- Reduces query costs (only scan relevant partitions)
- Faster query execution

**Clustering:**
- Cluster on frequently filtered/grouped columns
- Example: service_key, endpoint_key
- Improves query performance 2-10x

**Nested and Repeated Fields:**
```sql
-- Instead of wide table with 100+ columns, use struct
CREATE TABLE fact_performance_requests (
  trace_id STRING,
  timestamp TIMESTAMP,
  
  performance STRUCT<
    duration_ms FLOAT64,
    http_status_code INT64,
    is_error BOOLEAN
  >,
  
  resource STRUCT<
    host_name STRING,
    container_id STRING,
    pod_name STRING
  >,
  
  custom_attributes JSON  -- For flexibility
);
```

**Materialized Views:**
- Pre-compute expensive joins and aggregations
- Auto-refresh on data changes
- Transparent to Looker (query rewriting)

### 7.2 Query Optimization in Looker

**Looker PDTs (Persistent Derived Tables):**
```lkml
view: performance_summary {
  derived_table: {
    sql:
      SELECT
        service_key,
        DATE(hour) as date,
        AVG(duration_p95_ms) as avg_p95_latency
      FROM ${fact_performance_metrics_hourly.SQL_TABLE_NAME}
      GROUP BY 1, 2 ;;
    
    datagroup_trigger: daily_refresh
    partition_keys: ["date"]
    cluster_keys: ["service_key"]
  }
}
```

**Aggregate Awareness:**
- Automatically use pre-aggregated tables
- Looker rewrites queries to use fastest source

## 8. Future Data Architecture (2025-2035)

### 8.1 Lakehouse Architecture (2025-2027)

**Transition to Apache Iceberg/Delta Lake:**
- ACID transactions on data lake
- Time travel (query historical versions)
- Schema evolution
- Unified batch + streaming

### 8.2 Real-Time OLAP (2027-2030)

**Technologies:**
- Apache Pinot for sub-second analytics
- ClickHouse for high-performance queries
- Druid for real-time aggregations

**Use Case:**
- Live dashboards (<1 second refresh)
- Real-time anomaly detection
- Instant cost-performance correlation

### 8.3 Quantum Data Warehousing (2030-2035)

**Vision:**
- Quantum computing for complex joins and aggregations
- Instant query results on petabyte-scale data
- Real-time multi-dimensional analysis

## 9. Disaster Recovery and Backup

### 9.1 Backup Strategy

**Data Backup:**
- Daily snapshots of fact and dimension tables
- Retention: 90 days
- Cross-region replication for DR

**Metadata Backup:**
- LookML version control (Git)
- Dashboard exports (JSON)
- Data pipeline code (Git)

### 9.2 Recovery Time Objectives (RTO/RPO)

**RTO (Recovery Time Objective):**
- Critical dashboards: 1 hour
- Standard dashboards: 4 hours
- Historical analysis: 24 hours

**RPO (Recovery Point Objective):**
- Real-time data: 5 minutes (stream processing)
- Batch data: 1 hour (hourly pipeline)
- Cost data: 24 hours (CUR availability)

## 10. Conclusion

A well-designed data model enables:
1. **Fast Queries:** Pre-aggregation and smart indexing
2. **Flexible Analysis:** Dimensional modeling for drill-down
3. **Cost Correlation:** Unified performance and cost view
4. **Scalability:** Handles billions of rows efficiently
5. **Maintainability:** Clear structure, automated pipelines

The next decade will bring real-time, AI-powered, quantum-enhanced data architectures—but the principles of dimensional modeling, aggregation, and data quality remain foundational.
