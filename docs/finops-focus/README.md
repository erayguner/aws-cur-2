# AWS CUR 2.0 to FinOps FOCUS Transformation

Complete documentation and implementation resources for transforming AWS Cost and Usage Report (CUR) 2.0 data into the FinOps Open Cost and Usage Specification (FOCUS) format.

## 📚 Documentation Overview

This directory contains comprehensive resources for implementing FOCUS format transformation:

### Core Documentation

1. **[AWS_CUR_TO_FOCUS_MAPPING.md](./AWS_CUR_TO_FOCUS_MAPPING.md)**
   - Complete column mapping reference
   - Complex transformation logic
   - Service category mappings
   - Commitment discount handling
   - Data quality guidelines
   - **Start here** for understanding the mapping

2. **[IMPLEMENTATION_GUIDE.md](./IMPLEMENTATION_GUIDE.md)**
   - Step-by-step setup instructions
   - Validation procedures
   - BI tool integration
   - Troubleshooting tips
   - Best practices
   - **Follow this** for deployment

### SQL Resources

3. **[bigquery/aws_cur_to_focus.sql](./bigquery/aws_cur_to_focus.sql)**
   - Production-ready BigQuery SQL view
   - Implements all FOCUS 1.0 core columns (43)
   - Includes AWS extensions (5 x_* columns)
   - Optimized for performance
   - Fully commented and documented

4. **[bigquery/validation_queries.sql](./bigquery/validation_queries.sql)**
   - Comprehensive data quality checks
   - Cost reconciliation queries
   - Business logic validation
   - Data completeness reports
   - Run after transformation to ensure accuracy

## 🚀 Quick Start

### 1. Read the Documentation

```bash
# Review the mapping documentation
cat AWS_CUR_TO_FOCUS_MAPPING.md | less

# Read the implementation guide
cat IMPLEMENTATION_GUIDE.md | less
```

### 2. Customize the SQL

Edit `bigquery/aws_cur_to_focus.sql`:

```sql
-- Line 30: Update your source table
FROM `your-project.your-dataset.aws_cur_raw`

-- Line 1: Update view name
CREATE OR REPLACE VIEW `your-project.your-dataset.aws_cur_focus` AS
```

### 3. Deploy the View

```bash
# Using bq command-line tool
bq query --use_legacy_sql=false < bigquery/aws_cur_to_focus.sql

# Or copy/paste into BigQuery Console
```

### 4. Validate Data Quality

```bash
# Run validation queries
bq query --use_legacy_sql=false < bigquery/validation_queries.sql
```

### 5. Create Materialized Table (Optional but Recommended)

```sql
CREATE OR REPLACE TABLE `project.dataset.aws_cur_focus_materialized`
PARTITION BY DATE(BillingPeriodStart)
CLUSTER BY ServiceName, Region, SubAccountId
AS SELECT * FROM `project.dataset.aws_cur_focus`;
```

## 📊 What is FOCUS?

**FOCUS** (FinOps Open Cost and Usage Specification) is an open-source specification that provides:

- **Standardized schema** across cloud providers (AWS, Azure, GCP, Oracle)
- **Common terminology** for cloud billing concepts
- **Consistent metrics** for cost analysis
- **Industry support** from major cloud vendors and FinOps tools

### Why Use FOCUS?

- **Multi-cloud compatibility**: Single schema for all clouds
- **Tool interoperability**: Works with major FinOps platforms
- **Future-proof**: Actively maintained by FinOps Foundation
- **Best practices**: Incorporates industry standards

## 🎯 FOCUS Column Categories

### Required Columns (Must be present and non-null)
- `BilledCost` - Invoiced cost
- `ChargeCategory` - Usage, Purchase, Tax, Adjustment
- `ChargeDescription` - Human-readable description
- `BillingCurrency` - Currency code (e.g., USD)
- `BillingPeriodStart` / `BillingPeriodEnd` - Billing period

### Core Cost Columns (The Four Pillars)
- `BilledCost` - Actual invoiced amount
- `EffectiveCost` - Amortized cost with discounts
- `ListCost` - Public on-demand cost
- `ContractedCost` - Cost with contracted rates

