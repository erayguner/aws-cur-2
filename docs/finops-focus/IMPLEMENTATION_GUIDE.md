# AWS CUR to FOCUS Implementation Guide

## Quick Start

This guide helps you implement the AWS CUR 2.0 to FOCUS transformation in your environment.

## Prerequisites

- AWS CUR 2.0 data loaded into BigQuery
- BigQuery project with appropriate permissions
- Basic understanding of SQL and BigQuery

## Step-by-Step Implementation

### Step 1: Verify Source Data

First, verify your AWS CUR 2.0 table structure:

```sql
-- Check if table exists and has data
SELECT 
  COUNT(*) AS row_count,
  MIN(bill_billing_period_start_date) AS earliest_period,
  MAX(bill_billing_period_start_date) AS latest_period,
  SUM(line_item_unblended_cost) AS total_cost
FROM `your-project.your-dataset.aws_cur_raw`;
```

### Step 2: Update SQL Script

Edit `/bigquery/aws_cur_to_focus.sql` and update:

1. **Line 30**: Replace `project.dataset.aws_cur_raw` with your table name
2. **Line 31**: Adjust date filter if needed (default: last 13 months)
3. **Line 1**: Replace view name `project.dataset.aws_cur_focus`

Example:
```sql
FROM `my-company.billing.aws_cur_2_0`
WHERE bill_billing_period_start_date >= '2024-01-01'
```

### Step 3: Create the View

Run the SQL script in BigQuery:

```bash
bq query --use_legacy_sql=false < bigquery/aws_cur_to_focus.sql
```

Or use the BigQuery Console:
1. Open BigQuery Console
2. Click "Compose New Query"
3. Paste the SQL script
4. Click "Run"

### Step 4: Validate Data Quality

Run validation queries to ensure accuracy:

```sql
-- 1. Check row counts match
SELECT 
  (SELECT COUNT(*) FROM `project.dataset.aws_cur_raw`) AS source_rows,
  (SELECT COUNT(*) FROM `project.dataset.aws_cur_focus`) AS focus_rows;

-- 2. Reconcile total costs (should be < 0.01% difference)
WITH source AS (
  SELECT SUM(line_item_unblended_cost) AS total FROM `project.dataset.aws_cur_raw`
),
focus AS (
  SELECT SUM(BilledCost) AS total FROM `project.dataset.aws_cur_focus`
)
SELECT 
  source.total AS source_total,
  focus.total AS focus_total,
  source.total - focus.total AS difference,
  ROUND(ABS(source.total - focus.total) / NULLIF(source.total, 0) * 100, 4) AS percent_diff
FROM source, focus;

-- 3. Verify required fields are not null
SELECT
  COUNT(*) AS rows_with_null_fields
FROM `project.dataset.aws_cur_focus`
WHERE 
  BilledCost IS NULL OR
  ChargeCategory IS NULL OR
  ChargeDescription IS NULL OR
  BillingCurrency IS NULL;

-- 4. Check ChargeCategory distribution
SELECT 
  ChargeCategory,
  COUNT(*) AS row_count,
  ROUND(SUM(BilledCost), 2) AS total_cost,
  ROUND(SUM(BilledCost) * 100.0 / SUM(SUM(BilledCost)) OVER(), 2) AS cost_percentage
FROM `project.dataset.aws_cur_focus`
GROUP BY ChargeCategory
ORDER BY total_cost DESC;

-- 5. Check ServiceCategory mapping
SELECT 
  ServiceCategory,
  COUNT(DISTINCT ServiceName) AS distinct_services,
  COUNT(*) AS row_count,
  ROUND(SUM(BilledCost), 2) AS total_cost
FROM `project.dataset.aws_cur_focus`
GROUP BY ServiceCategory
ORDER BY total_cost DESC;
```

### Step 5: Create Materialized Table (Recommended)

For better performance, create a materialized table:

```sql
CREATE OR REPLACE TABLE `project.dataset.aws_cur_focus_materialized`
PARTITION BY DATE(BillingPeriodStart)
CLUSTER BY ServiceName, Region, SubAccountId
OPTIONS(
  description="AWS CUR data in FOCUS format - materialized",
  labels=[("source", "aws_cur"), ("format", "focus")]
)
AS
SELECT * FROM `project.dataset.aws_cur_focus`;
```

### Step 6: Set Up Incremental Refresh

Create a scheduled query for incremental updates:

```sql
-- Delete and reload current and previous month (for corrections)
DELETE FROM `project.dataset.aws_cur_focus_materialized`
WHERE BillingPeriodStart >= DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH);

INSERT INTO `project.dataset.aws_cur_focus_materialized`
SELECT * FROM `project.dataset.aws_cur_focus`
WHERE BillingPeriodStart >= DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH);
```

Schedule this to run daily after your CUR data refresh.

## Testing Queries

### Test Query 1: Top Services by Cost

