# AWS CUR 2.0 Looker Model - Deployment Guide
## Version 2.0.0 | Release Date: 2025-08-18

---

## 🎯 DEPLOYMENT OVERVIEW

This guide provides step-by-step instructions for deploying the AWS CUR 2.0 Looker model to your Looker environment. The deployment follows a phased approach to minimize risk and ensure proper validation at each stage.

---

## 📋 PRE-DEPLOYMENT REQUIREMENTS

### 1. Infrastructure Prerequisites ✅
```bash
# Looker Instance Requirements
- Looker Version: 22.0+ (recommended 24.0+)
- RAM: Minimum 16GB, Recommended 32GB
- CPU: Minimum 8 cores, Recommended 16 cores
- Storage: 1TB+ for PDT operations

# Database Requirements
- AWS Athena or compatible data warehouse
- CUR 2.0 data available in queryable format
- Network connectivity from Looker to data source
```

### 2. Database Connection Setup ✅
```sql
-- Connection Name: cid_data_export
-- Connection Type: Amazon Athena / Presto / Trino
-- Database: [your_cur_database_name]
-- S3 Results Location: s3://your-athena-results-bucket/

-- Verify CUR 2.0 table exists
SELECT COUNT(*) FROM cid_data_export.cur2 
WHERE billing_period = (SELECT MAX(billing_period) FROM cid_data_export.cur2);
```

### 3. User Attributes Configuration ✅
```yaml
# Required User Attributes in Looker Admin
user_attributes:
  - name: "cur2_access_level"
    type: "string"
    default_value: "read_only"
    allowed_values: ["admin", "full", "read_only"]
    
  - name: "account_access_filter"
    type: "string"
    default_value: ""
    description: "Comma-separated list of allowed AWS account IDs"
    
  - name: "environment_access"
    type: "string" 
    default_value: "all"
    allowed_values: ["all", "production", "non-production"]
```

---

## 🚀 PHASE 1: CORE MODEL DEPLOYMENT

### Step 1: Deploy Base Model Files
```bash
# Deploy in this exact order:
1. cur2.model.lkml           # Main model with connections
2. cur2.view.lkml            # Primary view with all dimensions/measures  
3. cur2.explore.lkml         # Explore definitions and dashboards
4. cur2_dashboards.lkml      # Executive dashboards (optional)
```

### Step 2: Validate LookML Syntax
```bash
# In Looker Development Mode:
1. Open LookML Validator (Development > Validate LookML)
2. Check for syntax errors and warnings
3. Resolve any red errors (warnings acceptable for initial deployment)
4. Commit changes to development branch
```

### Step 3: Test Core Functionality
```sql
-- Test queries to validate deployment:

-- 1. Basic cost query
SELECT 
  line_item_usage_account_name,
  SUM(line_item_unblended_cost) as total_cost
FROM cid_data_export.cur2 
WHERE line_item_usage_start_date >= CURRENT_DATE - INTERVAL '30' DAY
GROUP BY 1 ORDER BY 2 DESC LIMIT 10;

-- 2. Service categorization test
SELECT 
  CASE 
    WHEN line_item_product_code IN ('AmazonEC2') THEN 'Compute'
    WHEN line_item_product_code IN ('AmazonS3') THEN 'Storage'
    ELSE 'Other'
  END as service_category,
  COUNT(*) as line_items
FROM cid_data_export.cur2 
GROUP BY 1;

-- 3. Tag extraction test  
SELECT 
  element_at(resource_tags, 'Environment') as environment,
  COUNT(*) as resources
FROM cid_data_export.cur2 
WHERE resource_tags IS NOT NULL
GROUP BY 1;
```

### Step 4: Performance Validation
```yaml
# Expected Query Performance Benchmarks:
test_queries:
  - name: "Monthly cost trend"
    query: "cur2.total_unblended_cost by cur2.line_item_usage_start_month"
    expected_time: "< 10 seconds"
    
  - name: "Service breakdown"  
    query: "cur2.total_unblended_cost by cur2.service_category"
    expected_time: "< 5 seconds"
    
  - name: "Account analysis"
    query: "cur2.total_unblended_cost by cur2.line_item_usage_account_name"
    expected_time: "< 8 seconds"
```

---

## 🏗️ PHASE 2: DIMENSIONAL MODEL DEPLOYMENT (OPTIONAL)

### Step 1: Deploy Dimensional Structure
```bash
# Deploy dimensional model files:
models/
├── aws_cur.model.lkml                    # Advanced model
└── explores/
    ├── cost_analysis_base.explore.lkml
    ├── reservation_analysis_base.explore.lkml
    ├── tag_governance_base.explore.lkml
    └── account_hierarchy_base.explore.lkml
    
views/
├── facts/cost_usage_fact.view.lkml
└── dimensions/
    ├── account_dimension.view.lkml
    ├── service_dimension.view.lkml
    ├── region_dimension.view.lkml
    └── tag_dimension.view.lkml
```

### Step 2: Configure Aggregate Tables
```sql
-- PDT Configuration for performance optimization
CREATE SCHEMA IF NOT EXISTS looker_scratch;

-- Enable PDT creation permissions
GRANT CREATE ON SCHEMA looker_scratch TO looker_service_account;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA looker_scratch TO looker_service_account;
```

---

## 🔐 PHASE 3: SECURITY & ACCESS CONTROL

### Step 1: Configure Access Grants
```yaml
# Access control validation:
access_grants:
  cur2_full_access:
    - user_attribute: "cur2_access_level"
    - test_users: ["admin@company.com", "finance.lead@company.com"]
    
  cur2_read_only:
    - user_attribute: "cur2_access_level" 
    - test_users: ["developer@company.com", "analyst@company.com"]
```

