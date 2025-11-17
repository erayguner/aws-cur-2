# FinOps FOCUS Troubleshooting Guide

**Version:** 1.0.0  
**Last Updated:** 2025-11-17

---

## Table of Contents

1. [AWS CUR Issues](#aws-cur-issues)
2. [GCP Billing Export Issues](#gcp-billing-export-issues)
3. [BigQuery Issues](#bigquery-issues)
4. [FOCUS View Issues](#focus-view-issues)
5. [Looker Issues](#looker-issues)
6. [Data Quality Issues](#data-quality-issues)
7. [Performance Issues](#performance-issues)
8. [Cost Reconciliation Issues](#cost-reconciliation-issues)
9. [Monitoring & Alerting Issues](#monitoring--alerting-issues)
10. [Emergency Procedures](#emergency-procedures)

---

## AWS CUR Issues

### Issue 1.1: CUR Not Generated After 24 Hours

**Symptoms:**
- No data in S3 bucket after creating CUR report
- Athena table is empty

**Diagnosis:**
```bash
# Check CUR configuration
aws cur describe-report-definitions --region us-east-1

# Check S3 bucket contents
aws s3 ls s3://my-cur-bucket/cur-reports/ --recursive
```

**Common Causes & Solutions:**

1. **CUR report not finalized yet**
   - CUR reports are generated once daily
   - First report can take up to 24 hours
   - **Solution:** Wait up to 48 hours before escalating

2. **Incorrect S3 bucket policy**
   ```bash
   # Verify bucket policy allows billingreports.amazonaws.com
   aws s3api get-bucket-policy --bucket my-cur-bucket
   
   # If missing, apply correct policy (see IMPLEMENTATION_GUIDE.md)
   ```

3. **Wrong AWS region**
   - CUR must be created in us-east-1
   - **Solution:** Delete and recreate in correct region

4. **Billing account has no usage**
   - No CUR data if no AWS costs
   - **Solution:** Verify account has active resources

**Verification:**
```bash
# Once data appears, verify structure
aws s3 ls s3://my-cur-bucket/cur-reports/focus-cur-v2/focus-cur-v2/ --recursive | head -20
```

---

### Issue 1.2: Athena Table Not Querying CUR Data

**Symptoms:**
- Athena table exists but returns 0 rows
- Error: "Table not found" or "No partitions found"

**Diagnosis:**
```sql
-- Check table exists
SHOW TABLES IN cur_database;

-- Check partitions
SHOW PARTITIONS cur_database.focus_cur_v2;

-- Attempt simple query
SELECT COUNT(*) FROM cur_database.focus_cur_v2 LIMIT 10;
```

**Common Causes & Solutions:**

1. **Partitions not loaded**
   ```sql
   -- Repair table partitions
   MSCK REPAIR TABLE cur_database.focus_cur_v2;
   
   -- Or manually add partition
   ALTER TABLE cur_database.focus_cur_v2 
   ADD PARTITION (year='2025', month='11') 
   LOCATION 's3://my-cur-bucket/cur-reports/focus-cur-v2/focus-cur-v2/year=2025/month=11/';
   ```

2. **Incorrect table schema**
   - AWS updates CUR schema periodically
   - **Solution:** Re-run AWS-generated create table SQL from S3

3. **S3 path mismatch**
   ```sql
   -- Verify LOCATION in table DDL matches actual S3 structure
   SHOW CREATE TABLE cur_database.focus_cur_v2;
   ```

---

### Issue 1.3: BigQuery Data Transfer from S3 Failing

**Symptoms:**
- BigQuery Data Transfer shows "FAILED" status
- No data appearing in `aws_cur_raw` dataset

**Diagnosis:**
```bash
# Check transfer status
bq ls --transfer_config --project_id=my-project

# View transfer run details
bq show --transfer_config projects/12345/locations/us/transferConfigs/abc123

# Check transfer run logs
bq show --transfer_run projects/12345/locations/us/transferConfigs/abc123/runs/xyz789
```

**Common Causes & Solutions:**

1. **AWS credentials invalid**
   - Access Key or Secret Key incorrect
   - **Solution:** Verify IAM user credentials
   ```bash
   # Test S3 access with credentials
   aws s3 ls s3://my-cur-bucket --profile bigquery-transfer
   ```

2. **S3 bucket policy doesn't allow BigQuery**
   ```json
   {
     "Effect": "Allow",
     "Principal": {"AWS": "arn:aws:iam::ACCOUNT:user/bigquery-cur-import"},
     "Action": ["s3:GetObject", "s3:ListBucket"],
     "Resource": ["arn:aws:s3:::my-cur-bucket", "arn:aws:s3:::my-cur-bucket/*"]
   }
   ```

3. **Incorrect S3 path pattern**
   - Path must match Parquet file locations
   - **Solution:** Update `data_path` parameter
   ```
   Correct: s3://my-cur-bucket/cur-reports/focus-cur-v2/focus-cur-v2/**/*.parquet
   Wrong:   s3://my-cur-bucket/cur-reports/*.parquet
   ```

4. **BigQuery dataset doesn't exist**
   ```bash
   # Create dataset if missing
   bq mk --dataset --location=US my-project:aws_cur_raw
   ```

---

## GCP Billing Export Issues

### Issue 2.1: GCP Billing Export Not Enabled

**Symptoms:**
- No tables in `gcp_billing_export` dataset
- Billing export status shows "Disabled"

**Diagnosis:**
```bash
# Check billing export status
gcloud beta billing accounts describe-export \
  --billing-account=0X0X0X-0X0X0X-0X0X0X

# Check BigQuery dataset exists
bq ls my-project:gcp_billing_export
```

**Common Causes & Solutions:**

1. **Billing export not enabled**
   ```bash
   # Enable billing export
   gcloud beta billing accounts set-export \
     --billing-account=0X0X0X-0X0X0X-0X0X0X \
     --dataset-id=gcp_billing_export \
     --project=my-project
   ```

2. **Insufficient permissions**
   - Need `billing.accounts.update` permission
   - **Solution:** Request Billing Account Administrator role

3. **Dataset in wrong project**
   - Billing export dataset must be in specified project
   - **Solution:** Verify project ID matches

---

### Issue 2.2: GCP Billing Data 24-48 Hours Delayed

**Symptoms:**
- Latest billing data is from 2 days ago
- Tables exist but missing recent dates

**Diagnosis:**
```sql
-- Check latest data available
SELECT
  MAX(_TABLE_SUFFIX) AS latest_table,
  MAX(DATE(usage_start_time)) AS latest_date
FROM `my-project.gcp_billing_export.gcp_billing_export_v1_*`;
```

**Explanation:**
- GCP Billing Export has an **inherent 24-48 hour delay**
- This is expected behavior, not an issue

**Solutions:**
1. **For real-time monitoring:** Use Cloud Monitoring metrics instead
2. **For near-real-time costs:** Query Cloud Billing API (billed hourly)
3. **For reporting:** Accept 48-hour delay as standard

---

### Issue 2.3: Missing Labels/Tags in GCP Billing Export

**Symptoms:**
- `labels` field is empty or NULL
- Cannot filter by resource tags

**Diagnosis:**
```sql
-- Check if labels exist
SELECT
  labels,
  COUNT(*) as row_count
FROM `my-project.gcp_billing_export.gcp_billing_export_v1_*`
WHERE _TABLE_SUFFIX >= FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY))
GROUP BY labels;
```

**Common Causes & Solutions:**

1. **Resources not labeled**
   - GCP resources must have labels applied
   - **Solution:** Implement label governance policy

2. **Labels not propagating to billing**
   - Some resource types don't support labels
   - **Solution:** Check GCP documentation for labelable resources

3. **Export doesn't include labels**
   - Older billing export versions may not include labels
   - **Solution:** Re-enable billing export to get latest schema

---

## BigQuery Issues

### Issue 3.1: Query Timeout or Slow Performance

**Symptoms:**
- Queries take > 30 seconds
- Timeout errors in Looker

**Diagnosis:**
```sql
-- Check query performance
SELECT
  user_email,
  query,
  total_bytes_processed / POW(10, 9) AS gb_processed,
  total_slot_ms / 1000 AS duration_sec,
  creation_time
FROM `my-project.region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE creation_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)
  AND state = 'DONE'
ORDER BY total_slot_ms DESC
LIMIT 10;
```

**Common Causes & Solutions:**

1. **Missing partition filter**
   ```sql
   -- ❌ Bad (scans entire table)
   SELECT SUM(BilledCost) FROM unified_focus;
   
   -- ✅ Good (partition pruning)
   SELECT SUM(BilledCost) FROM unified_focus
   WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY);
   ```

2. **Not using clustered columns**
   ```sql
   -- Recreate table with clustering
   CREATE OR REPLACE TABLE `my-project.focus_views.unified_focus_materialized`
   PARTITION BY DATE(ChargePeriodStart)
   CLUSTER BY ProviderName, ServiceCategory, SubAccountId
   AS SELECT * FROM `my-project.focus_views.unified_focus`;
   ```

3. **Scanning too many columns**
   ```sql
   -- ❌ Avoid SELECT *
   SELECT * FROM unified_focus WHERE ...;
   
   -- ✅ Select only needed columns
   SELECT ProviderName, ServiceCategory, SUM(BilledCost) 
   FROM unified_focus WHERE ... GROUP BY 1, 2;
   ```

4. **Table not materialized**
   - Views re-execute underlying query each time
   - **Solution:** Create materialized table (see IMPLEMENTATION_GUIDE.md)

---

### Issue 3.2: BigQuery Costs Exceeding Budget

**Symptoms:**
- Monthly BigQuery bill > $500
- Unexpected charges

**Diagnosis:**
```sql
-- Analyze query costs by user
SELECT
  user_email,
  DATE(creation_time) AS date,
  COUNT(*) AS query_count,
  SUM(total_bytes_processed) / POW(10, 12) AS tb_processed,
  SUM(total_bytes_processed) / POW(10, 12) * 5 AS estimated_cost
FROM `my-project.region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE creation_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  AND job_type = 'QUERY'
GROUP BY user_email, date
ORDER BY estimated_cost DESC;
```

**Common Causes & Solutions:**

1. **Unoptimized queries**
   - Users running full table scans
   - **Solution:** Implement query cost monitoring and user education

2. **Looker PDTs refreshing too frequently**
   - Persistent Derived Tables rebuild unnecessarily
   - **Solution:** Adjust PDT trigger logic in LookML

3. **Missing query result caching**
   ```sql
   -- Enable query result caching (24 hours)
   -- Add to all Looker queries:
   SELECT ... FROM unified_focus
   WHERE ChargePeriodStart >= CURRENT_DATE() - 30
   -- BigQuery auto-caches identical queries
   ```

4. **Not using flat-rate pricing**
   - Consider BigQuery flat-rate if querying > 1TB/day
   - **Solution:** Evaluate BigQuery Flex Slots or Editions

---

### Issue 3.3: "Exceeded rate limits" Error

**Symptoms:**
- Error: "Exceeded rate limits: too many table update operations"
- Scheduled queries failing

**Diagnosis:**
```bash
# Check quotas
gcloud compute project-info describe --project=my-project | grep -A 20 quotas
```

**Common Causes & Solutions:**

1. **Too many concurrent queries**
   - BigQuery has 100 concurrent query limit per project
   - **Solution:** Implement query queuing or increase quota

2. **Too frequent table updates**
   - Limit: 1,500 table operations per table per day
   - **Solution:** Batch updates instead of row-by-row

3. **Streaming inserts quota exceeded**
   - **Solution:** Use batch loading instead of streaming

**Request Quota Increase:**
```bash
# Request quota increase via support ticket
gcloud services quota update \
  --service=bigquery.googleapis.com \
  --consumer=projects/my-project \
  --metric=bigquery.googleapis.com/quota/query/usage \
  --value=1000
```

---

## FOCUS View Issues

### Issue 4.1: NULL Values in Required FOCUS Columns

**Symptoms:**
- FOCUS columns showing NULL
- Data validation queries failing

**Diagnosis:**
```sql
-- Check NULL counts in FOCUS views
SELECT
  'ProviderName' AS column_name, COUNT(*) - COUNT(ProviderName) AS null_count FROM unified_focus
UNION ALL SELECT 'BilledCost', COUNT(*) - COUNT(BilledCost) FROM unified_focus
UNION ALL SELECT 'ChargePeriodStart', COUNT(*) - COUNT(ChargePeriodStart) FROM unified_focus
UNION ALL SELECT 'ServiceCategory', COUNT(*) - COUNT(ServiceCategory) FROM unified_focus;
```

**Common Causes & Solutions:**

1. **Incorrect column mapping**
   - Source column doesn't exist in CUR/Billing export
   - **Solution:** Update transformation SQL with COALESCE or default values
   ```sql
   -- Example fix
   COALESCE(line_item_product_code, 'Unknown') AS ServiceCategory
   ```

2. **Schema changes in source data**
   - AWS/GCP updated billing export schema
   - **Solution:** Review AWS CUR changelog and update views

3. **Missing CASE statement logic**
   ```sql
   -- Add default case
   CASE
     WHEN condition1 THEN value1
     WHEN condition2 THEN value2
     ELSE 'Unknown'  -- Add this
   END AS MappedColumn
   ```

---

### Issue 4.2: Cost Amounts Don't Match Source

**Symptoms:**
- FOCUS `BilledCost` != AWS CUR `line_item_unblended_cost`
- GCP costs don't match Billing Reports

**Diagnosis:**
```sql
-- Compare AWS totals
WITH cur_total AS (
  SELECT SUM(line_item_unblended_cost) AS cur_cost
  FROM `my-project.aws_cur_raw.cur_data`
  WHERE line_item_usage_start_date >= '2025-11-01'
),
focus_total AS (
  SELECT SUM(BilledCost) AS focus_cost
  FROM `my-project.focus_views.aws_cur_focus`
  WHERE ChargePeriodStart >= '2025-11-01'
)
SELECT 
  cur_cost, 
  focus_cost,
  (focus_cost - cur_cost) / cur_cost * 100 AS pct_diff
FROM cur_total CROSS JOIN focus_total;
```

**Common Causes & Solutions:**

1. **Wrong cost column used**
   - AWS has multiple cost types: unblended, blended, amortized
   - **Solution:** Verify correct column in transformation
   ```sql
   -- For BilledCost, use:
   line_item_unblended_cost
   
   -- For EffectiveCost with commitments, use:
   COALESCE(
     reservation_effective_cost,
     savings_plan_savings_plan_effective_cost,
     line_item_unblended_cost
   )
   ```

2. **Currency conversion issues**
   - GCP may return costs in different currency
   - **Solution:** Standardize to USD
   ```sql
   CASE
     WHEN currency = 'USD' THEN cost
     WHEN currency = 'EUR' THEN cost * exchange_rate
     ELSE cost  -- Add conversion logic
   END AS BilledCost
   ```

3. **Tax handling mismatch**
   - Including/excluding tax inconsistently
   - **Solution:** Decide on tax treatment and apply consistently

4. **Date range mismatch**
   - Comparing different time periods
   - **Solution:** Ensure same date filters in source and FOCUS queries

---

### Issue 4.3: Duplicate Rows in Unified View

**Symptoms:**
- Same ResourceId appears multiple times for same date
- Cost totals are inflated

**Diagnosis:**
```sql
-- Find duplicates
SELECT
  ChargePeriodStart,
  ProviderName,
  ResourceId,
  COUNT(*) AS occurrence_count
FROM `my-project.focus_views.unified_focus`
WHERE ChargePeriodStart >= CURRENT_DATE() - 7
GROUP BY ChargePeriodStart, ProviderName, ResourceId
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC
LIMIT 20;
```

**Common Causes & Solutions:**

1. **Multiple line items for same resource**
   - Different charge types (usage, tax, credit)
   - **Solution:** This is expected; filter by `ChargeCategory` if needed

2. **AWS split cost allocation**
   - CUR includes `SPLIT_COST_ALLOCATION_DATA`
   - **Solution:** Decide if you want split costs or not
   ```sql
   -- Exclude split costs
   WHERE line_item_line_item_type != 'SavingsPlanNegation'
   ```

3. **GCP export includes all SKUs**
   - Multiple SKUs for same resource
   - **Solution:** Group by resource, not SKU

---

## Looker Issues

### Issue 5.1: Looker Connection Test Failing

**Symptoms:**
- "Connection failed" error in Looker
- Cannot query BigQuery

**Diagnosis:**
```bash
# Test service account permissions
bq query --use_legacy_sql=false \
  --service_account_credential_file=looker-key.json \
  'SELECT 1'

# Check service account roles
gcloud projects get-iam-policy my-project \
  --flatten="bindings[].members" \
  --filter="bindings.members:looker-bq-reader@my-project.iam.gserviceaccount.com"
```

**Common Causes & Solutions:**

1. **Service account missing permissions**
   ```bash
   # Add required roles
   gcloud projects add-iam-policy-binding my-project \
     --member="serviceAccount:looker-bq-reader@my-project.iam.gserviceaccount.com" \
     --role="roles/bigquery.dataViewer"
   
   gcloud projects add-iam-policy-binding my-project \
     --member="serviceAccount:looker-bq-reader@my-project.iam.gserviceaccount.com" \
     --role="roles/bigquery.jobUser"
   ```

2. **Incorrect JSON key file**
   - Verify file is valid JSON
   - **Solution:** Re-download key from GCP

3. **BigQuery API not enabled**
   ```bash
   gcloud services enable bigquery.googleapis.com --project=my-project
   ```

4. **Looker IP not allowlisted**
   - BigQuery VPC Service Controls may block Looker
   - **Solution:** Add Looker IPs to allowlist

---

### Issue 5.2: LookML Validation Errors

**Symptoms:**
- "LookML Error" in Looker Development mode
- Cannot deploy to production

**Diagnosis:**
1. Navigate to **Develop** → **Projects** → Select project
2. Click **Validate LookML**
3. Review error messages

**Common Errors & Solutions:**

1. **"Syntax error: Unexpected token"**
   ```lookml
   # ❌ Wrong
   dimension: provider_name {
     type string  # Missing colon
   }
   
   # ✅ Correct
   dimension: provider_name {
     type: string
   }
   ```

2. **"Unknown field"**
   - Field doesn't exist in BigQuery table
   - **Solution:** Verify field exists:
   ```sql
   SELECT column_name
   FROM `my-project.focus_views.INFORMATION_SCHEMA.COLUMNS`
   WHERE table_name = 'unified_focus';
   ```

3. **"Circular dependency"**
   - Two views reference each other
   - **Solution:** Refactor to remove circular reference

4. **"Connection not found"**
   ```lookml
   # Verify connection name matches
   connection: "bigquery_focus"  # Must match Looker connection name
   ```

---

### Issue 5.3: Dashboard Tiles Not Loading

**Symptoms:**
- Dashboard shows "Error" or spinning wheel
- Some tiles load, others don't

**Diagnosis:**
1. Click on failing tile → "Explore from Here"
2. Review error message in Explore
3. Check underlying SQL query

**Common Causes & Solutions:**

1. **Query timeout**
   - Query takes > 300 seconds (Looker default)
   - **Solution:** Optimize query (see BigQuery performance issues)

2. **Insufficient BigQuery permissions**
   - Service account can't access table
   - **Solution:** Grant `bigquery.dataViewer` on specific dataset

3. **Partition filter required**
   - BigQuery table has `require_partition_filter=true`
   - **Solution:** Always include date filter in Looker explores
   ```lookml
   sql_always_where: ${charge_period_start_date} >= DATE_ADD(CURRENT_DATE(), INTERVAL -90 DAY) ;;
   ```

4. **Row limit exceeded**
   - Looker has 5000 row default limit
   - **Solution:** Add aggregation or increase row limit

---

## Data Quality Issues

### Issue 6.1: Missing Data for Specific Dates

**Symptoms:**
- Gaps in daily cost data
- Certain dates show $0 cost

**Diagnosis:**
```sql
-- Check for date gaps
WITH date_series AS (
  SELECT date
  FROM UNNEST(GENERATE_DATE_ARRAY('2025-01-01', CURRENT_DATE())) AS date
),
actual_data AS (
  SELECT DISTINCT DATE(ChargePeriodStart) AS date
  FROM `my-project.focus_views.unified_focus`
)
SELECT d.date AS missing_date
FROM date_series d
LEFT JOIN actual_data a ON d.date = a.date
WHERE a.date IS NULL
ORDER BY d.date;
```

**Common Causes & Solutions:**

1. **Source data delay**
   - AWS CUR or GCP billing export delayed
   - **Solution:** Wait 24-48 hours; data will backfill

2. **BigQuery scheduled query failed**
   - Refresh job didn't run
   - **Solution:** Check scheduled query history and re-run manually

3. **Partition dropped**
   - Table partition accidentally deleted
   - **Solution:** Re-run data load for missing dates

---

### Issue 6.2: Incorrect Tag Values

**Symptoms:**
- Tags showing "Unknown" or NULL
- Tag-based allocation not working

**Diagnosis:**
```sql
-- Check tag extraction
SELECT
  Tags,
  COUNT(*) AS row_count
FROM `my-project.focus_views.unified_focus`
WHERE ChargePeriodStart >= CURRENT_DATE() - 7
GROUP BY Tags
ORDER BY row_count DESC
LIMIT 20;
```

**Common Causes & Solutions:**

1. **Tag column not parsed correctly**
   - AWS CUR stores tags as: `{"user:Team":"Engineering"}`
   - GCP stores as: `[{"key":"team","value":"engineering"}]`
   - **Solution:** Fix JSON parsing in FOCUS view
   ```sql
   -- AWS tag extraction
   JSON_EXTRACT_SCALAR(resource_tags, '$.user:Team') AS team_tag
   
   -- GCP tag extraction
   (SELECT value FROM UNNEST(labels) WHERE key = 'team') AS team_tag
   ```

2. **Resources not tagged**
   - No tags applied to cloud resources
   - **Solution:** Implement tag governance policy

---

## Performance Issues

### Issue 7.1: Dashboard Load Time > 10 Seconds

**Symptoms:**
- Dashboards slow to load
- Users complaining about performance

**Diagnosis:**
1. Open dashboard
2. Check Chrome DevTools → Network tab
3. Identify slow tiles

**Solutions:**

1. **Enable BigQuery BI Engine**
   ```bash
   # Reserve 10 GB for BI Engine caching
   bq query --use_legacy_sql=false << 'SQL'
   CREATE CAPACITY
     `my-project.region-us.bi_engine_capacity_10gb`
   OPTIONS (bi_engine_mode = 'RESERVED', size_gb = 10);
   SQL
   ```

2. **Use aggregate awareness in Looker**
   ```lookml
   explore: unified_costs {
     aggregate_table: daily_summary {
       query: {
         dimensions: [charge_period_start_date, provider_name]
         measures: [total_billed_cost]
       }
       materialization: {
         datagroup_trigger: daily_refresh
       }
     }
   }
   ```

3. **Create summary tables**
   ```sql
   CREATE OR REPLACE TABLE `my-project.focus_views.daily_summary`
   PARTITION BY date
   AS
   SELECT
     DATE(ChargePeriodStart) AS date,
     ProviderName,
     ServiceCategory,
     SUM(BilledCost) AS total_cost
   FROM `my-project.focus_views.unified_focus`
   GROUP BY date, ProviderName, ServiceCategory;
   ```

---

## Cost Reconciliation Issues

### Issue 8.1: FOCUS Costs Don't Match Billing Reports

**Symptoms:**
- FOCUS totals off by > 1%
- Finance team reporting discrepancies

**Diagnosis:**
```sql
-- Detailed reconciliation
WITH aws_source AS (
  SELECT 
    'AWS' AS provider,
    DATE_TRUNC(line_item_usage_start_date, MONTH) AS month,
    SUM(line_item_unblended_cost) AS source_cost
  FROM `my-project.aws_cur_raw.cur_data`
  GROUP BY month
),
aws_focus AS (
  SELECT
    'AWS' AS provider,
    DATE_TRUNC(ChargePeriodStart, MONTH) AS month,
    SUM(BilledCost) AS focus_cost
  FROM `my-project.focus_views.aws_cur_focus`
  GROUP BY month
)
SELECT
  s.month,
  s.source_cost,
  f.focus_cost,
  s.source_cost - f.focus_cost AS diff,
  (s.source_cost - f.focus_cost) / s.source_cost * 100 AS pct_diff
FROM aws_source s
JOIN aws_focus f ON s.month = f.month
ORDER BY s.month DESC;
```

**Common Causes & Solutions:**

1. **Credits not included**
   - AWS credits may be separate line items
   - **Solution:** Include credit line items in transformation

2. **Tax handling**
   - Tax included in one system but not the other
   - **Solution:** Standardize tax treatment

3. **Refunds/adjustments**
   - AWS/GCP refunds may not appear immediately
   - **Solution:** Wait for billing cycle to close

4. **Date range mismatch**
   - Comparing different periods
   - **Solution:** Use exact same date filters

---

## Monitoring & Alerting Issues

### Issue 9.1: Alerts Not Firing

**Symptoms:**
- No alerts received despite data issues
- Alert policy exists but inactive

**Diagnosis:**
```bash
# Check alert policies
gcloud alpha monitoring policies list --project=my-project

# Check notification channels
gcloud alpha monitoring channels list --project=my-project

# Test notification channel
gcloud alpha monitoring channels verify CHANNEL_ID
```

**Common Causes & Solutions:**

1. **Notification channel not verified**
   - Email/Slack channel pending verification
   - **Solution:** Check email and verify notification channel

2. **Alert condition not met**
   - Threshold too high/low
   - **Solution:** Adjust alert thresholds

3. **Scheduled query not running**
   - Query to check data freshness not executing
   - **Solution:** Check scheduled query status:
   ```bash
   bq ls --transfer_config --project_id=my-project
   ```

---

## Emergency Procedures

### Critical Issue: Complete Data Loss

**Symptoms:**
- All BigQuery tables empty
- Accidental deletion

**Immediate Actions:**

1. **Check table deletion time**
   ```sql
   -- Tables can be recovered within 7 days
   SELECT
     table_name,
     creation_time,
     deletion_time
   FROM `my-project.focus_views.__TABLES__`
   WHERE deletion_time IS NOT NULL;
   ```

2. **Restore from time travel**
   ```sql
   -- Restore table from 24 hours ago
   CREATE OR REPLACE TABLE `my-project.focus_views.unified_focus_materialized`
   AS
   SELECT * FROM `my-project.focus_views.unified_focus_materialized`
   FOR SYSTEM_TIME AS OF TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR);
   ```

3. **Re-run data loads**
   - Trigger BigQuery Data Transfer manually
   - Re-execute scheduled queries

4. **Contact support**
   - Open GCP support ticket (Priority 1)
   - Escalate to FinOps leadership

---

### Critical Issue: Runaway BigQuery Costs

**Symptoms:**
- BigQuery costs > $1000/day
- Budget alert at 500%

**Immediate Actions:**

1. **Identify expensive queries**
   ```sql
   SELECT
     user_email,
     query,
     total_bytes_processed / POW(10, 12) * 5 AS cost_usd,
     creation_time
   FROM `my-project.region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
   WHERE creation_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
     AND total_bytes_processed / POW(10, 12) * 5 > 100  -- > $100
   ORDER BY cost_usd DESC;
   ```

2. **Kill running queries**
   ```bash
   # List running jobs
   bq ls --jobs --max_results=100 --project_id=my-project
   
   # Cancel expensive job
   bq cancel JOB_ID
   ```

3. **Revoke Looker permissions temporarily**
   ```bash
   gcloud projects remove-iam-policy-binding my-project \
     --member="serviceAccount:looker-bq-reader@my-project.iam.gserviceaccount.com" \
     --role="roles/bigquery.jobUser"
   ```

4. **Enable query cost controls**
   ```sql
   -- Set maximum bytes billed
   SELECT * FROM unified_focus
   WHERE ChargePeriodStart >= CURRENT_DATE() - 30
   OPTIONS (maximum_bytes_billed = 1000000000000);  -- 1 TB limit
   ```

---

## Support Escalation Matrix

| Issue Severity | Response Time | Contact |
|----------------|---------------|---------|
| **P0 (Critical)** | 15 minutes | FinOps Team Lead + Cloud Engineering Manager |
| **P1 (High)** | 2 hours | #finops-focus-support (Slack) |
| **P2 (Medium)** | 1 business day | Email: finops-support@company.com |
| **P3 (Low)** | 3 business days | Internal wiki documentation |

---

## Appendix: Diagnostic Queries

### Health Check Query (Run Daily)

```sql
-- Comprehensive platform health check
WITH freshness AS (
  SELECT
    'Data Freshness' AS check_name,
    CASE WHEN MAX(DATE_DIFF(CURRENT_DATE(), DATE(ChargePeriodEnd), DAY)) <= 1 THEN 'PASS' ELSE 'FAIL' END AS status,
    FORMAT('Latest data: %t', MAX(ChargePeriodEnd)) AS details
  FROM `my-project.focus_views.unified_focus`
),
completeness AS (
  SELECT
    'Row Completeness' AS check_name,
    CASE WHEN COUNT(*) > 0 THEN 'PASS' ELSE 'FAIL' END AS status,
    FORMAT('%d rows', COUNT(*)) AS details
  FROM `my-project.focus_views.unified_focus`
  WHERE ChargePeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
),
nulls AS (
  SELECT
    'NULL Values' AS check_name,
    CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status,
    FORMAT('%d NULLs in BilledCost', COUNT(*)) AS details
  FROM `my-project.focus_views.unified_focus`
  WHERE BilledCost IS NULL AND ChargePeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
)
SELECT * FROM freshness
UNION ALL SELECT * FROM completeness
UNION ALL SELECT * FROM nulls;
```

---

**Document Version:** 1.0.0  
**Last Updated:** 2025-11-17  
**Maintained by:** FinOps Team + Cloud Engineering