```sql
SELECT 
  ServiceName,
  ServiceCategory,
  ROUND(SUM(BilledCost), 2) AS total_cost,
  ROUND(SUM(EffectiveCost), 2) AS effective_cost,
  ROUND(SUM(BilledCost) - SUM(EffectiveCost), 2) AS savings
FROM `project.dataset.aws_cur_focus`
WHERE BillingPeriodStart >= DATE_TRUNC(CURRENT_DATE(), MONTH)
GROUP BY ServiceName, ServiceCategory
ORDER BY total_cost DESC
LIMIT 20;
```

### Test Query 2: Commitment Discount Analysis

```sql
SELECT 
  CommitmentDiscountType,
  CommitmentDiscountStatus,
  COUNT(*) AS line_items,
  ROUND(SUM(BilledCost), 2) AS billed_cost,
  ROUND(SUM(EffectiveCost), 2) AS effective_cost,
  ROUND(SUM(BilledCost - EffectiveCost), 2) AS savings
FROM `project.dataset.aws_cur_focus`
WHERE CommitmentDiscountId IS NOT NULL
  AND BillingPeriodStart >= DATE_TRUNC(CURRENT_DATE(), MONTH)
GROUP BY CommitmentDiscountType, CommitmentDiscountStatus
ORDER BY savings DESC;
```

### Test Query 3: Cost by Account and Service

```sql
SELECT 
  SubAccountName,
  ServiceCategory,
  ROUND(SUM(BilledCost), 2) AS total_cost
FROM `project.dataset.aws_cur_focus`
WHERE BillingPeriodStart = DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH)
GROUP BY SubAccountName, ServiceCategory
ORDER BY total_cost DESC
LIMIT 50;
```

### Test Query 4: Regional Cost Distribution

```sql
SELECT 
  RegionName,
  ServiceCategory,
  COUNT(DISTINCT SubAccountId) AS account_count,
  ROUND(SUM(BilledCost), 2) AS total_cost
FROM `project.dataset.aws_cur_focus`
WHERE BillingPeriodStart >= DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH), MONTH)
GROUP BY RegionName, ServiceCategory
ORDER BY total_cost DESC;
```

## Connecting BI Tools

### Looker / Looker Studio

1. Create a new data source
2. Select BigQuery connector
3. Choose `project.dataset.aws_cur_focus_materialized`
4. Create explores and dashboards using FOCUS column names

### Tableau

1. Connect to BigQuery
2. Select the FOCUS table
3. Create calculated fields if needed
4. Build visualizations

### Power BI

1. Get Data → More → BigQuery
2. Enter your project ID
3. Select the FOCUS dataset
4. Load data and create reports

## Troubleshooting

### Issue: View creation fails

**Solution**: Check these common issues:
- Verify source table name is correct
- Ensure you have permissions to create views
- Check for syntax errors in column references

### Issue: Cost reconciliation shows large difference

**Solution**: 
- Check if filtering is applied differently
- Verify date ranges match
- Look for NULL cost values in source data
- Check for currency conversion issues

### Issue: Performance is slow

**Solution**:
- Create a materialized table instead of view
- Add partitioning and clustering
- Limit date ranges in queries
- Use table previews for exploration

### Issue: Missing ServiceCategory values

**Solution**:
- Check if new AWS services need to be added to mapping
- Review "Other" category for unmapped services
- Update ServiceCategory CASE statement as needed

## Performance Optimization

### Query Performance

1. **Always filter by date**:
   ```sql
   WHERE BillingPeriodStart >= '2024-11-01'
   ```

2. **Use clustered columns** in WHERE clause:
   ```sql
   WHERE ServiceName = 'AmazonEC2'
     AND Region = 'us-east-1'
     AND SubAccountId = '123456789012'
   ```

3. **Limit columns** in SELECT:
   ```sql
   SELECT ServiceName, BilledCost, EffectiveCost  -- Don't use SELECT *
   ```

### Cost Optimization

1. Use the materialized table for frequent queries
2. Set up table expiration for old data
3. Use partitioned queries
4. Monitor query costs in BigQuery

## Best Practices

1. **Version Control**: Keep SQL scripts in Git
2. **Documentation**: Document any custom mappings
3. **Testing**: Test on sample data before production
4. **Monitoring**: Set up alerts for data quality issues
5. **Updates**: Review FOCUS specification updates regularly

## Next Steps

1. Create custom views for specific use cases
2. Build FinOps dashboards
3. Set up cost anomaly detection
4. Implement chargeback reports
5. Create commitment discount optimization reports

## Support Resources

- [FOCUS Specification](https://focus.finops.org/)
- [AWS CUR Documentation](https://docs.aws.amazon.com/cur/)
- [BigQuery Best Practices](https://cloud.google.com/bigquery/docs/best-practices)
- [FinOps Foundation](https://www.finops.org/)

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-11-17 | Initial implementation guide |
