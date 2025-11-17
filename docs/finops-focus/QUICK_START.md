# FinOps FOCUS Quick Start Guide

**⏱️ Setup Time:** 1-2 weeks | **👥 Team:** 1 Cloud Engineer + 1 BI Developer

---

## 🎯 Overview

Build a unified multi-cloud cost analytics platform combining AWS CUR 2.0 and GCP Billing in BigQuery with FOCUS-compliant schema and Looker dashboards.

**Architecture:** AWS CUR → BigQuery ← GCP Billing → FOCUS Views → Looker

---

## ✅ Prerequisites (15-minute checklist)

### AWS
- [ ] CUR 2.0 enabled → S3 bucket
- [ ] Athena database configured
- [ ] IAM permissions for BigQuery S3 access

### GCP
- [ ] Billing export enabled → BigQuery dataset `gcp_billing_export`
- [ ] BigQuery API enabled
- [ ] Service account with `bigquery.admin`, `billing.viewer`

### Looker
- [ ] Instance provisioned
- [ ] Git repository for LookML
- [ ] BigQuery connection configured

---

## 🚀 Implementation (4 Phases)

### Phase 1: AWS CUR to BigQuery (Days 1-3)

```bash
# 1. Enable CUR in AWS Console
# Cost Management → Cost & Usage Reports → Create
# - Name: focus-cur-v2
# - Format: Parquet, Hourly, Athena integration

# 2. Create S3 bucket
aws s3 mb s3://my-cur-bucket --region us-east-1

# 3. Wait 24h for first report, then configure Athena
# Auto-generated SQL in S3: cur-reports/focus-cur-v2/.../create-table.sql

# 4. Create BigQuery dataset
bq mk --dataset --location=US my-project:aws_cur_raw

# 5. Transfer CUR to BigQuery (Data Transfer Service)
# BigQuery Console → Data Transfers → Amazon S3
# - Source: s3://my-cur-bucket/cur-reports/*/*.parquet
# - Destination: aws_cur_raw.cur_data
# - Schedule: Daily 06:00

# 6. Create FOCUS view
bq query < bigquery/aws_cur_to_focus.sql
```

**Validation:**
```sql
SELECT ProviderName, SUM(BilledCost), COUNT(*) 
FROM `my-project.focus_views.aws_cur_focus`
GROUP BY ProviderName;
```

---

### Phase 2: GCP Billing Export (Days 4-5)

```bash
# 1. Enable billing export
gcloud beta billing accounts set-export \
  --billing-account=0X0X0X-0X0X0X-0X0X0X \
  --dataset-id=gcp_billing_export \
  --project=my-project

# 2. Wait 24-48h for data

# 3. Create FOCUS view
bq query < bigquery/gcp_billing_to_focus.sql
```

**Validation:**
```sql
SELECT ProviderName, SUM(BilledCost), COUNT(*) 
FROM `my-project.focus_views.gcp_billing_focus`
GROUP BY ProviderName;
```

---

### Phase 3: Unified FOCUS Views (Days 6-8)

```bash
# 1. Create unified view
bq query < bigquery/unified_focus_view.sql

# 2. Create materialized table for performance
bq query --use_legacy_sql=false << 'SQL'
CREATE OR REPLACE TABLE `my-project.focus_views.unified_focus_materialized`
PARTITION BY DATE(ChargePeriodStart)
CLUSTER BY ProviderName, ServiceCategory, SubAccountId
AS
SELECT * FROM `my-project.focus_views.unified_focus`;
SQL

# 3. Schedule daily refresh
bq query \
  --schedule='every day 07:00' \
  --display_name='Refresh FOCUS Table' \
  --replace \
  --destination_table=my-project:focus_views.unified_focus_materialized \
  'SELECT * FROM `my-project.focus_views.unified_focus`'
```

**Validation:**
```sql
-- Cost reconciliation
SELECT 
  ProviderName,
  SUM(BilledCost) AS total_cost,
  MIN(ChargePeriodStart) AS earliest,
  MAX(ChargePeriodEnd) AS latest
FROM `my-project.focus_views.unified_focus`
GROUP BY ProviderName;

-- Compare with AWS Cost Explorer and GCP Billing Reports
```

---

### Phase 4: Looker Dashboards (Days 9-14)

```bash
# 1. Create service account
gcloud iam service-accounts create looker-bq-reader \
  --project=my-project

gcloud projects add-iam-policy-binding my-project \
  --member="serviceAccount:looker-bq-reader@my-project.iam.gserviceaccount.com" \
  --role="roles/bigquery.dataViewer"

gcloud projects add-iam-policy-binding my-project \
  --member="serviceAccount:looker-bq-reader@my-project.iam.gserviceaccount.com" \
  --role="roles/bigquery.jobUser"

# 2. Download key
gcloud iam service-accounts keys create looker-key.json \
  --iam-account=looker-bq-reader@my-project.iam.gserviceaccount.com

# 3. Add connection in Looker
# Admin → Connections → Add → BigQuery → Upload looker-key.json

# 4. Deploy LookML project
git clone https://github.com/myorg/looker-finops-focus
cd looker-finops-focus
cp ../docs/finops-focus/looker/*.lkml .
git add . && git commit -m "Initial FOCUS model" && git push

# 5. In Looker: Develop → Projects → Deploy to Production
```

