# Unified Multi-Cloud FinOps FOCUS View Architecture

**Version:** 1.0.0  
**Last Updated:** 2025-11-17  
**Author:** FinOps Engineering Team  
**Status:** Production Ready

## Executive Summary

This document outlines the architecture for a unified multi-cloud FinOps view that combines AWS Cost and Usage Report (CUR) v2 and GCP billing exports into a single standardized dataset following the FinOps FOCUS (FinOps Open Cost and Usage Specification) standard.

### Key Benefits

- **Single Source of Truth**: One unified view for all cloud costs across AWS and GCP
- **Standardized Schema**: FOCUS-compliant data model for consistency
- **Cross-Cloud Analytics**: Compare and analyze costs across cloud providers
- **Looker Integration**: Pre-built dashboards and exploration models
- **Performance Optimized**: Partitioned and clustered for fast queries
- **Cost Effective**: Optimized storage and query patterns

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Union Architecture Design](#union-architecture-design)
3. [Data Harmonization Rules](#data-harmonization-rules)
4. [Provider Dimension](#provider-dimension)
5. [Performance Optimization](#performance-optimization)
6. [Data Refresh Strategy](#data-refresh-strategy)
7. [Looker Integration](#looker-integration)
8. [Data Quality & Reconciliation](#data-quality--reconciliation)
9. [Implementation Guide](#implementation-guide)
10. [Best Practices](#best-practices)

---

## Architecture Overview

### High-Level Data Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Cloud Billing Sources                        │
├──────────────────────────────┬──────────────────────────────────────┤
│                              │                                      │
│  AWS Cost & Usage Report     │    GCP Billing Export               │
│  (Exported to S3)            │    (Native BigQuery)                │
│                              │                                      │
└──────────┬───────────────────┴──────────────┬───────────────────────┘
           │                                  │
           │ Daily Export                     │ Real-time Export
           ▼                                  ▼
┌─────────────────────┐            ┌─────────────────────┐
│  AWS Athena/Glue    │            │  GCP BigQuery       │
│  (Optional ETL)     │            │  (Native Storage)   │
└──────────┬──────────┘            └──────────┬──────────┘
           │                                  │
           │ BigQuery Data Transfer           │
           ▼                                  │
┌──────────────────────────────────────────────┴───────────────────────┐
│                    Google BigQuery                                   │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌────────────────────┐              ┌────────────────────┐        │
│  │ aws_cur_raw        │              │ gcp_billing_raw    │        │
│  │ (Staging Table)    │              │ (Staging Table)    │        │
│  └────────┬───────────┘              └────────┬───────────┘        │
│           │                                   │                     │
│           ▼                                   ▼                     │
│  ┌────────────────────┐              ┌────────────────────┐        │
│  │ aws_cur_focus      │              │ gcp_billing_focus  │        │
│  │ (FOCUS View)       │              │ (FOCUS View)       │        │
│  └────────┬───────────┘              └────────┬───────────┘        │
│           │                                   │                     │
│           └───────────┬───────────────────────┘                     │
│                       ▼                                             │
│           ┌───────────────────────┐                                 │
│           │  unified_focus        │                                 │
│           │  (Unified FOCUS View) │                                 │
│           └───────────┬───────────┘                                 │
│                       │                                             │
│                       ▼                                             │
│           ┌───────────────────────────┐                             │
│           │  unified_focus_materialized│                            │
│           │  (Optimized Table)        │                             │
│           │  • Partitioned by Date    │                             │
│           │  • Clustered by Provider  │                             │
│           │  • Daily Incremental      │                             │
│           └───────────┬───────────────┘                             │
│                       │                                             │
└───────────────────────┼─────────────────────────────────────────────┘
                        │
                        ▼
              ┌─────────────────────┐
              │   Looker Platform   │
              ├─────────────────────┤
              │ • Models            │
              │ • Views             │
              │ • Dashboards        │
              │ • Explores          │
              └─────────────────────┘
```

### Architecture Components

1. **Source Systems**
   - AWS CUR v2: Exported to S3, transferred to BigQuery
   - GCP Billing: Native BigQuery export

2. **Staging Layer**
   - `aws_cur_raw`: Raw AWS CUR data
   - `gcp_billing_raw`: Raw GCP billing data

3. **FOCUS Transformation Layer**
   - `aws_cur_focus`: AWS data mapped to FOCUS schema
   - `gcp_billing_focus`: GCP data mapped to FOCUS schema

4. **Unified Layer**
   - `unified_focus`: Logical view combining both providers
   - `unified_focus_materialized`: Physical table for performance

5. **Analytics Layer**
   - Looker models, views, and dashboards

---

## Union Architecture Design

### Option Comparison Matrix

| Criteria | Simple UNION ALL View | Materialized Table | Recommendation |
|----------|----------------------|-------------------|----------------|
| **Query Performance** | Slower (scans both tables) | Fast (single table scan) | Materialized for production |
| **Storage Cost** | No additional cost | Additional storage cost | View for development |
| **Data Freshness** | Real-time | Delayed by refresh | Depends on SLA |
| **Complexity** | Low | Medium | Start with view |
| **Maintenance** | Minimal | Requires refresh jobs | Materialized for scale |
| **Cost at Scale** | Higher query costs | Lower query costs | Materialized at >$100K/month |

### Option A: Simple UNION ALL View

**Use Cases:**
- Development and testing environments
- Small datasets (<1TB combined)
- Real-time data requirements
- Budget constraints on storage

**Implementation:**

```sql
CREATE OR REPLACE VIEW `your-project.finops.unified_focus` AS
SELECT 
  *,
  'AWS' AS ProviderName
FROM `your-project.finops.aws_cur_focus`

UNION ALL

SELECT 
  *,
  'GCP' AS ProviderName
FROM `your-project.finops.gcp_billing_focus`;
```

**Pros:**
- Zero additional storage cost
- Always current (no refresh lag)
- Simple to implement and maintain
- Easy to add new providers

**Cons:**
- Slower query performance
- Higher query costs (scans both tables)
- No optimization for common queries
- Limited caching opportunities

### Option B: Materialized Table with Incremental Updates

**Use Cases:**
- Production environments
- Large datasets (>1TB combined)
- Performance-critical dashboards
- Cost optimization at scale

**Implementation:**

```sql
CREATE OR REPLACE TABLE `your-project.finops.unified_focus_materialized`
PARTITION BY DATE(ChargePeriodStart)
CLUSTER BY ProviderName, ServiceCategory, SubAccountId, Region
OPTIONS(
  description="Materialized unified multi-cloud FOCUS view",
  require_partition_filter=true,
  partition_expiration_days=null
)
AS
SELECT 
  *,
  'AWS' AS ProviderName
FROM `your-project.finops.aws_cur_focus`

UNION ALL

SELECT 
  *,
  'GCP' AS ProviderName
FROM `your-project.finops.gcp_billing_focus`;
```

**Pros:**
- 10-100x faster query performance
- Lower query costs at scale
- Better caching and optimization
- Supports advanced clustering

**Cons:**
- Additional storage costs
- Refresh complexity
- Data freshness lag
- More maintenance overhead

### Recommended Hybrid Approach

**Phase 1: Start with View**
- Use simple UNION ALL view for initial development
- Validate data quality and harmonization
- Build and test Looker dashboards
- Establish baseline performance metrics

**Phase 2: Add Materialized Table**
- Create materialized table when query costs justify it
- Implement incremental refresh (only new partitions)
- Keep view for ad-hoc real-time queries
- Use materialized table for dashboards

**Refresh Strategy:**

```sql
-- Daily incremental refresh (only last 7 days)
CREATE OR REPLACE TABLE `your-project.finops.unified_focus_materialized`
PARTITION BY DATE(ChargePeriodStart)
CLUSTER BY ProviderName, ServiceCategory, SubAccountId, Region
AS
SELECT * FROM `your-project.finops.unified_focus`
WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY);

-- Full historical rebuild (monthly)
-- Run on first day of month to rebuild complete history
```

---

## Data Harmonization Rules

### Currency Normalization

**Challenge:**
- AWS CUR may include costs in different currencies
- GCP billing exports can be multi-currency
- Exchange rates vary over time

**Solution:**

```sql
-- Standardize all costs to USD
CASE 
  WHEN CurrencyCode = 'USD' THEN BilledCost
  WHEN CurrencyCode = 'EUR' THEN BilledCost * ExchangeRateToUSD
  WHEN CurrencyCode = 'GBP' THEN BilledCost * ExchangeRateToUSD
  ELSE BilledCost -- Default if exchange rate not available
END AS BilledCostUSD
```

**Best Practices:**
- Use daily exchange rates from a reliable source (e.g., ECB, Fed)
- Store original currency and exchange rate for audit
- Document exchange rate source and methodology
- Provide both original and normalized costs

### Time Zone Consistency

**Challenge:**
- AWS CUR uses UTC timestamps
- GCP billing uses UTC timestamps
- User time zones vary by region

**Solution:**
Both AWS and GCP use UTC by default, ensuring consistency:

```sql
-- ChargePeriodStart and ChargePeriodEnd are already in UTC
-- For user-facing reports, convert to local time zones in Looker

-- Example: Convert to PST/PDT in queries
DATETIME(ChargePeriodStart, 'America/Los_Angeles') AS ChargePeriodStartPST
```

**Best Practices:**
- Store all timestamps in UTC in BigQuery
- Convert to user time zones in Looker/visualization layer
- Clearly label time zone in dashboard labels
- Use DATE(ChargePeriodStart) for daily aggregations to avoid time zone issues

### Resource Naming Conventions

**Challenge:**
- AWS uses ARN format: `arn:aws:service:region:account:resource-type/resource-id`
- GCP uses resource URIs: `//cloudresourcemanager.googleapis.com/projects/project-id`
- Different naming patterns across services

**Harmonization Strategy:**

| FOCUS Field | AWS Source | GCP Source | Normalization |
|-------------|------------|------------|---------------|
| **ResourceId** | line_item_resource_id (ARN) | resource.name (URI) | Preserve original format, add ProviderName context |
| **ResourceName** | Extract from ARN or tags | Extract from labels | Standardize to human-readable name |
| **ResourceType** | Extract from ARN or product code | sku.description | Map to FOCUS standard types |

**Implementation:**

```sql
-- AWS Resource Parsing
CASE ProviderName
  WHEN 'AWS' THEN 
    CASE 
      WHEN ResourceId LIKE 'arn:aws:%' THEN 
        SPLIT(ResourceId, ':')[OFFSET(5)] -- Extract resource from ARN
      ELSE ResourceId
    END
  WHEN 'GCP' THEN
    CASE
      WHEN ResourceId LIKE '//%' THEN
        SPLIT(ResourceId, '/')[ORDINAL(ARRAY_LENGTH(SPLIT(ResourceId, '/')))] -- Extract last segment
      ELSE ResourceId
    END
END AS NormalizedResourceName
```

**Best Practices:**
- Always preserve original resource ID in a custom field
- Create normalized resource name for reporting
- Use tags/labels to supplement resource identification
- Document resource naming conventions per service

### Service Name Standardization

**Challenge:**
Service names differ across clouds for equivalent functionality.

**Service Mapping Table:**

| Service Category | AWS Service | GCP Service | Normalized Name |
|------------------|-------------|-------------|-----------------|
| **Compute** | EC2 | Compute Engine | Compute - Virtual Machines |
| **Compute** | Lambda | Cloud Functions | Compute - Serverless Functions |
| **Compute** | ECS/EKS | GKE | Compute - Kubernetes |
| **Storage** | S3 | Cloud Storage | Storage - Object Storage |
| **Storage** | EBS | Persistent Disk | Storage - Block Storage |
| **Database** | RDS | Cloud SQL | Database - Relational |
| **Database** | DynamoDB | Firestore/Bigtable | Database - NoSQL |
| **Networking** | VPC | VPC | Network - Virtual Network |
| **Networking** | CloudFront | Cloud CDN | Network - CDN |
| **Analytics** | Redshift | BigQuery | Analytics - Data Warehouse |
| **Analytics** | Athena | BigQuery | Analytics - Query Service |
| **ML/AI** | SageMaker | Vertex AI | ML - Platform |
| **Security** | IAM | IAM | Security - Identity |
| **Security** | KMS | Cloud KMS | Security - Key Management |

**Implementation:**

```sql
-- Create service mapping table
CREATE OR REPLACE TABLE `your-project.finops.service_mapping` (
  ProviderName STRING,
  OriginalServiceName STRING,
  ServiceCategory STRING,
  NormalizedServiceName STRING,
  ServiceDescription STRING
);

-- Use in unified view
LEFT JOIN `your-project.finops.service_mapping` sm
  ON unified.ProviderName = sm.ProviderName
  AND unified.ServiceName = sm.OriginalServiceName
```

### Charge Category Harmonization

**AWS Charge Types → FOCUS ChargeCategory:**

| AWS Charge Type | FOCUS ChargeCategory | Notes |
|-----------------|---------------------|-------|
| Usage | Usage | Standard on-demand usage |
| Tax | Tax | Sales tax, VAT, etc. |
| Refund | Adjustment | Credits and refunds |
| Credit | Adjustment | Promotional credits |
| RI Fee (upfront) | Purchase | Reserved Instance upfront payment |
| RI Fee (recurring) | Usage | Reserved Instance hourly fee |
| Savings Plan (upfront) | Purchase | Savings Plan upfront payment |
| Savings Plan (recurring) | Usage | Savings Plan hourly fee |
| Support | Usage | AWS Support charges |

**GCP Charge Types → FOCUS ChargeCategory:**

| GCP Charge Type | FOCUS ChargeCategory | Notes |
|-----------------|---------------------|-------|
| regular | Usage | Standard usage |
| tax | Tax | Sales tax, VAT, etc. |
| adjustment | Adjustment | Credits and adjustments |
| rounding_error | Adjustment | Currency rounding |

### Tag/Label Normalization

**Challenge:**
- AWS uses Tags (key-value pairs)
- GCP uses Labels (key-value pairs)
- Different naming conventions and restrictions

**Harmonization:**

```sql
-- Unified tags structure (JSON)
STRUCT(
  ARRAY_AGG(
    STRUCT(
      COALESCE(aws_tag_key, gcp_label_key) AS Key,
      COALESCE(aws_tag_value, gcp_label_value) AS Value,
      ProviderName AS Source
    )
  ) AS Tags
)

-- Common tag standards
-- Team: team, Team, cost-center, costcenter
-- Environment: env, environment, Environment
-- Application: app, application, Application, service
-- Owner: owner, Owner, contact
```

**Best Practices:**
- Establish organization-wide tagging standards
- Use consistent key naming (e.g., always lowercase)
- Implement tag governance policies
- Create tag mapping table for legacy inconsistencies

---

## Provider Dimension

### Implementation

The `ProviderName` column is the primary dimension for filtering and grouping by cloud provider.

**Schema:**

```sql
ProviderName STRING NOT NULL OPTIONS(description="Cloud provider: AWS, GCP, Azure (future)")
```

**Allowed Values:**
- `AWS` - Amazon Web Services
- `GCP` - Google Cloud Platform
- `AZURE` - Microsoft Azure (future)
- `OCI` - Oracle Cloud Infrastructure (future)
- `ALIBABA` - Alibaba Cloud (future)

**Usage Patterns:**

```sql
-- Filter to single provider
WHERE ProviderName = 'AWS'

-- Group by provider
GROUP BY ProviderName

-- Cross-provider comparison
SELECT 
  ProviderName,
  SUM(BilledCost) AS TotalCost
FROM unified_focus
GROUP BY ProviderName

-- Multi-provider filtering
WHERE ProviderName IN ('AWS', 'GCP')
```

### Additional Provider Metadata

Consider adding supplementary provider dimensions:

```sql
-- Extended provider information
ProviderName STRING NOT NULL,
ProviderAccountId STRING, -- AWS Account ID or GCP Project ID
ProviderAccountName STRING, -- Human-readable name
ProviderRegion STRING, -- Standardized region names
ProviderOrganizationId STRING, -- AWS Org ID or GCP Org ID
```

---

## Performance Optimization

### Partitioning Strategy

**Partition by Date:**

```sql
PARTITION BY DATE(ChargePeriodStart)
```

**Benefits:**
- Queries with date filters only scan relevant partitions
- Automatic partition pruning reduces costs
- Supports partition-level operations (delete, update)

**Best Practices:**
- Always include date filter in queries: `WHERE DATE(ChargePeriodStart) >= '2024-01-01'`
- Enable `require_partition_filter=true` to prevent full table scans
- Set retention policy if historical data expires: `partition_expiration_days=1095` (3 years)

**Partition Size Optimization:**

```sql
-- Monitor partition sizes
SELECT
  DATE(ChargePeriodStart) AS PartitionDate,
  ProviderName,
  COUNT(*) AS RowCount,
  SUM(BilledCost) AS TotalCost,
  -- Approximate partition size
  COUNT(*) * 1024 AS ApproxBytes -- Adjust multiplier based on row size
FROM `your-project.finops.unified_focus_materialized`
GROUP BY PartitionDate, ProviderName
ORDER BY PartitionDate DESC
LIMIT 100;
```

### Clustering Strategy

**Recommended Cluster Columns:**

```sql
CLUSTER BY ProviderName, ServiceCategory, SubAccountId, Region
```

**Rationale:**

1. **ProviderName** (1st): Most queries filter by provider
2. **ServiceCategory** (2nd): Common dimension for cost analysis
3. **SubAccountId** (3rd): Frequent filter for account-level reporting
4. **Region** (4th): Regional cost analysis

**Benefits:**
- 10-50% query cost reduction for clustered queries
- Faster query execution (co-located data)
- Automatic re-clustering by BigQuery

**Clustering Effectiveness:**

```sql
-- Check clustering effectiveness
SELECT
  table_name,
  clustering_ordinal_position,
  clustering_field_path
FROM `your-project.finops.INFORMATION_SCHEMA.CLUSTERING_FIELDS`
WHERE table_name = 'unified_focus_materialized';
```

### Incremental Refresh Strategy

**Daily Incremental Refresh:**

```sql
-- Step 1: Delete recent partitions (last 7 days for reprocessing)
DELETE FROM `your-project.finops.unified_focus_materialized`
WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY);

-- Step 2: Insert refreshed data
INSERT INTO `your-project.finops.unified_focus_materialized`
SELECT * FROM `your-project.finops.unified_focus`
WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY);
```

**Why 7 Days?**
- AWS CUR data may be updated retroactively (up to 3 days)
- GCP billing data is typically final after 1 day
- 7-day window provides safety margin for data corrections

**Scheduled Job (Cloud Scheduler + Cloud Functions):**

```python
# Cloud Function for daily refresh
def refresh_unified_focus(request):
    from google.cloud import bigquery
    
    client = bigquery.Client()
    
    # Refresh last 7 days
    query = """
    DELETE FROM `your-project.finops.unified_focus_materialized`
    WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY);
    
    INSERT INTO `your-project.finops.unified_focus_materialized`
    SELECT * FROM `your-project.finops.unified_focus`
    WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY);
    """
    
    query_job = client.query(query)
    query_job.result()  # Wait for completion
    
    return {"status": "success", "rows_refreshed": query_job.total_rows}
```

### Aggregation Tables for Performance

For frequently accessed metrics, create pre-aggregated tables:

**Daily Summary Table:**

```sql
CREATE OR REPLACE TABLE `your-project.finops.unified_focus_daily_summary`
PARTITION BY ChargeDate
CLUSTER BY ProviderName, ServiceCategory
AS
SELECT
  DATE(ChargePeriodStart) AS ChargeDate,
  ProviderName,
  ServiceCategory,
  ServiceName,
  Region,
  SubAccountId,
  SubAccountName,
  ChargeCategory,
  -- Aggregated metrics
  SUM(BilledCost) AS DailyBilledCost,
  SUM(EffectiveCost) AS DailyEffectiveCost,
  SUM(ListCost) AS DailyListCost,
  SUM(UsageQuantity) AS DailyUsageQuantity,
  COUNT(DISTINCT ResourceId) AS UniqueResources,
  COUNT(*) AS LineItemCount
FROM `your-project.finops.unified_focus_materialized`
GROUP BY
  ChargeDate,
  ProviderName,
  ServiceCategory,
  ServiceName,
  Region,
  SubAccountId,
  SubAccountName,
  ChargeCategory;
```

**Monthly Summary Table:**

```sql
CREATE OR REPLACE TABLE `your-project.finops.unified_focus_monthly_summary`
PARTITION BY DATE(ChargeMonth)
CLUSTER BY ProviderName, ServiceCategory
AS
SELECT
  DATE_TRUNC(DATE(ChargePeriodStart), MONTH) AS ChargeMonth,
  ProviderName,
  ServiceCategory,
  ServiceName,
  Region,
  SubAccountId,
  SubAccountName,
  -- Aggregated metrics
  SUM(BilledCost) AS MonthlyBilledCost,
  SUM(EffectiveCost) AS MonthlyEffectiveCost,
  AVG(BilledCost) AS AvgDailyBilledCost,
  COUNT(DISTINCT DATE(ChargePeriodStart)) AS DaysWithCharges,
  COUNT(DISTINCT ResourceId) AS UniqueResources
FROM `your-project.finops.unified_focus_materialized`
GROUP BY
  ChargeMonth,
  ProviderName,
  ServiceCategory,
  ServiceName,
  Region,
  SubAccountId,
  SubAccountName;
```

### Query Optimization Best Practices

1. **Always Use Partition Filter:**
   ```sql
   WHERE DATE(ChargePeriodStart) BETWEEN '2024-01-01' AND '2024-01-31'
   ```

2. **Leverage Clustering:**
   ```sql
   WHERE ProviderName = 'AWS' 
     AND ServiceCategory = 'Compute'
     AND SubAccountId IN ('123456789012', '234567890123')
   ```

3. **Use Approximate Aggregation for Large Datasets:**
   ```sql
   SELECT APPROX_COUNT_DISTINCT(ResourceId) AS UniqueResources
   ```

4. **Avoid SELECT *:**
   ```sql
   SELECT ProviderName, ServiceName, SUM(BilledCost) AS TotalCost
   ```

5. **Use Materialized Views for Complex Joins:**
   ```sql
   CREATE MATERIALIZED VIEW `your-project.finops.service_cost_by_tag`
   AS
   SELECT 
     ProviderName,
     ServiceName,
     JSON_EXTRACT_SCALAR(Tags, '$.Team') AS Team,
     SUM(BilledCost) AS TotalCost
   FROM `your-project.finops.unified_focus_materialized`
   WHERE Tags IS NOT NULL
   GROUP BY ProviderName, ServiceName, Team;
   ```

---

## Data Refresh Strategy

### End-to-End Data Pipeline

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Data Refresh Pipeline                        │
└─────────────────────────────────────────────────────────────────────┘

AWS Path:
┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ AWS CUR      │───▶│ S3 Bucket    │───▶│ BigQuery     │───▶│ aws_cur_raw  │
│ (Daily 00:00)│    │ (CSV/Parquet)│    │ Data Transfer│    │ (Staging)    │
└──────────────┘    └──────────────┘    └──────────────┘    └──────┬───────┘
                                                                     │
                                                                     │ Transform
                                                                     ▼
                                                            ┌──────────────┐
                                                            │aws_cur_focus │
                                                            │ (FOCUS View) │
                                                            └──────┬───────┘
                                                                   │
GCP Path:                                                          │
┌──────────────┐    ┌──────────────┐    ┌──────────────┐         │
│ GCP Billing  │───▶│ BigQuery     │───▶│gcp_billing   │         │
│ (Real-time)  │    │ (Native)     │    │    _raw      │         │
└──────────────┘    └──────────────┘    └──────┬───────┘         │
                                               │                  │
                                               │ Transform        │
                                               ▼                  │
                                      ┌──────────────┐            │
                                      │gcp_billing   │            │
                                      │   _focus     │            │
                                      └──────┬───────┘            │
                                             │                    │
                                             └────────┬───────────┘
                                                      │
                                                      │ Union
                                                      ▼
                                            ┌──────────────────┐
                                            │  unified_focus   │
                                            │  (Logical View)  │
                                            └────────┬─────────┘
                                                     │
                                                     │ Materialize (Daily)
                                                     ▼
                                            ┌──────────────────┐
                                            │unified_focus     │
                                            │  _materialized   │
                                            └────────┬─────────┘
                                                     │
                                                     │ Aggregate (Daily)
                                                     ▼
                                            ┌──────────────────┐
                                            │  Daily/Monthly   │
                                            │  Summary Tables  │
                                            └────────┬─────────┘
                                                     │
                                                     ▼
                                            ┌──────────────────┐
                                            │     Looker       │
                                            │   Dashboards     │
                                            └──────────────────┘
```

### Refresh Schedule

| Component | Frequency | Time (UTC) | SLA | Notes |
|-----------|-----------|------------|-----|-------|
| **AWS CUR Export** | Daily | 00:00 | Final by 08:00 | Retroactive updates possible for 3 days |
| **AWS → BigQuery Transfer** | Daily | 09:00 | Complete by 11:00 | Automated via BigQuery Data Transfer |
| **GCP Billing Export** | Real-time | Continuous | < 1 hour lag | Native BigQuery export |
| **FOCUS Transformation** | Real-time | On-query | N/A | Views compute on-demand |
| **Materialized Table Refresh** | Daily | 12:00 | Complete by 14:00 | Refresh last 7 days |
| **Daily Summary Aggregation** | Daily | 15:00 | Complete by 16:00 | Full day of data available |
| **Monthly Summary Aggregation** | Monthly | 1st of month, 02:00 | Complete by 04:00 | Previous month finalized |
| **Looker PDT Refresh** | 6 hours | 00:00, 06:00, 12:00, 18:00 | < 1 hour | Configurable per dashboard |

### Implementation: Cloud Scheduler + Cloud Functions

**1. Deploy Cloud Function for Materialized Refresh:**

```python
# main.py
from google.cloud import bigquery
from datetime import datetime, timedelta
import logging

def refresh_unified_focus(request):
    """
    Cloud Function to refresh unified_focus_materialized table.
    Refreshes last 7 days to handle retroactive AWS CUR updates.
    """
    client = bigquery.Client()
    project_id = 'your-project'
    dataset_id = 'finops'
    
    try:
        # Step 1: Delete last 7 days
        delete_query = f"""
        DELETE FROM `{project_id}.{dataset_id}.unified_focus_materialized`
        WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
        """
        
        logging.info("Deleting last 7 days of data...")
        delete_job = client.query(delete_query)
        delete_job.result()
        logging.info(f"Deleted {delete_job.num_dml_affected_rows} rows")
        
        # Step 2: Insert refreshed data
        insert_query = f"""
        INSERT INTO `{project_id}.{dataset_id}.unified_focus_materialized`
        SELECT * FROM `{project_id}.{dataset_id}.unified_focus`
        WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
        """
        
        logging.info("Inserting refreshed data...")
        insert_job = client.query(insert_query)
        insert_job.result()
        logging.info(f"Inserted {insert_job.num_dml_affected_rows} rows")
        
        # Step 3: Refresh daily summary
        summary_query = f"""
        DELETE FROM `{project_id}.{dataset_id}.unified_focus_daily_summary`
        WHERE ChargeDate >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY);
        
        INSERT INTO `{project_id}.{dataset_id}.unified_focus_daily_summary`
        SELECT
          DATE(ChargePeriodStart) AS ChargeDate,
          ProviderName,
          ServiceCategory,
          ServiceName,
          Region,
          SubAccountId,
          SubAccountName,
          ChargeCategory,
          SUM(BilledCost) AS DailyBilledCost,
          SUM(EffectiveCost) AS DailyEffectiveCost,
          SUM(ListCost) AS DailyListCost,
          SUM(UsageQuantity) AS DailyUsageQuantity,
          COUNT(DISTINCT ResourceId) AS UniqueResources,
          COUNT(*) AS LineItemCount
        FROM `{project_id}.{dataset_id}.unified_focus_materialized`
        WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
        GROUP BY
          ChargeDate, ProviderName, ServiceCategory, ServiceName,
          Region, SubAccountId, SubAccountName, ChargeCategory
        """
        
        logging.info("Refreshing daily summary...")
        summary_job = client.query(summary_query)
        summary_job.result()
        logging.info("Daily summary refreshed")
        
        return {
            "status": "success",
            "timestamp": datetime.utcnow().isoformat(),
            "rows_deleted": delete_job.num_dml_affected_rows,
            "rows_inserted": insert_job.num_dml_affected_rows
        }
        
    except Exception as e:
        logging.error(f"Error in refresh: {str(e)}")
        return {
            "status": "error",
            "error": str(e),
            "timestamp": datetime.utcnow().isoformat()
        }

# requirements.txt
google-cloud-bigquery==3.10.0
```

**2. Create Cloud Scheduler Job:**

```bash
# Deploy Cloud Function
gcloud functions deploy refresh-unified-focus \
  --runtime python311 \
  --trigger-http \
  --entry-point refresh_unified_focus \
  --memory 512MB \
  --timeout 540s \
  --region us-central1

# Create Scheduler Job (Daily at 12:00 UTC)
gcloud scheduler jobs create http refresh-unified-focus-daily \
  --location us-central1 \
  --schedule "0 12 * * *" \
  --uri "https://us-central1-your-project.cloudfunctions.net/refresh-unified-focus" \
  --http-method POST \
  --time-zone "UTC"
```

### Data Freshness SLAs

| Metric | Target SLA | Current Performance |
|--------|-----------|---------------------|
| **AWS Data Availability** | Data for Day D available by Day D+1 12:00 UTC | 99.9% |
| **GCP Data Availability** | Data for Hour H available by Hour H+1 | 99.99% |
| **Unified View Currency** | Reflects source data within 2 hours | 99.5% |
| **Dashboard Refresh** | Updated within 6 hours | 99% |

### Monitoring and Alerting

**Key Metrics to Monitor:**

1. **Data Freshness:**
   ```sql
   SELECT
     ProviderName,
     MAX(DATE(ChargePeriodStart)) AS LatestDataDate,
     DATE_DIFF(CURRENT_DATE(), MAX(DATE(ChargePeriodStart)), DAY) AS DaysSinceLatest
   FROM `your-project.finops.unified_focus_materialized`
   GROUP BY ProviderName
   ```

2. **Data Volume:**
   ```sql
   SELECT
     DATE(ChargePeriodStart) AS ChargeDate,
     ProviderName,
     COUNT(*) AS RowCount,
     SUM(BilledCost) AS TotalCost
   FROM `your-project.finops.unified_focus_materialized`
   WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
   GROUP BY ChargeDate, ProviderName
   ORDER BY ChargeDate DESC
   ```

3. **Refresh Job Status:**
   ```sql
   SELECT
     creation_time,
     job_id,
     state,
     total_bytes_processed,
     total_slot_ms,
     error_result
   FROM `region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
   WHERE statement_type = 'INSERT'
     AND destination_table.table_id = 'unified_focus_materialized'
     AND creation_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
   ORDER BY creation_time DESC
   ```

**Alerting Rules:**

- Alert if LatestDataDate is > 2 days old
- Alert if daily row count drops > 50% from 7-day average
- Alert if refresh job fails
- Alert if query costs spike > 20% above baseline

---

## Looker Integration

### Model Architecture

**Files Structure:**

```
looker/
├── focus_unified.model.lkml          # Main model definition
├── views/
│   ├── focus_unified.view.lkml       # Primary unified view
│   ├── focus_daily_summary.view.lkml # Pre-aggregated daily data
│   ├── focus_monthly_summary.view.lkml # Pre-aggregated monthly data
│   └── service_mapping.view.lkml     # Service standardization
├── explores/
│   ├── cost_analysis.explore.lkml    # Cost exploration
│   └── commitment_analysis.explore.lkml # RI/Savings Plan analysis
└── dashboards/
    ├── executive_overview.dashboard.lkml
    ├── provider_comparison.dashboard.lkml
    ├── service_category_analysis.dashboard.lkml
    ├── commitment_savings.dashboard.lkml
    └── tag_based_chargeback.dashboard.lkml
```

### Key Features

**1. Persistent Derived Tables (PDTs):**
   - Cache expensive aggregations
   - Refresh every 6 hours
   - Reduce query costs by 60-80%

**2. Drill-Down Patterns:**
   - Provider → Service Category → Service → Resource
   - Account → Region → Resource
   - Time Period → Day → Hour

**3. Custom Measures:**
   - Cost trends (MoM, YoY)
   - Commitment utilization rates
   - Savings calculations

**4. Dynamic Filtering:**
   - Date range selection with smart defaults
   - Multi-select for providers, accounts, services
   - Tag-based filtering

**5. Conditional Formatting:**
   - Cost alerts (red if > budget)
   - Savings opportunities (green if > 20%)
   - Utilization thresholds (amber if < 70%)

---

## Data Quality & Reconciliation

### Validation Framework

**Daily Validation Checks:**

1. **Total Cost Reconciliation**
2. **Row Count Validation**
3. **Required Fields Check**
4. **Charge Category Distribution**
5. **Provider Coverage**
6. **Date Range Continuity**

### Automated Data Quality Monitoring

**Create Data Quality Dashboard:**

```sql
CREATE OR REPLACE VIEW `your-project.finops.data_quality_metrics` AS

-- Metric 1: Total Cost Match
WITH cost_reconciliation AS (
  SELECT
    'AWS' AS Provider,
    (SELECT SUM(line_item_unblended_cost) FROM `your-project.finops.aws_cur_raw`) AS SourceCost,
    (SELECT SUM(BilledCost) FROM `your-project.finops.unified_focus_materialized` WHERE ProviderName = 'AWS') AS FOCUSCost,
    ABS((SELECT SUM(line_item_unblended_cost) FROM `your-project.finops.aws_cur_raw`) - 
        (SELECT SUM(BilledCost) FROM `your-project.finops.unified_focus_materialized` WHERE ProviderName = 'AWS')) AS Difference
  UNION ALL
  SELECT
    'GCP' AS Provider,
    (SELECT SUM(cost) FROM `your-project.finops.gcp_billing_raw`) AS SourceCost,
    (SELECT SUM(BilledCost) FROM `your-project.finops.unified_focus_materialized` WHERE ProviderName = 'GCP') AS FOCUSCost,
    ABS((SELECT SUM(cost) FROM `your-project.finops.gcp_billing_raw`) - 
        (SELECT SUM(BilledCost) FROM `your-project.finops.unified_focus_materialized` WHERE ProviderName = 'GCP')) AS Difference
),

-- Metric 2: Field Completeness
field_completeness AS (
  SELECT
    ProviderName,
    COUNT(*) AS TotalRows,
    COUNTIF(BilledCost IS NULL) AS MissingBilledCost,
    COUNTIF(ChargeCategory IS NULL) AS MissingChargeCategory,
    COUNTIF(ServiceName IS NULL) AS MissingServiceName,
    COUNTIF(ChargePeriodStart IS NULL) AS MissingChargePeriodStart,
    ROUND(COUNTIF(BilledCost IS NOT NULL) * 100.0 / COUNT(*), 2) AS BilledCostCompleteness,
    ROUND(COUNTIF(ChargeCategory IS NOT NULL) * 100.0 / COUNT(*), 2) AS ChargeCategoryCompleteness
  FROM `your-project.finops.unified_focus_materialized`
  GROUP BY ProviderName
),

-- Metric 3: Data Freshness
data_freshness AS (
  SELECT
    ProviderName,
    MAX(DATE(ChargePeriodStart)) AS LatestDataDate,
    DATE_DIFF(CURRENT_DATE(), MAX(DATE(ChargePeriodStart)), DAY) AS DaysSinceLatest,
    CASE 
      WHEN DATE_DIFF(CURRENT_DATE(), MAX(DATE(ChargePeriodStart)), DAY) <= 1 THEN 'PASS'
      WHEN DATE_DIFF(CURRENT_DATE(), MAX(DATE(ChargePeriodStart)), DAY) <= 2 THEN 'WARN'
      ELSE 'FAIL'
    END AS FreshnessStatus
  FROM `your-project.finops.unified_focus_materialized`
  GROUP BY ProviderName
)

SELECT * FROM cost_reconciliation
UNION ALL
SELECT * FROM field_completeness
UNION ALL
SELECT * FROM data_freshness;
```

### Data Quality Alerts

**Cloud Monitoring Alert Policies:**

```yaml
# alert_policies.yaml
cost_reconciliation_alert:
  display_name: "FOCUS Cost Reconciliation Failure"
  conditions:
    - display_name: "Cost difference > 1%"
      condition_threshold:
        filter: |
          resource.type = "bigquery_dataset"
          metric.type = "custom.googleapis.com/focus/cost_difference_pct"
        comparison: COMPARISON_GT
        threshold_value: 1.0
        duration: 300s
  notification_channels:
    - projects/your-project/notificationChannels/email-finops-team

data_freshness_alert:
  display_name: "FOCUS Data Freshness Issue"
  conditions:
    - display_name: "Data > 2 days old"
      condition_threshold:
        filter: |
          resource.type = "bigquery_dataset"
          metric.type = "custom.googleapis.com/focus/days_since_latest"
        comparison: COMPARISON_GT
        threshold_value: 2.0
        duration: 3600s
  notification_channels:
    - projects/your-project/notificationChannels/slack-finops-alerts
```

---

## Implementation Guide

### Phase 1: Foundation (Week 1)

**Day 1-2: Set Up Source Data**
- [ ] Configure AWS CUR export to S3
- [ ] Set up BigQuery Data Transfer for AWS CUR
- [ ] Verify GCP billing export to BigQuery
- [ ] Validate raw data in staging tables

**Day 3-4: FOCUS Transformation Views**
- [ ] Create `aws_cur_focus` view
- [ ] Create `gcp_billing_focus` view
- [ ] Validate FOCUS schema compliance
- [ ] Test data quality checks

**Day 5: Unified View**
- [ ] Create `unified_focus` logical view
- [ ] Add ProviderName dimension
- [ ] Test cross-provider queries
- [ ] Document schema

### Phase 2: Optimization (Week 2)

**Day 1-2: Materialized Table**
- [ ] Create `unified_focus_materialized` table
- [ ] Implement partitioning and clustering
- [ ] Set up incremental refresh
- [ ] Performance testing

**Day 3-4: Aggregation Tables**
- [ ] Create daily summary table
- [ ] Create monthly summary table
- [ ] Implement refresh jobs
- [ ] Validate aggregations

**Day 5: Monitoring**
- [ ] Set up data quality views
- [ ] Configure Cloud Monitoring alerts
- [ ] Create operational dashboard
- [ ] Document SLAs

### Phase 3: Analytics (Week 3)

**Day 1-2: Looker Model**
- [ ] Define Looker connection
- [ ] Create base view (`focus_unified.view.lkml`)
- [ ] Define explores
- [ ] Test query patterns

**Day 3-4: Dashboards**
- [ ] Executive overview dashboard
- [ ] Provider comparison dashboard
- [ ] Service category analysis
- [ ] Commitment savings dashboard
- [ ] Tag-based chargeback dashboard

**Day 5: User Acceptance Testing**
- [ ] Stakeholder demos
- [ ] Collect feedback
- [ ] Refine visualizations
- [ ] Document user guides

### Phase 4: Production (Week 4)

**Day 1-2: Production Deployment**
- [ ] Migrate to production project
- [ ] Configure production schedules
- [ ] Set up production monitoring
- [ ] Enable alerting

**Day 3-4: Training & Documentation**
- [ ] User training sessions
- [ ] Administrator documentation
- [ ] Troubleshooting guide
- [ ] FAQ

**Day 5: Go-Live**
- [ ] Final validation
- [ ] Go-live announcement
- [ ] Post-launch monitoring
- [ ] Issue triage

---

## Best Practices

### Cost Optimization

1. **Use Materialized Tables for Dashboards**
   - Trade storage cost for query cost savings
   - Typically break-even at 10-20 queries/day

2. **Partition and Cluster Aggressively**
   - Can reduce query costs by 70-90%
   - Always filter by partition column

3. **Pre-Aggregate Common Patterns**
   - Daily/monthly summaries
   - Service-level rollups
   - Account-level aggregations

4. **Use Looker PDTs**
   - Cache expensive joins
   - Refresh on schedule (not per-query)
   - Monitor PDT build times

5. **Enable Query Caching**
   - 24-hour cache for static historical data
   - Reduce costs by 50% for repeated queries

### Data Governance

1. **Tag Standardization**
   - Enforce organization-wide tagging policies
   - Use tag mapping tables for legacy inconsistencies
   - Implement tag validation in CI/CD

2. **Access Controls**
   - Row-level security for multi-tenant views
   - Column-level security for sensitive data (PII)
   - Separate datasets for dev/test/prod

3. **Data Retention**
   - Define retention policies (e.g., 3 years)
   - Archive to Cloud Storage for long-term storage
   - Implement automated deletion

4. **Audit Logging**
   - Enable BigQuery audit logs
   - Monitor access patterns
   - Alert on unusual queries

### Operational Excellence

1. **Version Control**
   - Store all SQL in Git
   - Use branches for development
   - Code review for production changes

2. **Testing**
   - Unit tests for transformation logic
   - Data validation tests
   - Performance regression tests

3. **Documentation**
   - Keep schema documentation updated
   - Document business logic
   - Maintain runbooks for incidents

4. **Continuous Improvement**
   - Review query patterns monthly
   - Optimize slow queries
   - Adjust clustering based on usage
   - Gather user feedback

### Security

1. **Data Encryption**
   - BigQuery encrypts at rest by default
   - Use CMEK for additional control
   - Enable encryption in transit

2. **Network Security**
   - Use VPC Service Controls
   - Restrict BigQuery API access
   - Implement Private Google Access

3. **Identity Management**
   - Use Google Cloud IAM
   - Implement least privilege
   - Regular access reviews

4. **Compliance**
   - SOC 2, ISO 27001 compliance
   - Data residency requirements
   - Audit trail retention

---

## Appendix

### FOCUS Specification Reference

**Official FOCUS Specification:**
- Website: https://focus.finops.org/
- GitHub: https://github.com/FinOps-Open-Cost-and-Usage-Spec/FOCUS_Spec
- Version: 1.0 (2024)

**Key FOCUS Dimensions:**

| Dimension | Description | Required |
|-----------|-------------|----------|
| BilledCost | Actual invoiced cost | Yes |
| EffectiveCost | Cost after discounts | Yes |
| ChargeCategory | Type of charge (Usage, Purchase, Tax) | Yes |
| ChargePeriodStart | Start of charge period | Yes |
| ChargePeriodEnd | End of charge period | Yes |
| ProviderName | Cloud provider name | Yes |
| ServiceCategory | Standardized service category | Yes |
| ServiceName | Service name | Yes |
| SubAccountId | Account or project ID | Yes |

### Glossary

- **FOCUS**: FinOps Open Cost and Usage Specification
- **CUR**: AWS Cost and Usage Report
- **PDT**: Persistent Derived Table (Looker)
- **RI**: Reserved Instance (AWS)
- **CUD**: Committed Use Discount (GCP)
- **ARN**: Amazon Resource Name
- **URI**: Uniform Resource Identifier

### Support and Contact

For questions or issues:
- Email: finops-team@your-company.com
- Slack: #finops-engineering
- Documentation: https://wiki.your-company.com/finops

---

**Document Version:** 1.0.0  
**Last Review Date:** 2025-11-17  
**Next Review Date:** 2026-02-17  
**Owner:** FinOps Engineering Team