### Identity Columns
- `BillingAccountId` / `BillingAccountName` - Payer account
- `SubAccountId` / `SubAccountName` - Usage account
- `ResourceId` / `ResourceName` - Resource identifiers

### Service & Geographic Columns
- `ServiceCategory` - High-level service type (Compute, Storage, etc.)
- `ServiceName` - AWS service code
- `Region` / `RegionName` - Geographic location
- `AvailabilityZone` - AZ identifier

### Commitment Discount Columns
- `CommitmentDiscountId` - RI or SP ARN
- `CommitmentDiscountType` - Reservation, Savings Plan
- `CommitmentDiscountStatus` - Used, Unused
- `CommitmentDiscountCategory` - Usage, Spend

### Pricing Columns
- `PricingCategory` - On-Demand, Reserved, Spot, Committed
- `PricingQuantity` / `PricingUnit` - Usage metrics
- `ContractedUnitPrice` / `ListUnitPrice` - Rate information

### AWS Extensions (x_* prefix)
- `x_Operation` - AWS operation detail
- `x_UsageType` - AWS usage type detail
- `x_ServiceCode` - AWS service code
- `x_CostCategories` - Cost allocation categories
- `x_Discounts` - Detailed discount information

## 📈 Example Queries

### Monthly Cost by Service

```sql
SELECT 
  ServiceCategory,
  ServiceName,
  ROUND(SUM(BilledCost), 2) AS total_cost,
  ROUND(SUM(EffectiveCost), 2) AS effective_cost
FROM `project.dataset.aws_cur_focus`
WHERE BillingPeriodStart >= DATE_TRUNC(CURRENT_DATE(), MONTH)
GROUP BY ServiceCategory, ServiceName
ORDER BY total_cost DESC;
```

### Commitment Discount Savings

```sql
SELECT 
  CommitmentDiscountType,
  ROUND(SUM(BilledCost), 2) AS billed,
  ROUND(SUM(EffectiveCost), 2) AS effective,
  ROUND(SUM(BilledCost - EffectiveCost), 2) AS savings,
  ROUND((SUM(BilledCost - EffectiveCost) / SUM(BilledCost)) * 100, 2) AS savings_pct
FROM `project.dataset.aws_cur_focus`
WHERE CommitmentDiscountId IS NOT NULL
GROUP BY CommitmentDiscountType;
```

### Cost by Account and Region

```sql
SELECT 
  SubAccountName,
  RegionName,
  ROUND(SUM(BilledCost), 2) AS total_cost
FROM `project.dataset.aws_cur_focus`
WHERE BillingPeriodStart = DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH), MONTH)
GROUP BY SubAccountName, RegionName
ORDER BY total_cost DESC
LIMIT 50;
```

## 🔍 Validation Checklist

After transformation, verify these key items:

- [ ] Row counts match (source vs FOCUS)
- [ ] Total costs reconcile (< 0.01% variance)
- [ ] No NULL values in required fields
- [ ] ChargeCategory values are valid
- [ ] ServiceCategory mapping is complete
- [ ] Commitment discounts are identified
- [ ] Geographic data is populated
- [ ] Tags are preserved as JSON
- [ ] Date ranges are correct
- [ ] Currency codes are valid (3 letters)

## 🛠️ Customization Guide

### Adding New Service Mappings

Update the ServiceCategory CASE statement in `aws_cur_to_focus.sql`:

```sql
CASE line_item_product_code
  -- Add your custom mapping
  WHEN 'YourNewService' THEN 'YourCategory'
  -- ... existing mappings ...
END AS ServiceCategory
```

### Custom Tag Extraction

Modify the tag_extraction CTE to add custom tag fields:

```sql
JSON_EXTRACT_SCALAR(resource_tags, '$.YourCustomTag') AS your_custom_field
```

### Regional Name Mapping

Enhance RegionName with friendly names:

```sql
CASE product_region_code
  WHEN 'us-east-1' THEN 'US East (N. Virginia)'
  WHEN 'us-west-2' THEN 'US West (Oregon)'
  -- Add more mappings
  ELSE product_location
END AS RegionName
```