---

## 📊 Key Deliverables

| Deliverable | Location | Purpose |
|-------------|----------|---------|
| AWS CUR FOCUS view | `my-project.focus_views.aws_cur_focus` | AWS cost data (FOCUS schema) |
| GCP FOCUS view | `my-project.focus_views.gcp_billing_focus` | GCP cost data (FOCUS schema) |
| Unified FOCUS table | `my-project.focus_views.unified_focus_materialized` | Multi-cloud unified data |
| Looker model | `models/focus_model.model.lkml` | Data model |
| Looker dashboards | Dashboards → FinOps FOCUS | Cost analytics |

---

## 🧪 Testing Checklist

### Data Quality
- [ ] Row counts match source systems (±0.1%)
- [ ] Cost totals reconcile with billing reports (±0.1%)
- [ ] No NULL values in required FOCUS columns
- [ ] Date ranges complete (no gaps)

### Performance
- [ ] Dashboard load time < 5 seconds
- [ ] Simple queries < 2 seconds
- [ ] Complex queries < 30 seconds

### Functional
- [ ] Filters work (date, provider, service)
- [ ] Drill-downs functional
- [ ] Tag-based allocation accurate
- [ ] Month-over-month comparisons correct

---

## 📈 Monitoring Setup

```bash
# 1. Data freshness alert
bq query --use_legacy_sql=false << 'SQL'
CREATE OR REPLACE VIEW `my-project.monitoring.data_freshness_check` AS
SELECT
  ProviderName,
  MAX(ChargePeriodEnd) AS latest_data,
  DATE_DIFF(CURRENT_DATE(), MAX(DATE(ChargePeriodEnd)), DAY) AS days_stale
FROM `my-project.focus_views.unified_focus`
GROUP BY ProviderName
HAVING days_stale > 1;  -- Alert if >1 day stale
SQL

# 2. Cost spike detection
bq query --use_legacy_sql=false << 'SQL'
CREATE OR REPLACE VIEW `my-project.monitoring.cost_spikes` AS
WITH daily AS (
  SELECT DATE(ChargePeriodStart) AS date, SUM(BilledCost) AS cost
  FROM `my-project.focus_views.unified_focus`
  GROUP BY date
)
SELECT
  date, cost,
  AVG(cost) OVER (ORDER BY date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS avg_7d,
  cost / AVG(cost) OVER (ORDER BY date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) - 1 AS pct_change
FROM daily
WHERE cost / AVG(cost) OVER (ORDER BY date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) > 1.20;
SQL

# 3. BigQuery budget alert
gcloud billing budgets create \
  --billing-account=0X0X0X-0X0X0X-0X0X0X \
  --display-name="BigQuery Budget" \
  --budget-amount=500 \
  --threshold-rule=percent=80
```

---

## 💰 Cost Estimates

| Component | Monthly Cost |
|-----------|--------------|
| BigQuery storage (2-5 TB) | $20-100 |
| BigQuery queries (optimized) | $50-200 |
| BigQuery data transfer | Free |
| Looker (separate license) | $2000+ |
| **Total Infrastructure** | **$70-300** |

**Optimization Tips:**
- Use partition filters in all queries
- Enable clustering on frequently filtered columns
- Materialize expensive aggregations
- Set table expiration for temp tables

---

## 🔧 Troubleshooting (Top 5 Issues)

| Issue | Solution |
|-------|----------|
| **CUR data not in BigQuery** | Wait 24h for first report. Check S3 bucket policy. Verify Data Transfer config. |
| **GCP billing export empty** | Billing export has 24-48h delay. Check dataset permissions. |
| **Cost mismatch** | Ensure same date ranges. Check credit handling. Verify tax inclusion. |
| **Slow queries** | Add partition filters. Use clustered columns. Materialize views. |
| **NULL values in FOCUS columns** | Check source data quality. Review transformation SQL. Update mapping logic. |

---

## 📚 Key Resources

- **Full Guide:** [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)
- **Troubleshooting:** [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Maintenance:** [MAINTENANCE.md](MAINTENANCE.md)
- **Automation:** [scripts/setup.sh](scripts/setup.sh)
- **FOCUS Spec:** https://focus.finops.org/

---

## 🎓 Training (Recommended)

1. **For Finance/Leadership (30 min):** Introduction to FOCUS and dashboard navigation
2. **For Engineers (60 min):** BigQuery queries and cost optimization
3. **For FinOps (45 min):** Tag-based allocation and reporting

---

## ✨ Success Criteria

- ✅ Data freshness < 24 hours
- ✅ Cost reconciliation > 99.9% accurate
- ✅ Dashboard performance < 5 seconds
- ✅ 80%+ user adoption
- ✅ 10+ hours/week saved on reporting

---

## 🚀 Next Steps After Setup

1. **Week 1-2:** Train users on dashboards
2. **Week 3:** Implement tag governance policies
3. **Week 4:** Set up cost allocation reports
4. **Month 2:** Build custom dashboards per team
5. **Month 3:** Implement cost optimization workflows
6. **Ongoing:** Monthly review and optimization

---

**Questions?** Contact: #finops-focus-support (Slack)  
**Version:** 1.0.0 | **Last Updated:** 2025-11-17