### Step 2: Test User Permissions
```bash
# Test access control with different user types:
1. Admin user: Should see all explores and accounts
2. Finance user: Should see all cost data, limited admin functions  
3. Developer user: Should see own account data only
4. Read-only user: Should see reports but not export raw data
```

---

## 📊 PHASE 4: DASHBOARD DEPLOYMENT

### Step 1: Deploy Executive Dashboards
```yaml
# Dashboard deployment order:
1. AWS Cost Executive Summary      # High-level metrics
2. Service Category Analysis       # Detailed breakdowns
3. Tag Governance Dashboard        # Compliance monitoring
4. Cost Optimization Dashboard     # Savings opportunities
```

### Step 2: Configure Dashboard Permissions
```yaml
# Dashboard access configuration:
executive_dashboards:
  - audience: "C-Level, Finance Directors"
  - refresh_schedule: "Daily at 6 AM"
  - email_alerts: "enabled"
  
operational_dashboards:
  - audience: "DevOps, Engineering Teams"
  - refresh_schedule: "Every 4 hours"
  - slack_integration: "enabled"
```

---

## ✅ VALIDATION CHECKLIST

### Functional Validation ✅
```bash
□ All explores load without errors
□ Measure calculations return expected results
□ Date filters work correctly across time zones
□ Drill-down functionality operates properly
□ Tag extraction returns proper values
□ Service categorization is accurate
□ Cost aggregations match source data
□ User permissions enforce correctly
```

### Performance Validation ✅  
```bash
□ Query response times meet SLA (< 30 seconds)
□ Dashboard load times acceptable (< 15 seconds)
□ PDT builds complete successfully
□ Cache invalidation works properly
□ Memory usage within allocated limits
□ No query timeouts or connection errors
```

### Data Quality Validation ✅
```bash
□ Total costs match AWS billing console
□ Account names and IDs are accurate
□ Service names align with AWS nomenclature
□ Date ranges cover expected periods
□ Currency calculations are correct
□ Tag data extraction is complete
```

---

## 🚨 TROUBLESHOOTING GUIDE

### Common Issues & Solutions

#### 1. Connection Errors
```bash
Error: "Could not connect to database"
Solution: 
- Verify Athena connection parameters
- Check IAM permissions for Looker service account
- Validate S3 results bucket permissions
- Test connection from Looker admin panel
```

#### 2. Performance Issues
```bash
Error: "Query timeout after 600 seconds"
Solution:
- Add date filters to limit query scope
- Enable aggregate table creation
- Partition large tables by billing_period
- Increase Looker instance resources
```

#### 3. Permission Errors
```bash
Error: "User does not have access to this explore"
Solution:
- Verify user attribute assignments
- Check access grant configurations
- Validate model-level permissions
- Test with different user roles
```

#### 4. Data Accuracy Issues
```bash
Error: "Totals don't match AWS console"
Solution:
- Verify CUR data is complete and current
- Check for time zone differences
- Validate currency conversion logic
- Compare aggregation periods
```

---

## 📊 MONITORING & MAINTENANCE

### Daily Monitoring
```yaml
daily_checks:
  - data_freshness: "Verify latest billing period data"
  - query_performance: "Monitor response times"
  - user_activity: "Track explore usage patterns"  
  - error_logs: "Check for system errors"
```

### Weekly Maintenance
```yaml
weekly_tasks:
  - pdt_optimization: "Review and optimize aggregate tables"
  - usage_analysis: "Identify most-used explores and measures"
  - performance_tuning: "Optimize slow-running queries"
  - user_feedback: "Collect and address user issues"
```

### Monthly Updates
```yaml
monthly_tasks:
  - aws_service_updates: "Check for new AWS services to categorize"
  - schema_validation: "Verify CUR schema hasn't changed"
  - access_review: "Audit user permissions and access levels"
  - documentation_updates: "Keep guides and help text current"
```

---

## 📞 SUPPORT & ESCALATION

### Support Tiers
```yaml
level_1_support:
  - scope: "Basic user questions, navigation help"
  - response_time: "2 business hours"
  - channels: ["Slack #looker-support", "Email"]
  
level_2_support:
  - scope: "Model modifications, performance issues"
  - response_time: "1 business day"
  - channels: ["Dedicated support queue"]
  
level_3_support:
  - scope: "Architecture changes, major customizations"
  - response_time: "3 business days"
  - channels: ["Engineering escalation"]
```

### Emergency Contacts
```yaml
production_issues:
  primary: "ops-team@company.com"
  secondary: "looker-admin@company.com"
  escalation: "engineering-lead@company.com"
  
data_accuracy_issues:
  primary: "finance-team@company.com"
  secondary: "data-engineering@company.com"
```

---

## 🏁 POST-DEPLOYMENT SUCCESS CRITERIA

### Week 1 Targets ✅
- [ ] 95% uptime with no critical errors
- [ ] < 30-second average query response time
- [ ] 80% of target users successfully log in
- [ ] Executive dashboards updating daily

### Month 1 Targets ✅  
- [ ] 200+ unique users accessing the model
- [ ] 500+ queries executed successfully
- [ ] Cost optimization opportunities identified
- [ ] Tag compliance improvement measurable

### Quarter 1 Targets ✅
- [ ] 10%+ improvement in cost visibility scores
- [ ] 5%+ increase in resource tag compliance
- [ ] Documented cost savings from insights
- [ ] User satisfaction rating > 4.0/5.0

---