## 📋 File Structure

```
docs/finops-focus/
├── README.md                           # This file
├── AWS_CUR_TO_FOCUS_MAPPING.md         # Complete mapping documentation
├── IMPLEMENTATION_GUIDE.md             # Step-by-step setup guide
└── bigquery/
    ├── aws_cur_to_focus.sql            # Transformation SQL view
    └── validation_queries.sql          # Data quality checks
```

## 🔗 External Resources

### FOCUS Specification
- [FOCUS Official Site](https://focus.finops.org/)
- [FOCUS v1.2 Specification](https://focus.finops.org/focus-specification/v1-2/)
- [FOCUS Column Library](https://focus.finops.org/focus-columns/)
- [FOCUS GitHub Repo](https://github.com/FinOps-Open-Cost-and-Usage-Spec/FOCUS_Spec)

### AWS Documentation
- [AWS CUR 2.0 Guide](https://docs.aws.amazon.com/cur/latest/userguide/)
- [AWS FOCUS Data Exports](https://docs.aws.amazon.com/cur/latest/userguide/table-dictionary-focus-1-0-aws.html)
- [CUR Line Item Details](https://docs.aws.amazon.com/cur/latest/userguide/Lineitem-columns.html)

### FinOps Resources
- [FinOps Foundation](https://www.finops.org/)
- [FinOps Framework](https://www.finops.org/framework/)
- [Cloud Cost Optimization](https://www.finops.org/insights/)

### BigQuery
- [BigQuery Documentation](https://cloud.google.com/bigquery/docs)
- [BigQuery Best Practices](https://cloud.google.com/bigquery/docs/best-practices)
- [Cost Optimization](https://cloud.google.com/bigquery/docs/best-practices-costs)

## 💡 Tips & Best Practices

### Performance
- ✅ Use partitioned tables (by BillingPeriodStart)
- ✅ Cluster by high-cardinality columns (ServiceName, Region, SubAccountId)
- ✅ Create materialized tables for frequent queries
- ✅ Filter by date in WHERE clauses
- ✅ Limit SELECT columns (avoid SELECT *)

### Data Quality
- ✅ Run validation queries after each data load
- ✅ Monitor cost reconciliation variance
- ✅ Check for unmapped services regularly
- ✅ Validate tag coverage
- ✅ Review ChargeCategory distribution

### Maintenance
- ✅ Keep SQL scripts in version control
- ✅ Document custom modifications
- ✅ Schedule regular data refreshes
- ✅ Monitor FOCUS specification updates
- ✅ Test changes on sample data first

### Cost Management
- ✅ Set up table expiration for old data
- ✅ Use appropriate retention periods
- ✅ Monitor BigQuery query costs
- ✅ Optimize queries before scheduling
- ✅ Use incremental updates when possible

## 🐛 Troubleshooting

### Common Issues

**Issue**: Cost totals don't match  
**Solution**: Check for NULL handling, currency conversion, filtering differences

**Issue**: Slow query performance  
**Solution**: Add partitioning, clustering, and date filters; use materialized tables

**Issue**: Missing ServiceCategory values  
**Solution**: Check for new AWS services; update mapping CASE statement

**Issue**: NULL required fields  
**Solution**: Review COALESCE logic; ensure source data quality

**Issue**: Duplicate rows  
**Solution**: Verify no duplicate transformations; check source data

## 📞 Support

For issues or questions:

1. Review the documentation in this directory
2. Check validation queries for data quality issues
3. Consult FOCUS specification at [focus.finops.org](https://focus.finops.org/)
4. Review AWS CUR documentation
5. Engage with FinOps community

## 📝 Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2025-11-17 | Initial comprehensive documentation | FinOps Engineering |

## 📄 License

This documentation and SQL code are provided as-is for use with AWS Cost and Usage Reports and FinOps FOCUS implementation.

---

**Maintained by**: FinOps Engineering Team  
**Last Updated**: 2025-11-17  
**FOCUS Version**: 1.2  
**AWS CUR Version**: 2.0
