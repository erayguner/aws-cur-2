# FinOps FOCUS Maintenance & Operations Guide

**Version:** 1.0.0  
**Last Updated:** 2025-11-17  
**Review Frequency:** Quarterly

---

## Table of Contents

1. [Daily Operations](#daily-operations)
2. [Weekly Operations](#weekly-operations)
3. [Monthly Operations](#monthly-operations)
4. [Quarterly Operations](#quarterly-operations)
5. [Schema Updates](#schema-updates)
6. [Performance Tuning](#performance-tuning)
7. [Cost Management](#cost-management)
8. [Security & Compliance](#security--compliance)
9. [Disaster Recovery](#disaster-recovery)
10. [Runbook](#runbook)

---

## Daily Operations

**Owner:** Cloud Engineering (On-call rotation)  
**Time Required:** 15-30 minutes

### Morning Health Check (09:00 daily)

#### 1. Data Freshness Validation

```sql
-- Run health check query
SELECT
  ProviderName,
  MAX(DATE(ChargePeriodEnd)) AS latest_data_date,
  DATE_DIFF(CURRENT_DATE(), MAX(DATE(ChargePeriodEnd)), DAY) AS days_stale,
  CASE
    WHEN DATE_DIFF(CURRENT_DATE(), MAX(DATE(ChargePeriodEnd)), DAY) <= 1 THEN '✅ HEALTHY'
    WHEN DATE_DIFF(CURRENT_DATE(), MAX(DATE(ChargePeriodEnd)), DAY) <= 2 THEN '⚠️ WARNING'
    ELSE '🔴 CRITICAL'
  END AS status
FROM `my-project.focus_views.unified_focus`
GROUP BY ProviderName;
```

**Expected Results:**
- AWS: ≤ 1 day stale
- GCP: ≤ 2 days stale (due to inherent 24-48h delay)

**Action if CRITICAL:**
1. Check `monitoring.data_freshness_check` view
2. Verify BigQuery scheduled queries are running
3. Check AWS CUR and GCP billing export status
4. Escalate if issue persists > 24 hours

---

#### 2. Monitor BigQuery Scheduled Queries

```bash
# Check scheduled query status
bq ls --transfer_config --project_id=my-project | grep -E 'FAILED|CANCELLED'

# View failed runs
bq ls --transfer_run --max_results=10 --transfer_config=TRANSFER_CONFIG_ID
```

**Action if failures detected:**
1. Review error logs: `bq show --transfer_run TRANSFER_RUN_ID`
2. Re-run manually: `bq update --transfer_config TRANSFER_CONFIG_ID --update_credentials`
3. Document issue in incident log

---

#### 3. Check Cost Anomalies

```sql
-- Query cost anomalies view
SELECT
  date,
  ProviderName,
  ServiceCategory,
  daily_cost,
  avg_cost_7d,
  pct_change,
  anomaly_severity
FROM `my-project.monitoring.cost_anomalies`
WHERE date = CURRENT_DATE() - 1  -- Yesterday's data
  AND anomaly_severity IN ('WARNING', 'CRITICAL')
ORDER BY ABS(pct_change) DESC;
```

**Action if anomalies found:**
1. Investigate resource-level costs
2. Notify relevant team (e.g., engineering for AWS EC2 spike)
3. Add to weekly cost review agenda

---

#### 4. Review BigQuery Costs (Yesterday)

```sql
-- Daily BigQuery cost check
SELECT
  DATE(creation_time) AS date,
  SUM(total_bytes_processed) / POW(10, 12) AS tb_processed,
  SUM(total_bytes_processed) / POW(10, 12) * 5 AS estimated_cost_usd,
  COUNT(*) AS query_count
FROM `my-project.region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE DATE(creation_time) = CURRENT_DATE() - 1
  AND job_type = 'QUERY'
GROUP BY date;
```

**Expected Range:** $5-20/day  
**Action if > $50/day:**
1. Identify expensive queries
2. Review with BI team
3. Implement query optimization

---

### Daily Checklist

- [ ] Data freshness: AWS ≤1 day, GCP ≤2 days
- [ ] Scheduled queries: All successful
- [ ] Cost anomalies: Reviewed and escalated if critical
- [ ] BigQuery costs: Within expected range
- [ ] Looker dashboards: Loading < 5 seconds
- [ ] No open P0/P1 support tickets

**Log Location:** `#finops-focus-ops` (Slack channel)

---

## Weekly Operations

**Owner:** FinOps Analyst + Cloud Engineer  
**Time Required:** 1-2 hours  
**Schedule:** Every Monday, 10:00 AM

### 1. Cost Reconciliation Report

```sql
-- Weekly cost reconciliation
WITH aws_source AS (
  SELECT
    DATE_TRUNC(line_item_usage_start_date, WEEK) AS week,
    SUM(line_item_unblended_cost) AS aws_source_cost
  FROM `my-project.aws_cur_raw.cur_data`
  WHERE line_item_usage_start_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 4 WEEK)
  GROUP BY week
),
aws_focus AS (
  SELECT
    DATE_TRUNC(ChargePeriodStart, WEEK) AS week,
    SUM(BilledCost) AS aws_focus_cost
  FROM `my-project.focus_views.aws_cur_focus`
  WHERE ChargePeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 4 WEEK)
  GROUP BY week
),
gcp_source AS (
  SELECT
    DATE_TRUNC(usage_start_time, WEEK) AS week,
    SUM(cost) AS gcp_source_cost
  FROM `my-project.gcp_billing_export.gcp_billing_export_v1_*`
  WHERE DATE(usage_start_time) >= DATE_SUB(CURRENT_DATE(), INTERVAL 4 WEEK)
  GROUP BY week
),
gcp_focus AS (
  SELECT
    DATE_TRUNC(ChargePeriodStart, WEEK) AS week,
    SUM(BilledCost) AS gcp_focus_cost
  FROM `my-project.focus_views.gcp_billing_focus`
  WHERE ChargePeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 4 WEEK)
  GROUP BY week
)
SELECT
  COALESCE(a_src.week, a_foc.week, g_src.week, g_foc.week) AS week,
  a_src.aws_source_cost,
  a_foc.aws_focus_cost,
  (a_foc.aws_focus_cost - a_src.aws_source_cost) / a_src.aws_source_cost * 100 AS aws_diff_pct,
  g_src.gcp_source_cost,
  g_foc.gcp_focus_cost,
  (g_foc.gcp_focus_cost - g_src.gcp_source_cost) / g_src.gcp_source_cost * 100 AS gcp_diff_pct
FROM aws_source a_src
FULL OUTER JOIN aws_focus a_foc ON a_src.week = a_foc.week
FULL OUTER JOIN gcp_source g_src ON a_src.week = g_src.week
FULL OUTER JOIN gcp_focus g_foc ON a_src.week = g_foc.week
ORDER BY week DESC;
```

**Acceptance Criteria:**
- AWS diff: < 0.1%
- GCP diff: < 0.1%

**Action if > 0.1% difference:**
1. Investigate discrepancy
2. Review transformation logic
3. Document findings in weekly report

---

### 2. Looker Dashboard Usage Analytics

```sql
-- Looker usage (via System Activity explore)
-- Run this in Looker, not BigQuery

SELECT
  dashboard.title AS dashboard_name,
  COUNT(DISTINCT user.id) AS unique_users,
  COUNT(*) AS total_views,
  AVG(query.runtime) AS avg_runtime_sec
FROM history
WHERE created_date >= DATE_ADD(CURRENT_DATE(), INTERVAL -7 DAY)
GROUP BY dashboard.title
ORDER BY total_views DESC;
```

**Review Metrics:**
- Top 5 most viewed dashboards
- Dashboards with < 5 views (consider deprecating)
- Slow dashboards (avg runtime > 10 sec)

---

### 3. Schema Validation

```sql
-- Verify FOCUS column count and types
SELECT
  table_name,
  COUNT(*) AS column_count
FROM `my-project.focus_views.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name IN ('aws_cur_focus', 'gcp_billing_focus', 'unified_focus')
GROUP BY table_name;

-- Expected: 43 columns per FOCUS spec v1.0
```

**Action if column count ≠ 43:**
1. Check if FOCUS spec updated
2. Review AWS/GCP billing schema changes
3. Update transformation views if needed

---

### 4. Tag Coverage Analysis

```sql
-- Analyze tag coverage
WITH tagged AS (
  SELECT
    ProviderName,
    COUNT(*) AS tagged_rows,
    SUM(BilledCost) AS tagged_cost
  FROM `my-project.focus_views.unified_focus`
  WHERE ChargePeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
    AND Tags IS NOT NULL
    AND Tags != '{}'
  GROUP BY ProviderName
),
total AS (
  SELECT
    ProviderName,
    COUNT(*) AS total_rows,
    SUM(BilledCost) AS total_cost
  FROM `my-project.focus_views.unified_focus`
  WHERE ChargePeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
  GROUP BY ProviderName
)
SELECT
  t.ProviderName,
  tagged_rows,
  total_rows,
  tagged_rows / total_rows * 100 AS pct_rows_tagged,
  tagged_cost,
  total_cost,
  tagged_cost / total_cost * 100 AS pct_cost_tagged
FROM total t
LEFT JOIN tagged tg ON t.ProviderName = tg.ProviderName;
```

**Target:** > 80% cost tagged  
**Action if < 80%:**
1. Identify untagged resources
2. Work with engineering teams to apply tags
3. Report progress in weekly FinOps meeting

---

### Weekly Checklist

- [ ] Cost reconciliation within 0.1%
- [ ] Looker usage reviewed
- [ ] Schema validation passed
- [ ] Tag coverage > 80%
- [ ] No P1 incidents from past week
- [ ] Weekly report published to stakeholders

**Report Template:** `docs/templates/weekly-report.md`

---

## Monthly Operations

**Owner:** FinOps Team Lead  
**Time Required:** 3-4 hours  
**Schedule:** First Monday of each month

### 1. Performance Tuning Review

#### Analyze Query Performance

```sql
-- Top 10 slowest queries (last 30 days)
SELECT
  user_email,
  query,
  AVG(total_slot_ms / 1000) AS avg_duration_sec,
  COUNT(*) AS execution_count,
  AVG(total_bytes_processed) / POW(10, 9) AS avg_gb_scanned
FROM `my-project.region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE creation_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  AND job_type = 'QUERY'
  AND state = 'DONE'
GROUP BY user_email, query
HAVING COUNT(*) > 5  -- Only queries run multiple times
ORDER BY avg_duration_sec DESC
LIMIT 10;
```

**Optimization Actions:**
1. Add partition filters to slow queries
2. Materialize frequently accessed aggregations
3. Update Looker PDT settings

---

#### Review Table Statistics

```bash
# Get table size and partition info
bq show --format=prettyjson my-project:focus_views.unified_focus_materialized
```

**Check:**
- Table size growth rate
- Partition count
- Clustering effectiveness

**Action if table > 1 TB:**
- Consider partitioning by month instead of day
- Implement table expiration for old data

---

### 2. Cost Optimization Analysis

#### Monthly BigQuery Cost Report

```sql
-- BigQuery costs by user (last 30 days)
SELECT
  user_email,
  SUM(total_bytes_processed) / POW(10, 12) AS tb_processed,
  SUM(total_bytes_processed) / POW(10, 12) * 5 AS estimated_cost_usd,
  COUNT(*) AS query_count
FROM `my-project.region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE creation_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  AND job_type = 'QUERY'
GROUP BY user_email
ORDER BY estimated_cost_usd DESC;
```

**Review:**
- Total BigQuery costs vs. budget
- Cost per user
- Inefficient query patterns

**Action if > $250/month:**
1. Implement query cost controls
2. Consider BigQuery flat-rate pricing
3. Optimize expensive queries

---

### 3. Service Category Mapping Update

New AWS/GCP services launch regularly. Update service category mappings:

```sql
-- Find unmapped services
SELECT
  ProviderName,
  ServiceName,
  ServiceCategory,
  SUM(BilledCost) AS total_cost
FROM `my-project.focus_views.unified_focus`
WHERE ChargePeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  AND ServiceCategory = 'Other'
GROUP BY ProviderName, ServiceName, ServiceCategory
ORDER BY total_cost DESC
LIMIT 20;
```

**Action:**
1. Map new services to FOCUS categories
2. Update transformation views
3. Test and deploy updates

---

### 4. User Access Audit

```bash
# List users with BigQuery access
gcloud projects get-iam-policy my-project \
  --flatten="bindings[].members" \
  --filter="bindings.role:roles/bigquery*" \
  --format="table(bindings.role, bindings.members)"

# Review Looker users
# (Via Looker Admin → Users)
```

**Review:**
- Remove inactive users
- Verify role assignments
- Update service account keys if > 90 days old

---

### 5. Backup Validation

```bash
# Verify table snapshots exist
bq ls --format=prettyjson --max_results=100 my-project:focus_views \
  | grep snapshot

# Test restore procedure (in dev environment)
bq cp my-project:focus_views.unified_focus_materialized@-3600000 \
     my-project:focus_views_test.unified_focus_restore_test
```

---

### Monthly Checklist

- [ ] Performance tuning completed
- [ ] BigQuery costs reviewed and optimized
- [ ] Service category mappings updated
- [ ] User access audit completed
- [ ] Backup validation successful
- [ ] Monthly metrics report published
- [ ] Stakeholder presentation prepared

**Report Template:** `docs/templates/monthly-report.md`

---

## Quarterly Operations

**Owner:** FinOps Team + Cloud Architecture  
**Time Required:** 1-2 days  
**Schedule:** End of Q1, Q2, Q3, Q4

### 1. FOCUS Specification Review

Check for FOCUS spec updates:
- Visit: https://focus.finops.org/
- Review changelog
- Assess impact on current implementation

**Action if new version released:**
1. Create migration plan
2. Test transformation updates in dev
3. Deploy to production with validation

---

### 2. Architecture Review

Evaluate platform architecture:

**Questions:**
- Is BigQuery still the right choice?
- Should we use data lake (GCS) for long-term storage?
- Can we reduce costs with different topology?
- Are there new GCP/AWS features to leverage?

**Deliverable:** Architecture review document

---

### 3. Disaster Recovery Drill

Test backup and restore procedures:

1. **Backup Test:**
   ```bash
   # Create snapshot
   bq cp my-project:focus_views.unified_focus_materialized \
        my-project:focus_views_backup.unified_focus_snapshot_$(date +%Y%m%d)
   ```

2. **Restore Test:**
   ```bash
   # Simulate data loss and restore
   bq rm -f my-project:focus_views_test.unified_focus_test
   bq cp my-project:focus_views_backup.unified_focus_snapshot_20251117 \
        my-project:focus_views_test.unified_focus_test
   ```

3. **Validation:**
   ```sql
   -- Compare row counts and totals
   SELECT COUNT(*), SUM(BilledCost)
   FROM `my-project.focus_views_test.unified_focus_test`;
   ```

**Document Results:** `docs/dr-tests/YYYY-MM-DD-dr-test.md`

---

### 4. Compliance & Security Audit

Review security posture:

```bash
# Audit BigQuery access logs
bq query --use_legacy_sql=false << 'SQL'
SELECT
  protopayload_auditlog.authenticationInfo.principalEmail AS user,
  protopayload_auditlog.methodName AS method,
  COUNT(*) AS access_count
FROM `my-project.cloudaudit_googleapis_com_data_access`
WHERE resource.type = 'bigquery_dataset'
  AND timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
GROUP BY user, method
ORDER BY access_count DESC;
SQL

# Check for public datasets
bq ls --filter labels.environment:production --format=prettyjson \
  | grep -i "public"
```

**Review:**
- IAM permissions (least privilege)
- Data encryption (at-rest, in-transit)
- Audit logging enabled
- No public datasets

---

### 5. Training Material Updates

Update documentation and training:

- [ ] Review all documentation for accuracy
- [ ] Update screenshots in user guides
- [ ] Record new training videos
- [ ] Conduct refresher training for new users

---

### Quarterly Checklist

- [ ] FOCUS spec review completed
- [ ] Architecture review document published
- [ ] DR drill successful
- [ ] Security audit passed
- [ ] Training materials updated
- [ ] Quarterly business review (QBR) with leadership

**QBR Presentation Template:** `docs/templates/quarterly-review.pptx`

---

## Schema Updates

### When to Update Schemas

**Triggers:**
1. FOCUS specification version change
2. AWS CUR schema update
3. GCP Billing Export schema update
4. New cloud services require mapping
5. Business requirements change (e.g., new cost allocation tags)

---

### Schema Update Procedure

**Step 1: Identify Changes**

```sql
-- Compare current schema with expected
SELECT
  column_name,
  data_type,
  is_nullable
FROM `my-project.focus_views.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'unified_focus'
ORDER BY ordinal_position;
```

**Step 2: Test in Development**

```bash
# Create test dataset
bq mk --dataset my-project:focus_views_dev

# Deploy updated views to dev
bq query --use_legacy_sql=false < bigquery/aws_cur_to_focus_v2.sql

# Validate
bq query --use_legacy_sql=false << 'SQL'
SELECT COUNT(*), SUM(BilledCost)
FROM `my-project.focus_views_dev.unified_focus`;
SQL
```

**Step 3: Validate Data Quality**

```sql
-- Compare dev vs prod totals
WITH prod AS (
  SELECT SUM(BilledCost) AS prod_cost
  FROM `my-project.focus_views.unified_focus`
  WHERE ChargePeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
),
dev AS (
  SELECT SUM(BilledCost) AS dev_cost
  FROM `my-project.focus_views_dev.unified_focus`
  WHERE ChargePeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
)
SELECT
  prod_cost,
  dev_cost,
  ABS(prod_cost - dev_cost) / prod_cost * 100 AS pct_diff
FROM prod CROSS JOIN dev;
```

**Acceptance:** < 0.1% difference

**Step 4: Deploy to Production**

```bash
# Deploy during low-usage window (Sunday 2am)
bq query --use_legacy_sql=false < bigquery/aws_cur_to_focus_v2.sql

# Verify deployment
bq show --schema --format=prettyjson my-project:focus_views.unified_focus
```

**Step 5: Update Looker Models**

```bash
# Update LookML
git checkout -b feature/focus-schema-update
# Edit views/*.lkml files
git add .
git commit -m "Update FOCUS schema to v1.1"
git push origin feature/focus-schema-update

# Deploy in Looker after PR approval
```

**Step 6: Notify Users**

Post in #finops-focus-users:
```
📢 Schema Update Notice

The FOCUS platform has been updated to FOCUS spec v1.1.
Changes:
- Added column: CommitmentDiscountId
- Renamed: ChargeClass → ChargeCategory

Action Required: None (backward compatible)
Documentation: https://wiki.company.com/finops/focus-v1.1

Questions? Reply in this thread.
```

---

## Performance Tuning

### Monthly Performance Optimization

**1. Identify Slow Queries**

```sql
-- Queries with > 10 second runtime
SELECT
  user_email,
  LEFT(query, 100) AS query_snippet,
  total_slot_ms / 1000 AS duration_sec,
  total_bytes_processed / POW(10, 9) AS gb_scanned,
  creation_time
FROM `my-project.region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE creation_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
  AND total_slot_ms / 1000 > 10
  AND job_type = 'QUERY'
ORDER BY total_slot_ms DESC
LIMIT 20;
```

**2. Add Partition Filters**

```sql
-- ❌ Before (slow)
SELECT SUM(BilledCost) FROM unified_focus
WHERE ProviderName = 'AWS';

-- ✅ After (fast)
SELECT SUM(BilledCost) FROM unified_focus
WHERE DATE(ChargePeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  AND ProviderName = 'AWS';
```

**3. Update Clustering**

```bash
# Analyze query patterns to determine optimal clustering
bq query --use_legacy_sql=false << 'SQL'
SELECT
  REGEXP_EXTRACT(query, r'WHERE.*?(\w+)\s*=') AS filter_column,
  COUNT(*) AS usage_count
FROM `my-project.region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE creation_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  AND query LIKE '%unified_focus%'
GROUP BY filter_column
ORDER BY usage_count DESC;
SQL

# Re-cluster table if needed
CREATE OR REPLACE TABLE `my-project.focus_views.unified_focus_materialized`
PARTITION BY DATE(ChargePeriodStart)
CLUSTER BY ProviderName, ServiceCategory, SubAccountId, ResourceId  -- Updated
AS SELECT * FROM `my-project.focus_views.unified_focus`;
```

**4. Enable BI Engine**

```bash
# Create BI Engine reservation (10 GB)
bq query --use_legacy_sql=false << 'SQL'
CREATE CAPACITY `my-project.region-us.bi_engine_10gb`
OPTIONS (bi_engine_mode = 'RESERVED', size_gb = 10);
SQL

# Monitor BI Engine effectiveness
bq query --use_legacy_sql=false << 'SQL'
SELECT
  DATE(creation_time) AS date,
  bi_engine_mode,
  COUNT(*) AS query_count,
  AVG(total_slot_ms / 1000) AS avg_duration_sec
FROM `my-project.region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE creation_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
  AND referenced_tables.table_id = 'unified_focus_materialized'
GROUP BY date, bi_engine_mode;
SQL
```

---

## Cost Management

### BigQuery Cost Controls

**1. Set Maximum Bytes Billed**

```sql
-- For exploratory queries
SELECT * FROM unified_focus
WHERE ChargePeriodStart >= CURRENT_DATE() - 30
OPTIONS (maximum_bytes_billed = 10000000000);  -- 10 GB max
```

**2. Implement Query Cost Alerting**

```bash
# Create budget alert for BigQuery
gcloud billing budgets create \
  --billing-account=0X0X0X-0X0X0X-0X0X0X \
  --display-name="BigQuery Monthly Budget" \
  --budget-amount=250 \
  --threshold-rule=percent=80 \
  --filter-projects=projects/my-project \
  --filter-services=services/24E6-581D-38E5
```

**3. Review Storage Costs**

```sql
-- Storage costs by table
SELECT
  table_schema,
  table_name,
  ROUND(size_bytes / POW(10, 9), 2) AS size_gb,
  ROUND(size_bytes / POW(10, 9) * 0.02, 2) AS monthly_storage_cost
FROM `my-project.focus_views.__TABLES__`
ORDER BY size_bytes DESC;
```

**Action:** Archive tables > 13 months old to Cloud Storage

---

## Security & Compliance

### Access Control Review (Monthly)

```bash
# List all principals with BigQuery access
gcloud projects get-iam-policy my-project \
  --flatten="bindings[].members" \
  --filter="bindings.role:roles/bigquery*" \
  --format="csv(bindings.role,bindings.members)"

# Review service account keys age
gcloud iam service-accounts keys list \
  --iam-account=looker-bq-reader@my-project.iam.gserviceaccount.com \
  --format="table(name,validAfterTime,validBeforeTime)"
```

**Action Items:**
- Rotate service account keys if > 90 days old
- Remove inactive users
- Verify least privilege access

---

### Data Classification

**Sensitivity Level:** Internal  
**Data Retention:** 13 months (hot), 7 years (cold archive)  
**Encryption:** At-rest (Google-managed), In-transit (TLS)

**Compliance Requirements:**
- SOC 2 Type II
- ISO 27001
- GDPR (if applicable)

---

## Disaster Recovery

### Recovery Time Objective (RTO)

**Target RTO:** 4 hours  
**Actual RTO:** Tested quarterly

### Recovery Point Objective (RPO)

**Target RPO:** 24 hours (accepts loss of 1 day of data)

---

### Backup Strategy

**Daily Snapshots:**

```bash
# Automated daily snapshot (scheduled Cloud Function)
bq cp my-project:focus_views.unified_focus_materialized \
     my-project:focus_views_backup.unified_focus_snapshot_$(date +%Y%m%d)

# Retain 7 daily snapshots
```

**Monthly Archives:**

```bash
# Archive to Cloud Storage (compressed Parquet)
bq extract \
  --destination_format=PARQUET \
  --compression=SNAPPY \
  my-project:focus_views.unified_focus_materialized \
  gs://my-company-finops-archive/focus/2025-11/*.parquet
```

**Retention:**
- Daily snapshots: 7 days
- Weekly snapshots: 4 weeks
- Monthly archives: 7 years

---

### Restore Procedure

**Full Restore:**

```bash
# 1. Create new dataset
bq mk --dataset my-project:focus_views_restored

# 2. Restore from snapshot
bq cp my-project:focus_views_backup.unified_focus_snapshot_20251117 \
     my-project:focus_views_restored.unified_focus_materialized

# 3. Validate
bq query --use_legacy_sql=false << 'SQL'
SELECT COUNT(*), SUM(BilledCost), MIN(ChargePeriodStart), MAX(ChargePeriodEnd)
FROM `my-project.focus_views_restored.unified_focus_materialized`;
SQL

# 4. Update Looker connection to restored dataset (if needed)
```

**Time Travel Restore (< 7 days):**

```sql
-- Restore table from 24 hours ago
CREATE OR REPLACE TABLE `my-project.focus_views.unified_focus_materialized`
AS
SELECT * FROM `my-project.focus_views.unified_focus_materialized`
FOR SYSTEM_TIME AS OF TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR);
```

---

## Runbook

### Quick Reference Commands

**Check Data Freshness:**
```bash
bq query --use_legacy_sql=false 'SELECT MAX(ChargePeriodEnd) FROM `my-project.focus_views.unified_focus`'
```

**Re-run Scheduled Query:**
```bash
bq update --transfer_config=TRANSFER_CONFIG_ID --update_credentials=false
```

**Kill Long-Running Query:**
```bash
bq cancel JOB_ID
```

**Refresh Materialized Table:**
```bash
bq query --use_legacy_sql=false --replace --destination_table=my-project:focus_views.unified_focus_materialized 'SELECT * FROM `my-project.focus_views.unified_focus`'
```

**Check BigQuery Costs (Today):**
```bash
bq query --use_legacy_sql=false 'SELECT SUM(total_bytes_processed)/POW(10,12)*5 FROM `my-project.region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT WHERE DATE(creation_time)=CURRENT_DATE()'
```

---

## Contact Information

**Platform Owners:**
- **FinOps Team Lead:** finops-lead@company.com
- **Cloud Engineering Manager:** cloud-eng-mgr@company.com
- **BI Development Lead:** bi-dev-lead@company.com

**Support Channels:**
- **Slack:** #finops-focus-support
- **Email:** finops-support@company.com
- **Wiki:** https://wiki.company.com/finops/focus

**On-Call Rotation:** PagerDuty schedule (finops-oncall)

---

**Document Version:** 1.0.0  
**Next Review:** 2026-02-17  
**Owner:** FinOps Team
