# GCP Billing Export to FinOps FOCUS Format - Comprehensive Mapping Guide

**Version:** 1.0  
**Last Updated:** 2025-11-17  
**FOCUS Version:** 1.0 / 1.1 / 1.2  
**GCP Export Type:** Detailed Usage Cost Export

---

## Table of Contents

1. [Overview](#overview)
2. [GCP Billing Export Schema](#gcp-billing-export-schema)
3. [FOCUS Specification Overview](#focus-specification-overview)
4. [Field-by-Field Mapping](#field-by-field-mapping)
5. [Complex Transformations](#complex-transformations)
6. [Service Category Mapping](#service-category-mapping)
7. [Commitment Discount Mapping](#commitment-discount-mapping)
8. [Credits Handling](#credits-handling)
9. [GCP-Specific Challenges](#gcp-specific-challenges)
10. [Data Quality Validation](#data-quality-validation)
11. [Implementation Guide](#implementation-guide)

---

## Overview

This document provides comprehensive mapping guidance for transforming Google Cloud Platform (GCP) billing export data into the FinOps Open Cost and Usage Specification (FOCUS) format. FOCUS is an open standard developed by the FinOps Foundation to provide consistent, normalized cloud billing data across multiple providers.

### Key Benefits

- **Multi-cloud normalization**: Standardize GCP costs alongside AWS, Azure, and Oracle
- **FinOps alignment**: Enable standard FinOps reporting and analysis
- **Tool compatibility**: Use FinOps tools that expect FOCUS format
- **Future-proof**: Align with industry standard for cloud billing

### Prerequisites

- **GCP Detailed Billing Export** enabled and exported to BigQuery
- **GCP Pricing Export** enabled (optional but recommended for accurate pricing)
- BigQuery access with appropriate permissions
- Understanding of GCP billing concepts (CUDs, SUDs, credits, etc.)

---

## GCP Billing Export Schema

### Core Identity Fields

| GCP Field | Type | Description |
|-----------|------|-------------|
| `billing_account_id` | STRING | Cloud Billing account ID |
| `project.id` | STRING | Project identifier |
| `project.number` | STRING | Internal project number |
| `project.name` | STRING | Project display name |
| `project.ancestry_numbers` | STRING | Resource hierarchy path |
| `project.ancestors` | STRUCT | Hierarchical structure with resource names |
| `project.labels` | STRUCT | Project-level key-value labels |

### Cost and Pricing Fields

| GCP Field | Type | Description |
|-----------|------|-------------|
| `cost` | FLOAT | Actual cost with negotiated discounts applied |
| `cost_at_list` | FLOAT | Cost at list price (pre-discount) |
| `currency` | STRING | Billing currency code |
| `currency_conversion_rate` | FLOAT | USD conversion rate |
| `price.effective_price` | FLOAT | Price after discounts |
| `price.tier_start_amount` | FLOAT | Tier pricing start amount |

### Usage Fields

| GCP Field | Type | Description |
|-----------|------|-------------|
| `usage.amount` | FLOAT | Quantity consumed |
| `usage.unit` | STRING | Base measurement unit |
| `usage.amount_in_pricing_units` | FLOAT | Quantity in pricing units |
| `usage.pricing_unit` | STRING | Pricing unit per Catalog API |

### Service and SKU Fields

| GCP Field | Type | Description |
|-----------|------|-------------|
| `service.id` | STRING | Service identifier (e.g., '6F81-5844-456A') |
| `service.description` | STRING | Human-readable service name (e.g., 'Compute Engine') |
| `sku.id` | STRING | SKU identifier |
| `sku.description` | STRING | Detailed SKU description |

### Time Fields

| GCP Field | Type | Description |
|-----------|------|-------------|
| `usage_start_time` | TIMESTAMP | Inclusive start of hourly window |
| `usage_end_time` | TIMESTAMP | Exclusive end of hourly window |
| `export_time` | TIMESTAMP | Data processing timestamp |
| `invoice.month` | STRING | Invoice month (YYYYMM format) |

### Resource Fields (Detailed Export Only)

| GCP Field | Type | Description |
|-----------|------|-------------|
| `resource.name` | STRING | Service-specific resource identifier |
| `resource.global_name` | STRING | Globally unique resource identifier |

### Credits Fields

| GCP Field | Type | Description |
|-----------|------|-------------|
| `credits.id` | STRING | Credit identifier or type description |
| `credits.full_name` | STRING | Human-readable credit name |
| `credits.type` | STRING | Credit type classification |
| `credits.amount` | FLOAT | Credit amount applied |

**GCP Credit Types:**
- `SUSTAINED_USAGE` - Automatic sustained use discounts
- `COMMITTED_USAGE` - Committed use discount credits
- `PROMOTION` - Promotional credits
- `FREE_TIER` - Free tier usage credits
- `DISCOUNT` - Other discount types

### Location Fields

| GCP Field | Type | Description |
|-----------|------|-------------|
| `location.location` | STRING | Primary location identifier |
| `location.country` | STRING | Country code |
| `location.region` | STRING | Region identifier |
| `location.zone` | STRING | Zone identifier |

### Labels and Tags

| GCP Field | Type | Description |
|-----------|------|-------------|
| `labels` | STRUCT | User-defined resource labels |
| `system_labels` | STRUCT | Auto-generated system labels |
| `tags` | STRUCT | Hierarchical tag bindings |

### Additional Fields

| GCP Field | Type | Description |
|-----------|------|-------------|
| `cost_type` | STRING | Line item classification: `regular`, `tax`, `adjustment`, `rounding error` |
| `invoice.publisher_type` | STRING | Transaction origin: `GOOGLE` or `PARTNER` |
| `adjustment_info` | STRUCT | Billing modification details |
| `transaction_type` | STRING | Seller transaction classification |

---

## FOCUS Specification Overview

### FOCUS Version Support

This mapping supports FOCUS 1.0, 1.1, and 1.2. Key differences:
- **FOCUS 1.0**: Initial GA release (June 2024)
- **FOCUS 1.1**: Enhanced commitment discount handling (November 2024)
- **FOCUS 1.2**: SaaS support additions (June 2025)

### FOCUS Column Categories

FOCUS 1.0+ includes 43+ core columns organized into categories:

#### Required Columns (MUST be present)

| Column | Category | Data Type |
|--------|----------|-----------|
| `ChargePeriodStart` | Timeframe | DATETIME |
| `ChargePeriodEnd` | Timeframe | DATETIME |
| `BillingPeriodStart` | Timeframe | DATETIME |
| `BillingPeriodEnd` | Timeframe | DATETIME |
| `BillingCurrency` | Billing | STRING |
| `ChargeCategory` | Charge | STRING |
| `ChargeClass` | Charge | STRING |
| `BilledCost` | Billing | DECIMAL |
| `EffectiveCost` | Billing | DECIMAL |

#### Recommended Columns

| Column | Category | Data Type | Purpose |
|--------|----------|-----------|---------|
| `ChargeFrequency` | Charge | STRING | How often charge occurs |
| `CommitmentDiscountId` | Commitment | STRING | Commitment identifier |
| `CommitmentDiscountType` | Commitment | STRING | Type of commitment |
| `CommitmentDiscountStatus` | Commitment | STRING | Commitment status |
| `ResourceId` | Resource | STRING | Resource identifier |
| `Tags` | Resource | JSON/STRING | Resource tags/labels |

#### Optional Columns

| Column | Category | Data Type | Purpose |
|--------|----------|-----------|---------|
| `ListCost` | Billing | DECIMAL | Cost at list price |
| `ContractedCost` | Billing | DECIMAL | Cost with contracted rates |
| `ServiceCategory` | Service | STRING | High-level service category |
| `ServiceName` | Service | STRING | Service name |
| `Region` | Location | STRING | Geographic region |
| `AvailabilityZone` | Location | STRING | Availability zone |

### FOCUS ChargeCategory Values

**Required values** (one of):
- `Usage` - Charges based on service consumption
- `Purchase` - Upfront charges not tied to usage
- `Tax` - Governmental/regulatory fees
- `Credit` - Vouchers or incentives
- `Adjustment` - Corrections or other charges

### FOCUS ChargeClass Values

- `Correction` - Correction to previously invoiced period
- `null` - Normal charge (not a correction)

### FOCUS PricingCategory Values

- `On-Demand` - Standard on-demand pricing
- `Committed` - Commitment-based pricing
- `Spot` - Spot/preemptible pricing
- `Dynamic` - Variable pricing

---

## Field-by-Field Mapping

### Account and Identity Columns

#### BillingAccountId

**FOCUS Column:** `BillingAccountId`  
**Data Type:** STRING  
**Required:** Yes  
**GCP Source:** `billing_account_id`

```sql
-- Direct mapping
billing_account_id AS BillingAccountId
```

**Notes:**
- Direct 1:1 mapping
- Format: Alphanumeric string (e.g., '01AB2C-34DE56-78FG90')
- No transformation needed

---

#### BillingAccountName

**FOCUS Column:** `BillingAccountName`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** Not directly available in export

```sql
-- Not available in standard export
-- Could be joined from Cloud Asset Inventory or set to NULL
NULL AS BillingAccountName
```

**Notes:**
- Not available in standard billing export
- Consider using external lookup table if needed
- Set to NULL if unavailable

---

#### SubAccountId

**FOCUS Column:** `SubAccountId`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** `project.id`

```sql
-- Use project ID as sub-account
project.id AS SubAccountId
```

**Notes:**
- GCP projects map to FOCUS sub-accounts
- This represents the cost attribution boundary

---

#### SubAccountName

**FOCUS Column:** `SubAccountName`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** `project.name`

```sql
-- Direct mapping
project.name AS SubAccountName
```

**Notes:**
- Human-readable project name
- May contain special characters

---

#### SubAccountType

**FOCUS Column:** `SubAccountType`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** Derived from project structure

```sql
-- Derive from project hierarchy
CASE 
  WHEN project.ancestry_numbers IS NOT NULL 
    AND ARRAY_LENGTH(SPLIT(project.ancestry_numbers, '/')) > 2
  THEN 'Folder'
  ELSE 'Project'
END AS SubAccountType
```

**Notes:**
- GCP has projects, folders, and organizations
- Map based on hierarchy depth

---

### Timeframe Columns

#### ChargePeriodStart

**FOCUS Column:** `ChargePeriodStart`  
**Data Type:** DATETIME  
**Required:** Yes  
**GCP Source:** `usage_start_time`

```sql
-- Direct mapping with timezone normalization
CAST(usage_start_time AS DATETIME) AS ChargePeriodStart
```

**Notes:**
- GCP uses hourly windows
- FOCUS requires inclusive start time
- Timezone: UTC (standard for GCP exports)

---

#### ChargePeriodEnd

**FOCUS Column:** `ChargePeriodEnd`  
**Data Type:** DATETIME  
**Required:** Yes  
**GCP Source:** `usage_end_time`

```sql
-- Direct mapping with timezone normalization
CAST(usage_end_time AS DATETIME) AS ChargePeriodEnd
```

**Notes:**
- FOCUS requires exclusive end time
- GCP usage_end_time is already exclusive
- Hourly granularity

---

#### BillingPeriodStart

**FOCUS Column:** `BillingPeriodStart`  
**Data Type:** DATETIME  
**Required:** Yes  
**GCP Source:** Derived from `invoice.month`

```sql
-- Convert YYYYMM to first day of month
PARSE_DATE('%Y%m', invoice.month) AS BillingPeriodStart
```

**Notes:**
- GCP invoices are monthly
- Start = first day of month at 00:00:00
- Inclusive boundary

---

#### BillingPeriodEnd

**FOCUS Column:** `BillingPeriodEnd`  
**Data Type:** DATETIME  
**Required:** Yes  
**GCP Source:** Derived from `invoice.month`

```sql
-- First day of next month (exclusive)
DATE_ADD(PARSE_DATE('%Y%m', invoice.month), INTERVAL 1 MONTH) AS BillingPeriodEnd
```

**Notes:**
- Exclusive boundary (first moment of next month)
- Aligns with GCP monthly invoicing

---

### Cost Columns

#### BilledCost

**FOCUS Column:** `BilledCost`  
**Data Type:** DECIMAL  
**Required:** Yes  
**GCP Source:** `cost` + `credits.amount` (sum)

```sql
-- Cost including credits (what you actually pay)
CAST(
  cost + IFNULL(
    (SELECT SUM(c.amount) 
     FROM UNNEST(credits) AS c), 
    0
  ) AS DECIMAL(18, 6)
) AS BilledCost
```

**Notes:**
- GCP separates base cost and credits
- FOCUS combines them into BilledCost
- Credits are negative values in GCP
- Must handle NULL credits array

**Edge Cases:**
- If `credits` is NULL or empty, use 0
- Round to 6 decimal places for currency precision
- Negative values possible for full credits

---

#### EffectiveCost

**FOCUS Column:** `EffectiveCost`  
**Data Type:** DECIMAL  
**Required:** Yes  
**GCP Source:** Complex calculation with amortization

```sql
-- Amortized cost including commitment amortization
-- For usage covered by commitments, allocate commitment cost
-- For regular usage, use actual cost
CAST(
  CASE
    -- If covered by CUD, allocate CUD cost
    WHEN REGEXP_CONTAINS(sku.description, r'Commitment') THEN cost
    -- Regular usage
    ELSE cost + IFNULL(
      (SELECT SUM(c.amount) 
       FROM UNNEST(credits) AS c
       WHERE c.type NOT IN ('SUSTAINED_USAGE', 'COMMITTED_USAGE')),
      0
    )
  END AS DECIMAL(18, 6)
) AS EffectiveCost
```

**Notes:**
- EffectiveCost represents amortized cost
- Includes commitment amortization
- Excludes automatic discounts (SUDs) for true amortized view
- Complex logic may need refinement based on commitment strategy

**Transformation Logic:**
1. For commitment charges: Use commitment cost directly
2. For usage covered by commitment: Allocate commitment cost proportionally
3. For regular usage: Use actual cost with promotional credits only

---

#### ListCost

**FOCUS Column:** `ListCost`  
**Data Type:** DECIMAL  
**Required:** No  
**GCP Source:** `cost_at_list`

```sql
-- Cost at list price (pre-discount)
CAST(IFNULL(cost_at_list, cost) AS DECIMAL(18, 6)) AS ListCost
```

**Notes:**
- Available since June 29, 2023
- Falls back to actual cost if not available
- Represents cost without any discounts

---

#### ContractedCost

**FOCUS Column:** `ContractedCost`  
**Data Type:** DECIMAL  
**Required:** No  
**GCP Source:** `cost` (with negotiated discount already applied)

```sql
-- Cost with negotiated rates (already in 'cost' field)
CAST(cost AS DECIMAL(18, 6)) AS ContractedCost
```

**Notes:**
- GCP `cost` field already includes negotiated discounts
- This is the contracted rate cost before credits

---

### Charge Classification Columns

#### ChargeCategory

**FOCUS Column:** `ChargeCategory`  
**Data Type:** STRING  
**Required:** Yes  
**GCP Source:** Derived from `cost_type`, `sku.description`, `credits`

```sql
-- Classify charge type
CASE
  -- Tax charges
  WHEN cost_type = 'tax' THEN 'Tax'
  
  -- Adjustment charges
  WHEN cost_type = 'adjustment' THEN 'Adjustment'
  WHEN cost_type = 'rounding error' THEN 'Adjustment'
  
  -- Credit entries (must have negative cost or be in credits array)
  WHEN cost < 0 OR ARRAY_LENGTH(credits) > 0 THEN 'Credit'
  
  -- Commitment purchases (CUD purchases)
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)commitment.*purchase') 
    OR REGEXP_CONTAINS(sku.description, r'(?i)committed use discount')
  THEN 'Purchase'
  
  -- Usage charges (default)
  ELSE 'Usage'
END AS ChargeCategory
```

**Allowed Values:**
- `Usage` - Service consumption charges
- `Purchase` - Upfront purchases (CUDs, support plans)
- `Tax` - Tax charges
- `Credit` - Credits applied
- `Adjustment` - Billing adjustments

**Notes:**
- Most GCP charges are 'Usage'
- CUD purchases map to 'Purchase'
- SUDs appear as credits
- Tax is explicitly flagged by `cost_type`

---

#### ChargeClass

**FOCUS Column:** `ChargeClass`  
**Data Type:** STRING  
**Required:** Yes  
**GCP Source:** Derived from `adjustment_info`, invoice timing

```sql
-- Identify corrections to prior periods
CASE
  WHEN adjustment_info IS NOT NULL 
    AND adjustment_info.mode = 'MANUAL_ADJUSTMENT'
    AND PARSE_DATE('%Y%m', invoice.month) > 
        DATE(usage_start_time)
  THEN 'Correction'
  ELSE NULL
END AS ChargeClass
```

**Notes:**
- NULL for regular charges (most common)
- 'Correction' for adjustments to prior billing periods
- GCP adjustments within the same period remain NULL

---

#### ChargeDescription

**FOCUS Column:** `ChargeDescription`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** `sku.description`

```sql
-- Use SKU description as charge description
sku.description AS ChargeDescription
```

**Notes:**
- Provides detailed charge description
- Often very descriptive in GCP (e.g., 'N1 Predefined Instance Ram running in Americas')

---

#### ChargeFrequency

**FOCUS Column:** `ChargeFrequency`  
**Data Type:** STRING  
**Required:** No (Recommended)  
**GCP Source:** Derived from charge pattern

```sql
-- Determine charge frequency
CASE
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)commitment') THEN 'Recurring'
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)subscription') THEN 'Recurring'
  WHEN cost_type = 'regular' THEN 'Usage-Based'
  ELSE 'One-Time'
END AS ChargeFrequency
```

**Allowed Values:**
- `Usage-Based` - Charged based on consumption
- `Recurring` - Regular recurring charges
- `One-Time` - One-time charges

---

### Pricing Columns

#### PricingCategory

**FOCUS Column:** `PricingCategory`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** Derived from `sku.description`

```sql
-- Classify pricing model
CASE
  -- Spot/Preemptible
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)preemptible') 
    OR REGEXP_CONTAINS(sku.description, r'(?i)spot')
  THEN 'Spot'
  
  -- Committed
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)commitment')
    OR REGEXP_CONTAINS(sku.description, r'(?i)committed')
  THEN 'Committed'
  
  -- Dynamic (flexible CUD)
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)flexible')
  THEN 'Dynamic'
  
  -- On-Demand (default)
  ELSE 'On-Demand'
END AS PricingCategory
```

**Allowed Values:**
- `On-Demand` - Standard on-demand pricing
- `Committed` - Commitment-based discount pricing
- `Spot` - Preemptible/Spot instances
- `Dynamic` - Flexible commitment discounts

---

#### PricingQuantity

**FOCUS Column:** `PricingQuantity`  
**Data Type:** DECIMAL  
**Required:** No  
**GCP Source:** `usage.amount_in_pricing_units`

```sql
-- Quantity used for pricing calculation
CAST(usage.amount_in_pricing_units AS DECIMAL(18, 6)) AS PricingQuantity
```

**Notes:**
- This is the quantity actually used for pricing
- May differ from ConsumedQuantity due to unit conversions

---

#### PricingUnit

**FOCUS Column:** `PricingUnit`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** `usage.pricing_unit`

```sql
-- Unit used for pricing
usage.pricing_unit AS PricingUnit
```

**Examples:**
- 'hour' - Compute instance hours
- 'gibibyte month' - Storage pricing
- 'requests' - API call pricing

---

### Usage/Consumption Columns

#### ConsumedQuantity

**FOCUS Column:** `ConsumedQuantity`  
**Data Type:** DECIMAL  
**Required:** No  
**GCP Source:** `usage.amount`

```sql
-- Actual usage amount
CAST(usage.amount AS DECIMAL(18, 6)) AS ConsumedQuantity
```

**Notes:**
- Base consumption measurement
- May differ from PricingQuantity

---

#### ConsumedUnit

**FOCUS Column:** `ConsumedUnit`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** `usage.unit`

```sql
-- Base usage unit
usage.unit AS ConsumedUnit
```

**Examples:**
- 'seconds' - Compute time
- 'byte-seconds' - Storage usage
- 'count' - API requests

---

### Service Columns

#### Provider

**FOCUS Column:** `Provider`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** Static value

```sql
-- Cloud provider name
'Google Cloud' AS Provider
```

**Notes:**
- Static value for all GCP records
- Alternatively use 'GCP' for brevity

---

#### Publisher

**FOCUS Column:** `Publisher`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** `invoice.publisher_type`

```sql
-- Publisher of the service
CASE 
  WHEN invoice.publisher_type = 'GOOGLE' THEN 'Google Cloud'
  WHEN invoice.publisher_type = 'PARTNER' THEN 'Google Cloud Marketplace'
  ELSE 'Google Cloud'
END AS Publisher
```

**Notes:**
- Distinguishes Google services from Marketplace services

---

#### ServiceName

**FOCUS Column:** `ServiceName`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** `service.description`

```sql
-- Service name
service.description AS ServiceName
```

**Examples:**
- 'Compute Engine'
- 'Cloud Storage'
- 'BigQuery'

---

#### ServiceCategory

**FOCUS Column:** `ServiceCategory`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** Derived from `service.id` or `service.description`

```sql
-- High-level service categorization
-- See Service Category Mapping section for complete logic
CASE
  WHEN service.description IN ('Compute Engine', 'Kubernetes Engine', 'Cloud Run', 'Cloud Functions', 'App Engine')
    THEN 'Compute'
  WHEN service.description IN ('Cloud Storage', 'Persistent Disk', 'Filestore', 'Cloud Storage for Firebase')
    THEN 'Storage'
  WHEN service.description IN ('Cloud SQL', 'Cloud Spanner', 'Cloud Bigtable', 'Firestore', 'Memorystore')
    THEN 'Database'
  WHEN service.description IN ('Cloud Load Balancing', 'Cloud CDN', 'Cloud DNS', 'Cloud NAT', 'Cloud VPN')
    THEN 'Networking'
  WHEN service.description IN ('BigQuery', 'Dataflow', 'Dataproc', 'Pub/Sub', 'Data Fusion')
    THEN 'Analytics'
  WHEN service.description IN ('Vertex AI', 'AI Platform', 'AutoML', 'Cloud Natural Language', 'Cloud Vision')
    THEN 'Machine Learning'
  WHEN service.description LIKE '%AI%' OR service.description LIKE '%ML%'
    THEN 'Machine Learning'
  ELSE 'Other'
END AS ServiceCategory
```

**Standard Categories:**
- Compute
- Storage
- Database
- Networking
- Analytics
- Machine Learning
- Security
- Developer Tools
- Other

---

### Resource Columns

#### ResourceId

**FOCUS Column:** `ResourceId`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** `resource.global_name` (detailed export only)

```sql
-- Globally unique resource identifier
resource.global_name AS ResourceId
```

**Notes:**
- Only available in detailed billing export
- NULL for standard export
- Format varies by resource type

---

#### ResourceName

**FOCUS Column:** `ResourceName`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** `resource.name` (detailed export only)

```sql
-- Service-specific resource name
resource.name AS ResourceName
```

**Notes:**
- Human-readable resource name
- May not be globally unique

---

#### ResourceType

**FOCUS Column:** `ResourceType`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** Derived from `sku.description`

```sql
-- Extract resource type from SKU description
CASE
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)n1') THEN 'Instance'
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)n2') THEN 'Instance'
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)e2') THEN 'Instance'
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)disk') THEN 'Disk'
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)storage') THEN 'Storage'
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)network') THEN 'Network'
  ELSE 'Other'
END AS ResourceType
```

**Notes:**
- Derived from SKU description patterns
- Not always precise

---

### Location Columns

#### Region

**FOCUS Column:** `Region`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** `location.region`

```sql
-- Geographic region
COALESCE(location.region, location.location) AS Region
```

**Notes:**
- Falls back to location.location if region not specified
- Examples: 'us-central1', 'europe-west1'

---

#### AvailabilityZone

**FOCUS Column:** `AvailabilityZone`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** `location.zone`

```sql
-- Zone identifier
location.zone AS AvailabilityZone
```

**Examples:**
- 'us-central1-a'
- 'europe-west1-b'

---

### SKU Columns

#### SkuId

**FOCUS Column:** `SkuId`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** `sku.id`

```sql
-- SKU identifier
sku.id AS SkuId
```

**Notes:**
- Unique SKU identifier
- Format: Alphanumeric (e.g., '6F81-5844-456A')

---

#### SkuPriceId

**FOCUS Column:** `SkuPriceId`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** Combination of `sku.id` and pricing tier

```sql
-- Combined SKU and price tier identifier
CONCAT(
  sku.id, 
  '-', 
  COALESCE(CAST(price.tier_start_amount AS STRING), '0')
) AS SkuPriceId
```

**Notes:**
- Combines SKU with price tier for unique pricing identifier
- Useful for tiered pricing analysis

---

### Tags Column

#### Tags

**FOCUS Column:** `Tags`  
**Data Type:** JSON/STRING  
**Required:** No  
**GCP Source:** `labels`, `project.labels`, `tags`, `system_labels`

```sql
-- Combine all labels into FOCUS Tags JSON format
TO_JSON_STRING(
  STRUCT(
    -- User resource labels
    (SELECT AS STRUCT * FROM UNNEST(
      ARRAY_CONCAT(
        -- Resource-level labels
        IFNULL((SELECT ARRAY_AGG(STRUCT(key, value)) 
                FROM UNNEST(labels) AS label), []),
        -- Project-level labels
        IFNULL((SELECT ARRAY_AGG(STRUCT(key, value)) 
                FROM UNNEST(project.labels) AS label), []),
        -- Tag bindings
        IFNULL((SELECT ARRAY_AGG(STRUCT(key, value)) 
                FROM UNNEST(tags) AS tag), [])
      )
    ))
  )
) AS Tags
```

**Alternative Simpler Format:**
```sql
-- Store as JSON string with key-value pairs
TO_JSON_STRING(
  (SELECT AS STRUCT 
    label.key, 
    label.value 
   FROM UNNEST(IFNULL(labels, [])) AS label)
) AS Tags
```

**Notes:**
- FOCUS expects tags as JSON or structured format
- Combine resource, project, and organizational tags
- GCP has multiple label types - consolidate them
- System labels can be included or excluded based on preference

**Label Normalization:**
- Convert all keys to lowercase
- Replace spaces with underscores
- Prefix system labels with 'gcp-system-' to distinguish

---

### Commitment Discount Columns

#### CommitmentDiscountId

**FOCUS Column:** `CommitmentDiscountId`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** Derived from credits or commitment SKU

```sql
-- Extract commitment ID from credits or commitment purchase
CASE
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)commitment') 
  THEN CONCAT('gcp-cud-', sku.id)
  
  WHEN ARRAY_LENGTH(credits) > 0 THEN (
    SELECT c.id 
    FROM UNNEST(credits) AS c 
    WHERE c.type = 'COMMITTED_USAGE'
    LIMIT 1
  )
  
  ELSE NULL
END AS CommitmentDiscountId
```

**Notes:**
- GCP doesn't always provide explicit commitment ID in billing
- Derive from SKU or credit information
- Prefix with 'gcp-cud-' for clarity

---

#### CommitmentDiscountName

**FOCUS Column:** `CommitmentDiscountName`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** `sku.description` or `credits.full_name`

```sql
-- Extract commitment name
CASE
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)commitment') 
  THEN sku.description
  
  WHEN ARRAY_LENGTH(credits) > 0 THEN (
    SELECT c.full_name 
    FROM UNNEST(credits) AS c 
    WHERE c.type = 'COMMITTED_USAGE'
    LIMIT 1
  )
  
  ELSE NULL
END AS CommitmentDiscountName
```

---

#### CommitmentDiscountType

**FOCUS Column:** `CommitmentDiscountType`  
**Data Type:** STRING  
**Required:** No (if commitment discounts supported)  
**GCP Source:** Derived from `sku.description`

```sql
-- Classify commitment type
CASE
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)compute.*commitment') 
    OR REGEXP_CONTAINS(sku.description, r'(?i)cpu.*commitment')
  THEN 'Compute'
  
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)memory.*commitment')
    OR REGEXP_CONTAINS(sku.description, r'(?i)ram.*commitment')
  THEN 'Memory'
  
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)flexible')
  THEN 'Spend'
  
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)commitment')
  THEN 'Resource'
  
  ELSE NULL
END AS CommitmentDiscountType
```

**GCP Commitment Types:**
- `Compute` - CPU-based CUDs
- `Memory` - RAM-based CUDs
- `Spend` - Spend-based CUDs (flexible)
- `Resource` - Resource-specific CUDs

---

#### CommitmentDiscountStatus

**FOCUS Column:** `CommitmentDiscountStatus`  
**Data Type:** STRING  
**Required:** No  
**GCP Source:** Not directly available

```sql
-- Default to 'Used' for applied commitments
CASE
  WHEN CommitmentDiscountId IS NOT NULL THEN 'Used'
  ELSE NULL
END AS CommitmentDiscountStatus
```

**Notes:**
- GCP billing export doesn't show commitment status directly
- Assume 'Used' for charges with commitment discount applied
- Unused commitment tracking requires separate analysis

---

---

## Complex Transformations

### ChargeCategory Detailed Logic

```sql
CASE
  -- 1. TAX: Explicit tax charges
  WHEN cost_type = 'tax' THEN 'Tax'
  
  -- 2. ADJUSTMENT: Billing adjustments
  WHEN cost_type IN ('adjustment', 'rounding error') THEN 'Adjustment'
  
  -- 3. CREDIT: Credits applied after the fact
  WHEN cost < 0 THEN 'Credit'
  WHEN ARRAY_LENGTH(credits) > 0 
    AND cost_type = 'regular'
  THEN 'Credit'
  
  -- 4. PURCHASE: Upfront commitment purchases
  WHEN REGEXP_CONTAINS(LOWER(sku.description), r'commitment.*purchase')
    OR REGEXP_CONTAINS(LOWER(sku.description), r'committed use discount purchase')
    OR (REGEXP_CONTAINS(LOWER(sku.description), r'commitment') 
        AND REGEXP_CONTAINS(LOWER(sku.description), r'fee'))
  THEN 'Purchase'
  
  -- 5. PURCHASE: Support plan fees
  WHEN REGEXP_CONTAINS(LOWER(sku.description), r'support')
    AND cost > 0
    AND usage.amount = 1
  THEN 'Purchase'
  
  -- 6. USAGE: Everything else (most common)
  ELSE 'Usage'
END AS ChargeCategory
```

**Decision Tree:**
1. Check `cost_type` for tax/adjustment
2. Check for negative costs or credit arrays
3. Check SKU description for purchase indicators
4. Default to 'Usage'

**Edge Cases:**
- Commitment discount **usage** = 'Usage' (applying the commitment)
- Commitment discount **purchase** = 'Purchase' (buying the commitment)
- Sustained use discounts = 'Credit' (automatic discounts)
- Free tier usage = may appear as 'Credit' or 'Usage' with zero cost

---

### Tag Transformation Logic

GCP has multiple labeling mechanisms that need consolidation:

#### Label Sources

1. **Resource labels** (`labels`) - User-defined labels on resources
2. **Project labels** (`project.labels`) - Labels on the project
3. **Tag bindings** (`tags`) - Hierarchical tags from organizations/folders
4. **System labels** (`system_labels`) - Auto-generated labels

#### Consolidated Tag Transformation

```sql
-- Create unified tag structure
WITH label_union AS (
  SELECT
    'resource' AS source,
    label.key AS tag_key,
    label.value AS tag_value
  FROM UNNEST(IFNULL(labels, [])) AS label
  
  UNION ALL
  
  SELECT
    'project' AS source,
    label.key AS tag_key,
    label.value AS tag_value
  FROM UNNEST(IFNULL(project.labels, [])) AS label
  
  UNION ALL
  
  SELECT
    'tag' AS source,
    tag.key AS tag_key,
    tag.value AS tag_value
  FROM UNNEST(IFNULL(tags, [])) AS tag
  
  UNION ALL
  
  SELECT
    'system' AS source,
    CONCAT('gcp-system-', label.key) AS tag_key,
    label.value AS tag_value
  FROM UNNEST(IFNULL(system_labels, [])) AS label
)
SELECT
  TO_JSON_STRING(
    (SELECT AS STRUCT tag_key, tag_value FROM label_union)
  ) AS Tags
```

**Tag Normalization Rules:**
1. Lowercase all keys
2. Replace spaces with underscores
3. Prefix system labels to distinguish them
4. Handle duplicate keys (last value wins)
5. Escape special JSON characters

---

### Pricing Category Detailed Logic

```sql
CASE
  -- SPOT: Preemptible/Spot instances
  WHEN REGEXP_CONTAINS(LOWER(sku.description), r'preemptible')
    OR REGEXP_CONTAINS(LOWER(sku.description), r'\bspot\b')
  THEN 'Spot'
  
  -- COMMITTED: Resources covered by CUD
  WHEN REGEXP_CONTAINS(LOWER(sku.description), r'commitment')
    OR REGEXP_CONTAINS(LOWER(sku.description), r'committed')
    OR EXISTS(
      SELECT 1 FROM UNNEST(IFNULL(credits, [])) AS c
      WHERE c.type = 'COMMITTED_USAGE'
    )
  THEN 'Committed'
  
  -- DYNAMIC: Flexible CUD (spend-based)
  WHEN REGEXP_CONTAINS(LOWER(sku.description), r'flexible commitment')
  THEN 'Dynamic'
  
  -- ON-DEMAND: Standard pricing (default)
  ELSE 'On-Demand'
END AS PricingCategory
```

**Classification Priority:**
1. Spot/Preemptible (highest priority - explicit in SKU)
2. Committed (identified by SKU or credits)
3. Dynamic (flexible commitments)
4. On-Demand (default fallback)

---

---

## Service Category Mapping

### Comprehensive Service Mapping

```sql
CASE
  -- COMPUTE
  WHEN service.description IN (
    'Compute Engine',
    'Kubernetes Engine',
    'Google Kubernetes Engine',
    'Cloud Run',
    'Cloud Functions',
    'App Engine',
    'App Engine Flexible Environment',
    'Cloud Composer'
  ) THEN 'Compute'
  
  -- STORAGE
  WHEN service.description IN (
    'Cloud Storage',
    'Persistent Disk',
    'Filestore',
    'Cloud Storage for Firebase',
    'Local SSD'
  ) THEN 'Storage'
  
  -- DATABASE
  WHEN service.description IN (
    'Cloud SQL',
    'Cloud Spanner',
    'Cloud Bigtable',
    'Firestore',
    'Firebase Realtime Database',
    'Memorystore for Redis',
    'Memorystore for Memcached',
    'Cloud Datastore'
  ) THEN 'Database'
  
  -- NETWORKING
  WHEN service.description IN (
    'Cloud Load Balancing',
    'Cloud CDN',
    'Cloud DNS',
    'Cloud NAT',
    'Cloud VPN',
    'Cloud Interconnect',
    'Cloud Armor',
    'Network Telemetry',
    'Network Intelligence Center',
    'Virtual Private Cloud'
  ) OR service.description LIKE '%Networking%'
  THEN 'Networking'
  
  -- ANALYTICS
  WHEN service.description IN (
    'BigQuery',
    'BigQuery Storage',
    'BigQuery Data Transfer Service',
    'Dataflow',
    'Dataproc',
    'Cloud Pub/Sub',
    'Cloud Data Fusion',
    'Cloud Dataprep',
    'Looker',
    'Looker Studio'
  ) THEN 'Analytics'
  
  -- MACHINE LEARNING / AI
  WHEN service.description IN (
    'Vertex AI',
    'AI Platform',
    'AutoML',
    'Cloud Natural Language',
    'Cloud Vision',
    'Cloud Speech-to-Text',
    'Cloud Text-to-Speech',
    'Cloud Translation',
    'Dialogflow',
    'Recommendations AI',
    'Cloud Inference API'
  ) OR service.description LIKE '%AI%'
    OR service.description LIKE '%ML%'
  THEN 'Machine Learning'
  
  -- SECURITY
  WHEN service.description IN (
    'Cloud Key Management Service',
    'Secret Manager',
    'Security Command Center',
    'Cloud Identity-Aware Proxy',
    'Cloud Armor',
    'Binary Authorization',
    'Certificate Authority Service',
    'Cloud HSM'
  ) OR service.description LIKE '%Security%'
  THEN 'Security'
  
  -- DEVELOPER TOOLS
  WHEN service.description IN (
    'Cloud Build',
    'Cloud Source Repositories',
    'Artifact Registry',
    'Container Registry',
    'Cloud Deploy',
    'Cloud Code'
  ) THEN 'Developer Tools'
  
  -- MANAGEMENT & MONITORING
  WHEN service.description IN (
    'Cloud Logging',
    'Cloud Monitoring',
    'Cloud Trace',
    'Cloud Profiler',
    'Cloud Debugger',
    'Error Reporting'
  ) THEN 'Management & Monitoring'
  
  -- MIGRATION
  WHEN service.description IN (
    'Transfer Appliance',
    'Storage Transfer Service',
    'Database Migration Service',
    'Cloud Data Transfer'
  ) THEN 'Migration'
  
  -- IOT
  WHEN service.description IN (
    'Cloud IoT Core'
  ) THEN 'IoT'
  
  -- API & INTEGRATION
  WHEN service.description IN (
    'Apigee',
    'Cloud Endpoints',
    'Cloud Tasks',
    'Cloud Scheduler',
    'Workflows'
  ) THEN 'API & Integration'
  
  -- SUPPORT
  WHEN service.description LIKE '%Support%'
  THEN 'Support'
  
  -- DEFAULT
  ELSE 'Other'
END AS ServiceCategory
```

### Service ID to Category Mapping

For more precise mapping using `service.id`:

```sql
CASE
  -- Compute
  WHEN service.id = '6F81-5844-456A' THEN 'Compute'  -- Compute Engine
  WHEN service.id = '29E7-DA93-CA13' THEN 'Compute'  -- Kubernetes Engine
  WHEN service.id = '152E-C115-5142' THEN 'Compute'  -- Cloud Run
  WHEN service.id = 'A1E8-BE35-7EBC' THEN 'Compute'  -- Cloud Functions
  WHEN service.id = 'F65E-AA4C-5304' THEN 'Compute'  -- App Engine
  
  -- Storage
  WHEN service.id = '95FF-2EF5-5EA1' THEN 'Storage'  -- Cloud Storage
  WHEN service.id = '048F-0962-24BB' THEN 'Storage'  -- Persistent Disk
  WHEN service.id = 'EF66-2626-B5F6' THEN 'Storage'  -- Filestore
  
  -- Database
  WHEN service.id = '9662-B51E-5089' THEN 'Database'  -- Cloud SQL
  WHEN service.id = '5490-F7F7-B8BC' THEN 'Database'  -- Cloud Spanner
  WHEN service.id = '032A-BAEA-C6B0' THEN 'Database'  -- Cloud Bigtable
  WHEN service.id = 'C661-F8D3-4860' THEN 'Database'  -- Firestore
  
  -- Networking
  WHEN service.id = '1E98-9354-B2C7' THEN 'Networking'  -- Cloud Load Balancing
  WHEN service.id = '15AA-3F45-2F7F' THEN 'Networking'  -- Cloud CDN
  WHEN service.id = 'C2E8-8FAF-4531' THEN 'Networking'  -- Cloud DNS
  
  -- Analytics
  WHEN service.id = '24E6-581D-38E5' THEN 'Analytics'  -- BigQuery
  WHEN service.id = '6701-7F31-6F48' THEN 'Analytics'  -- BigQuery Storage
  WHEN service.id = 'C878-8D81-FDE8' THEN 'Analytics'  -- Dataflow
  WHEN service.id = 'E505-1604-58F8' THEN 'Analytics'  -- Dataproc
  WHEN service.id = 'A1E8-BE35-7EBC' THEN 'Analytics'  -- Pub/Sub
  
  -- Machine Learning
  WHEN service.id = '3FC8-E8A7-73D8' THEN 'Machine Learning'  -- Vertex AI
  WHEN service.id = '6BF5-5CDB-22A0' THEN 'Machine Learning'  -- AI Platform
  
  -- Security
  WHEN service.id = '5490-F7F7-B8BC' THEN 'Security'  -- Cloud KMS
  WHEN service.id = 'E6F2-2F8F-9F4D' THEN 'Security'  -- Secret Manager
  
  -- Fallback to description-based mapping
  ELSE CASE
    WHEN service.description IN (...) THEN '...'
    ELSE 'Other'
  END
END AS ServiceCategory
```

**Note:** Service IDs may vary. Verify against your actual billing data.

---

---

## Commitment Discount Mapping

### GCP Commitment Types

GCP has two primary types of commitment-based discounts:

1. **Committed Use Discounts (CUDs)**
   - Resource-based: Commit to specific vCPU/memory amounts
   - Spend-based: Commit to minimum spend amount (flexible)
   - Term: 1-year or 3-year commitments
   - Discount: Up to 57% for compute, 70% for memory-optimized

2. **Sustained Use Discounts (SUDs)**
   - Automatic discounts (no commitment required)
   - Applied monthly based on usage duration
   - Up to 30% discount for sustained usage
   - Shown as credits in billing export

### Mapping to FOCUS

#### Committed Use Discounts (CUDs)

**Purchase Transaction:**
```sql
-- When purchasing a CUD
ChargeCategory = 'Purchase'
PricingCategory = 'Committed'
CommitmentDiscountId = 'gcp-cud-{subscription_id}'
CommitmentDiscountType = CASE
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)cpu|compute') THEN 'Compute'
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)memory|ram') THEN 'Memory'
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)flexible|spend') THEN 'Spend'
  ELSE 'Resource'
END
CommitmentDiscountStatus = 'Active'
```

**Usage Covered by CUD:**
```sql
-- When using resources covered by CUD
ChargeCategory = 'Usage'
PricingCategory = 'Committed'
CommitmentDiscountId = {same as purchase}
EffectiveCost = {amortized commitment cost}
BilledCost = {actual billed amount with CUD discount}
```

#### Sustained Use Discounts (SUDs)

SUDs are tricky because they're automatic discounts shown as credits:

```sql
-- SUD credit entry
ChargeCategory = 'Credit'
CommitmentDiscountId = NULL  -- Not a commitment
CommitmentDiscountType = NULL
-- Credit information in credits array
```

**Decision:** SUDs are **NOT** commitment discounts in FOCUS terms:
- They don't require upfront commitment
- They're automatic based on usage patterns
- Map them as 'Credit' ChargeCategory
- Do NOT populate CommitmentDiscountId

### Commitment Discount Transformation SQL

```sql
-- Identify and map commitment discounts
WITH commitment_info AS (
  SELECT
    *,
    -- Identify CUD purchases
    CASE
      WHEN REGEXP_CONTAINS(LOWER(sku.description), r'commitment.*purchase')
        OR REGEXP_CONTAINS(LOWER(sku.description), r'committed use discount purchase')
      THEN TRUE
      ELSE FALSE
    END AS is_cud_purchase,
    
    -- Identify usage covered by CUD
    CASE
      WHEN EXISTS(
        SELECT 1 FROM UNNEST(IFNULL(credits, [])) AS c
        WHERE c.type = 'COMMITTED_USAGE'
      ) THEN TRUE
      ELSE FALSE
    END AS is_cud_usage,
    
    -- Extract commitment ID
    CASE
      WHEN REGEXP_CONTAINS(LOWER(sku.description), r'commitment')
      THEN CONCAT('gcp-cud-', sku.id)
      WHEN EXISTS(
        SELECT 1 FROM UNNEST(IFNULL(credits, [])) AS c
        WHERE c.type = 'COMMITTED_USAGE'
      ) THEN (
        SELECT CONCAT('gcp-cud-', c.id)
        FROM UNNEST(credits) AS c
        WHERE c.type = 'COMMITTED_USAGE'
        LIMIT 1
      )
      ELSE NULL
    END AS commitment_id
  FROM `project.dataset.gcp_billing_export_resource_v1_XXXXXX`
)
SELECT
  -- Commitment fields
  commitment_id AS CommitmentDiscountId,
  
  CASE
    WHEN is_cud_purchase OR is_cud_usage THEN
      CASE
        WHEN REGEXP_CONTAINS(LOWER(sku.description), r'cpu|compute') THEN 'Compute'
        WHEN REGEXP_CONTAINS(LOWER(sku.description), r'memory|ram') THEN 'Memory'
        WHEN REGEXP_CONTAINS(LOWER(sku.description), r'flexible|spend') THEN 'Spend'
        ELSE 'Resource'
      END
    ELSE NULL
  END AS CommitmentDiscountType,
  
  CASE
    WHEN commitment_id IS NOT NULL THEN 'Used'
    ELSE NULL
  END AS CommitmentDiscountStatus,
  
  -- Charge categorization
  CASE
    WHEN is_cud_purchase THEN 'Purchase'
    WHEN is_cud_usage THEN 'Usage'
    ELSE {standard ChargeCategory logic}
  END AS ChargeCategory,
  
  CASE
    WHEN is_cud_purchase OR is_cud_usage THEN 'Committed'
    ELSE {standard PricingCategory logic}
  END AS PricingCategory
  
FROM commitment_info
```

---

---

## Credits Handling

### GCP Credit Types

GCP credits appear in the `credits` array with the following types:

| Credit Type | Description | FOCUS Mapping |
|-------------|-------------|---------------|
| `COMMITTED_USAGE` | Committed use discount credits | Part of commitment discount logic |
| `SUSTAINED_USAGE` | Sustained use discount credits | ChargeCategory = 'Credit' |
| `PROMOTION` | Promotional credits | ChargeCategory = 'Credit' |
| `FREE_TIER` | Free tier credits | ChargeCategory = 'Credit' |
| `DISCOUNT` | Other discount credits | ChargeCategory = 'Credit' |

### Credit Transformation Logic

```sql
-- Handle all credit types
WITH credits_expanded AS (
  SELECT
    * EXCEPT(credits),
    credit
  FROM `project.dataset.gcp_billing_export_resource_v1_XXXXXX`,
  UNNEST(IFNULL(credits, [])) AS credit
)
SELECT
  -- Separate credit handling
  CASE
    -- Committed use credits: Handled as commitment discount
    WHEN credit.type = 'COMMITTED_USAGE' THEN
      -- These should be merged with usage records, not separate credit records
      -- OR create separate credit entries with ChargeCategory = 'Credit'
      'Credit'
    
    -- Sustained use credits: Pure credits
    WHEN credit.type = 'SUSTAINED_USAGE' THEN 'Credit'
    
    -- Promotional credits: Pure credits
    WHEN credit.type = 'PROMOTION' THEN 'Credit'
    
    -- Free tier credits: Pure credits
    WHEN credit.type = 'FREE_TIER' THEN 'Credit'
    
    -- Other discount credits: Pure credits
    WHEN credit.type = 'DISCOUNT' THEN 'Credit'
    
    -- Default
    ELSE 'Credit'
  END AS ChargeCategory,
  
  -- Credit amount (negative in FOCUS for credits)
  credit.amount AS BilledCost,  -- Already negative in GCP
  credit.amount AS EffectiveCost,
  
  -- Credit description
  credit.full_name AS ChargeDescription,
  
  -- Credit metadata
  credit.type AS x_CreditType,  -- GCP-specific extension
  credit.id AS x_CreditId
  
FROM credits_expanded
WHERE credit IS NOT NULL
```

### Credit Application Order

GCP applies credits in this order:
1. Negotiated discounts (already in `cost` field)
2. Committed use discounts (as credits)
3. Sustained use discounts (as credits)
4. Spending-based discounts (as credits)
5. Promotional credits (as credits)

### Handling Credits in Cost Calculations

#### BilledCost Calculation

```sql
-- BilledCost = cost + all credits (credits are negative)
CAST(
  cost + IFNULL(
    (SELECT SUM(c.amount) FROM UNNEST(credits) AS c),
    0
  ) AS DECIMAL(18, 6)
) AS BilledCost
```

#### EffectiveCost Calculation

```sql
-- EffectiveCost = cost + non-automatic credits
-- Exclude SUDs for true amortized cost
CAST(
  cost + IFNULL(
    (SELECT SUM(c.amount) 
     FROM UNNEST(credits) AS c
     WHERE c.type NOT IN ('SUSTAINED_USAGE', 'COMMITTED_USAGE')),
    0
  ) AS DECIMAL(18, 6)
) AS EffectiveCost
```

**Rationale:**
- EffectiveCost should represent amortized cost
- Sustained use discounts are usage-based, not amortized
- Commitment discounts should be amortized across commitment period
- Promotional credits reduce effective cost

### Credit Record Structure

Option 1: **Separate Credit Records**
```sql
-- Create separate rows for credit entries
SELECT
  ChargeCategory = 'Credit',
  BilledCost = credit.amount,  -- Negative value
  EffectiveCost = credit.amount,
  ChargeDescription = credit.full_name,
  -- Other fields same as parent row
FROM billing_with_credits
CROSS JOIN UNNEST(credits) AS credit
```

Option 2: **Inline Credits (Recommended)**
```sql
-- Apply credits inline to usage records
-- No separate credit records
-- Credits reduce BilledCost and EffectiveCost
```

**Recommendation:** Use **inline credits** to avoid double-counting and simplify analysis.

---

---

## GCP-Specific Challenges

### Challenge 1: Nested Project Hierarchy

**Issue:** GCP has organizations → folders → projects hierarchy, but FOCUS has billing account → sub-account.

**Solution:**
```sql
-- Option 1: Use project as SubAccount
SubAccountId = project.id
SubAccountName = project.name

-- Option 2: Include folder path in tags
Tags = {
  'gcp-project-id': project.id,
  'gcp-project-name': project.name,
  'gcp-hierarchy-path': project.ancestry_numbers,
  'gcp-folder-id': SPLIT(project.ancestry_numbers, '/')[SAFE_OFFSET(1)]
}
```

**Recommendation:** Use project as SubAccount and add hierarchy to tags for drill-down analysis.

---

### Challenge 2: Multiple Credit Types

**Issue:** GCP has multiple credit types (SUDs, CUDs, promotional) that need different FOCUS treatment.

**Solution:**
- **CUD credits:** Handled as commitment discount (CommitmentDiscountId populated)
- **SUD credits:** ChargeCategory = 'Credit', no commitment fields
- **Promotional credits:** ChargeCategory = 'Credit'
- Store credit type in provider-specific column `x_CreditType`

---

### Challenge 3: Sustained Use Discounts (SUDs)

**Issue:** SUDs are automatic, usage-based discounts shown as credits. They're not commitments but affect pricing.

**Solution:**
```sql
-- SUD credits
ChargeCategory = 'Credit'
ChargeDescription = 'Sustained Use Discount'
CommitmentDiscountId = NULL  -- NOT a commitment
x_DiscountType = 'Sustained Use Discount'  -- GCP-specific field
```

**Important:** Do NOT treat SUDs as commitment discounts in FOCUS. They're credits.

---

### Challenge 4: Preemptible vs Spot VMs

**Issue:** GCP has both "Preemptible" (legacy) and "Spot" (new) terminology.

**Solution:**
```sql
-- Both map to 'Spot' in FOCUS
PricingCategory = CASE
  WHEN REGEXP_CONTAINS(sku.description, r'(?i)preemptible|spot')
  THEN 'Spot'
  ELSE 'On-Demand'
END
```

---

### Challenge 5: Export Delays and Data Freshness

**Issue:** GCP billing data can be delayed, and adjustments may appear in later exports.

**Solution:**
- Use `export_time` to track when data was exported
- Consider data up to 3 days delayed as normal
- Handle adjustments via ChargeClass = 'Correction'
- Implement incremental processing with deduplication

```sql
-- Deduplication logic
WITH latest_export AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY 
        billing_account_id,
        project.id,
        service.id,
        sku.id,
        usage_start_time,
        usage_end_time,
        cost_type
      ORDER BY export_time DESC
    ) AS rn
  FROM `project.dataset.gcp_billing_export_resource_v1_XXXXXX`
)
SELECT * EXCEPT(rn)
FROM latest_export
WHERE rn = 1
```

---

### Challenge 6: Invoice Reconciliation

**Issue:** Total in FOCUS must match GCP invoice totals.

**Solution:**
```sql
-- Validation query
SELECT
  invoice.month,
  SUM(cost) AS gcp_total_cost,
  SUM(cost + IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) AS c), 0)) AS gcp_billed_cost,
  
  -- Compare with FOCUS
  SUM(BilledCost) AS focus_billed_cost,
  
  -- Difference (should be ~0)
  SUM(BilledCost) - SUM(cost + IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) AS c), 0)) AS difference
  
FROM focus_view
GROUP BY invoice.month
HAVING ABS(difference) > 0.01  -- Flag differences > 1 cent
```

---

### Challenge 7: Commitment Discount Amortization

**Issue:** GCP shows commitment charges separately from usage. Need to amortize commitment cost across covered usage.

**Solution:**

**Step 1:** Calculate total commitment cost per commitment ID
```sql
WITH commitment_costs AS (
  SELECT
    DATE_TRUNC(usage_start_time, MONTH) AS month,
    REGEXP_EXTRACT(sku.description, r'Commitment v1: (.*) in (.*)') AS commitment_type,
    SUM(cost) AS total_commitment_cost
  FROM billing_export
  WHERE REGEXP_CONTAINS(sku.description, r'Commitment')
  GROUP BY month, commitment_type
)
```

**Step 2:** Allocate to covered usage
```sql
WITH covered_usage AS (
  SELECT
    *,
    -- Identify usage covered by commitment
    EXISTS(
      SELECT 1 FROM UNNEST(credits) AS c
      WHERE c.type = 'COMMITTED_USAGE'
    ) AS is_covered
  FROM billing_export
)
SELECT
  CASE
    WHEN is_covered THEN
      -- Allocate proportional commitment cost
      (commitment_costs.total_commitment_cost / total_covered_hours) * hours_used
    ELSE
      -- Regular cost
      cost
  END AS EffectiveCost
FROM covered_usage
LEFT JOIN commitment_costs USING (month)
```

**Simplified Approach:**
- Use `cost` field as EffectiveCost (includes commitment discount)
- Add commitment_cost for purchase entries
- This approximates amortization without complex logic

---

### Challenge 8: Label Key Collisions

**Issue:** Multiple label sources (resource, project, system) may have same keys.

**Solution:**
```sql
-- Prefix labels by source
WITH all_labels AS (
  SELECT 'resource' AS source, label.key, label.value
  FROM UNNEST(labels) AS label
  
  UNION ALL
  
  SELECT 'project' AS source, label.key, label.value
  FROM UNNEST(project.labels) AS label
  
  UNION ALL
  
  SELECT 'system' AS source, label.key, label.value
  FROM UNNEST(system_labels) AS label
)
SELECT
  TO_JSON_STRING(
    (SELECT AS STRUCT 
      CONCAT(source, ':', key) AS tag_key,
      value AS tag_value
     FROM all_labels)
  ) AS Tags
```

**Alternative:** Use precedence (resource > project > system) and keep last value.

---

---

## Data Quality Validation

### Validation Checks

#### 1. Required Fields Validation

```sql
-- Check for NULL in required FOCUS fields
SELECT
  COUNT(*) AS total_rows,
  COUNTIF(ChargePeriodStart IS NULL) AS missing_charge_period_start,
  COUNTIF(ChargePeriodEnd IS NULL) AS missing_charge_period_end,
  COUNTIF(BillingPeriodStart IS NULL) AS missing_billing_period_start,
  COUNTIF(BillingPeriodEnd IS NULL) AS missing_billing_period_end,
  COUNTIF(BillingCurrency IS NULL) AS missing_billing_currency,
  COUNTIF(ChargeCategory IS NULL) AS missing_charge_category,
  COUNTIF(BilledCost IS NULL) AS missing_billed_cost,
  COUNTIF(EffectiveCost IS NULL) AS missing_effective_cost
FROM focus_view
```

**Expected:** All counts should be 0.

---

#### 2. Cost Reconciliation

```sql
-- Compare GCP total with FOCUS total
WITH gcp_totals AS (
  SELECT
    invoice.month,
    SUM(cost + IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) AS c), 0)) AS gcp_billed_total
  FROM `project.dataset.gcp_billing_export_resource_v1_XXXXXX`
  GROUP BY invoice.month
),
focus_totals AS (
  SELECT
    FORMAT_DATE('%Y%m', BillingPeriodStart) AS month,
    SUM(BilledCost) AS focus_billed_total
  FROM focus_view
  GROUP BY month
)
SELECT
  gcp_totals.month,
  gcp_billed_total,
  focus_billed_total,
  gcp_billed_total - focus_billed_total AS difference,
  ABS((gcp_billed_total - focus_billed_total) / NULLIF(gcp_billed_total, 0)) * 100 AS percent_difference
FROM gcp_totals
JOIN focus_totals USING (month)
WHERE ABS(gcp_billed_total - focus_billed_total) > 0.01
ORDER BY month DESC
```

**Expected:** Difference < $0.01 per month (rounding tolerance).

---

#### 3. ChargeCategory Distribution

```sql
-- Validate ChargeCategory values
SELECT
  ChargeCategory,
  COUNT(*) AS row_count,
  SUM(BilledCost) AS total_cost,
  ROUND(SUM(BilledCost) / SUM(SUM(BilledCost)) OVER () * 100, 2) AS percent_of_total
FROM focus_view
GROUP BY ChargeCategory
ORDER BY total_cost DESC
```

**Expected Distribution (typical):**
- Usage: 85-95%
- Credit: 5-15%
- Purchase: <5%
- Tax: 1-3%
- Adjustment: <1%

---

#### 4. Credit Handling Validation

```sql
-- Ensure credits are properly included in BilledCost
WITH gcp_costs AS (
  SELECT
    billing_account_id,
    project.id AS project_id,
    usage_start_time,
    cost AS gcp_cost,
    IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) AS c), 0) AS gcp_credits,
    cost + IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) AS c), 0) AS gcp_billed_cost
  FROM `project.dataset.gcp_billing_export_resource_v1_XXXXXX`
)
SELECT
  gcp_costs.*,
  focus_view.BilledCost AS focus_billed_cost,
  ABS(gcp_costs.gcp_billed_cost - focus_view.BilledCost) AS difference
FROM gcp_costs
JOIN focus_view 
  ON gcp_costs.billing_account_id = focus_view.BillingAccountId
  AND gcp_costs.project_id = focus_view.SubAccountId
  AND gcp_costs.usage_start_time = focus_view.ChargePeriodStart
WHERE ABS(gcp_costs.gcp_billed_cost - focus_view.BilledCost) > 0.01
LIMIT 100
```

**Expected:** No rows (perfect match) or minimal differences due to rounding.

---

#### 5. Data Type Validation

```sql
-- Ensure all cost fields are numeric and properly formatted
SELECT
  COUNTIF(NOT REGEXP_CONTAINS(CAST(BilledCost AS STRING), r'^-?\d+\.?\d*$')) AS invalid_billed_cost,
  COUNTIF(NOT REGEXP_CONTAINS(CAST(EffectiveCost AS STRING), r'^-?\d+\.?\d*$')) AS invalid_effective_cost,
  COUNTIF(NOT REGEXP_CONTAINS(CAST(ListCost AS STRING), r'^-?\d+\.?\d*$')) AS invalid_list_cost,
  
  -- Validate date formats
  COUNTIF(ChargePeriodStart >= ChargePeriodEnd) AS invalid_charge_period,
  COUNTIF(BillingPeriodStart >= BillingPeriodEnd) AS invalid_billing_period,
  
  -- Validate currency codes
  COUNTIF(BillingCurrency NOT IN ('USD', 'EUR', 'GBP', 'JPY', 'INR', 'AUD', 'CAD')) AS invalid_currency
  
FROM focus_view
```

**Expected:** All counts should be 0.

---

#### 6. Commitment Discount Validation

```sql
-- Validate commitment discount fields are consistent
SELECT
  COUNTIF(CommitmentDiscountId IS NOT NULL AND CommitmentDiscountType IS NULL) AS missing_commitment_type,
  COUNTIF(CommitmentDiscountType IS NOT NULL AND CommitmentDiscountId IS NULL) AS missing_commitment_id,
  
  -- Validate PricingCategory alignment
  COUNTIF(CommitmentDiscountId IS NOT NULL AND PricingCategory != 'Committed') AS pricing_category_mismatch,
  
  -- Count commitment records
  COUNTIF(CommitmentDiscountId IS NOT NULL) AS total_commitment_records
  
FROM focus_view
```

**Expected:** 
- missing_commitment_type = 0
- missing_commitment_id = 0
- pricing_category_mismatch = 0

---

#### 7. Tag/Label Validation

```sql
-- Validate Tags are properly formatted JSON
SELECT
  COUNTIF(Tags IS NOT NULL AND NOT JSON_QUERY(Tags, '$') IS NULL) AS valid_tags,
  COUNTIF(Tags IS NOT NULL AND JSON_QUERY(Tags, '$') IS NULL) AS invalid_tags,
  COUNT(*) AS total_rows
FROM focus_view
```

**Expected:** invalid_tags = 0

---

### Continuous Monitoring

Set up automated daily checks:

```sql
-- Daily validation dashboard
CREATE OR REPLACE VIEW `project.dataset.focus_validation_dashboard` AS
WITH daily_stats AS (
  SELECT
    DATE(ChargePeriodStart) AS date,
    COUNT(*) AS total_records,
    SUM(BilledCost) AS total_billed_cost,
    SUM(EffectiveCost) AS total_effective_cost,
    COUNT(DISTINCT BillingAccountId) AS distinct_accounts,
    COUNT(DISTINCT SubAccountId) AS distinct_projects,
    COUNTIF(ChargeCategory = 'Usage') AS usage_records,
    COUNTIF(ChargeCategory = 'Credit') AS credit_records,
    COUNTIF(ChargeCategory = 'Purchase') AS purchase_records
  FROM focus_view
  WHERE ChargePeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
  GROUP BY date
)
SELECT
  date,
  total_records,
  ROUND(total_billed_cost, 2) AS total_billed_cost,
  ROUND(total_effective_cost, 2) AS total_effective_cost,
  distinct_accounts,
  distinct_projects,
  ROUND(usage_records / total_records * 100, 1) AS usage_percent,
  ROUND(credit_records / total_records * 100, 1) AS credit_percent,
  
  -- Day-over-day change
  total_billed_cost - LAG(total_billed_cost) OVER (ORDER BY date) AS cost_change,
  total_records - LAG(total_records) OVER (ORDER BY date) AS record_count_change
  
FROM daily_stats
ORDER BY date DESC
```

---

---

## Implementation Guide

### Step-by-Step Implementation

#### Step 1: Enable GCP Billing Exports

1. Navigate to **Billing** → **Billing export** in Google Cloud Console
2. Enable **Detailed Usage Cost Export** to BigQuery
3. (Optional) Enable **Pricing Export** for accurate list prices
4. Note the dataset and table name (format: `gcp_billing_export_resource_v1_<BILLING_ACCOUNT_ID>`)

---

#### Step 2: Create FOCUS View

See the companion SQL file: `gcp_billing_to_focus.sql`

```sql
-- Create FOCUS view
CREATE OR REPLACE VIEW `your-project.your-dataset.gcp_billing_focus_v1` AS
SELECT
  -- [Full transformation logic - see SQL file]
FROM `your-project.your-dataset.gcp_billing_export_resource_v1_XXXXXX`
WHERE usage_start_time >= '2024-01-01'  -- Adjust as needed
```

---

#### Step 3: Validate the Transformation

Run validation queries:

```bash
# Check required fields
bq query --use_legacy_sql=false < validation_required_fields.sql

# Check cost reconciliation
bq query --use_legacy_sql=false < validation_cost_reconciliation.sql

# Check data quality
bq query --use_legacy_sql=false < validation_data_quality.sql
```

---

#### Step 4: Incremental Processing (Optional)

For large datasets, implement incremental processing:

```sql
-- Incremental FOCUS materialized view
CREATE OR REPLACE TABLE `project.dataset.gcp_billing_focus_materialized`
PARTITION BY DATE(ChargePeriodStart)
CLUSTER BY BillingAccountId, SubAccountId, ServiceName
AS
SELECT * FROM `project.dataset.gcp_billing_focus_v1`
WHERE ChargePeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY);

-- Update daily
MERGE `project.dataset.gcp_billing_focus_materialized` AS target
USING `project.dataset.gcp_billing_focus_v1` AS source
ON target.BillingAccountId = source.BillingAccountId
  AND target.SubAccountId = source.SubAccountId
  AND target.ChargePeriodStart = source.ChargePeriodStart
  AND target.ChargeDescription = source.ChargeDescription
WHEN MATCHED THEN UPDATE SET *
WHEN NOT MATCHED THEN INSERT *;
```

---

#### Step 5: Create Looker Dashboard (Optional)

Use the [FOCUS Looker Template](https://cloud.google.com/looker/docs/focus-template) provided by Google Cloud.

---

#### Step 6: Schedule Validation Checks

```sql
-- Create scheduled query for daily validation
CREATE OR REPLACE PROCEDURE `project.dataset.validate_focus_daily`()
BEGIN
  DECLARE validation_passed BOOL DEFAULT TRUE;
  
  -- Run validation checks
  -- [Insert validation logic]
  
  -- Log results
  INSERT INTO `project.dataset.validation_log` (
    date,
    validation_name,
    passed,
    message
  ) VALUES (
    CURRENT_DATE(),
    'Daily FOCUS Validation',
    validation_passed,
    IF(validation_passed, 'All checks passed', 'Validation failed')
  );
END;

-- Schedule via Cloud Scheduler or BigQuery scheduled queries
```

---

### Performance Optimization

#### Partitioning

```sql
-- Partition by charge period start date
CREATE OR REPLACE TABLE `project.dataset.gcp_billing_focus_partitioned`
PARTITION BY DATE(ChargePeriodStart)
CLUSTER BY BillingAccountId, SubAccountId, ServiceName, ChargeCategory
AS
SELECT * FROM `project.dataset.gcp_billing_focus_v1`
```

**Benefits:**
- Faster queries filtering by date
- Lower query costs (less data scanned)
- Automatic partition expiration

---

#### Clustering

```sql
-- Cluster by commonly filtered columns
CLUSTER BY 
  BillingAccountId,
  SubAccountId,
  ServiceName,
  ChargeCategory,
  Region
```

**Benefits:**
- Faster queries filtering by clustered columns
- Better compression

---

#### Materialization Strategy

**Option 1: View (Simple)**
- Real-time data
- No additional storage cost
- Slower queries on large datasets

**Option 2: Materialized View**
- Updated automatically (up to hourly)
- Faster queries
- Additional storage cost

**Option 3: Scheduled Table Refresh**
- Full control over refresh schedule
- Fastest queries
- Highest storage cost

**Recommendation:** Start with a view, then materialize if query performance is inadequate.

---

### Cost Optimization

#### 1. Date Range Filtering

```sql
-- Only transform recent data
WHERE usage_start_time >= DATE_SUB(CURRENT_DATE(), INTERVAL 13 MONTH)
```

**Rationale:** Most analysis focuses on last 12 months + current month.

---

#### 2. Project Filtering

```sql
-- Exclude test/sandbox projects
WHERE project.id NOT IN ('test-project-1', 'sandbox-123')
```

---

#### 3. Cost Threshold Filtering

```sql
-- Exclude very small charges
WHERE ABS(cost) >= 0.01
```

**Rationale:** Sub-cent charges are rarely analyzed and create data volume.

---

### Troubleshooting

#### Issue: Cost Totals Don't Match

**Symptom:** FOCUS totals ≠ GCP invoice totals

**Causes:**
1. Missing credits in calculation
2. Double-counting credit entries
3. Incorrect date filtering
4. Currency conversion issues

**Solution:**
- Run cost reconciliation validation query
- Check credit handling logic
- Verify date range alignment with invoice period

---

#### Issue: Missing Commitment Discount Information

**Symptom:** CommitmentDiscountId is NULL for committed usage

**Causes:**
1. Credits array not properly unnested
2. Incorrect pattern matching in SKU description

**Solution:**
- Check credits array for COMMITTED_USAGE type
- Verify REGEXP patterns match your SKU descriptions
- Add logging to debug missing mappings

---

#### Issue: Invalid JSON in Tags Field

**Symptom:** Tags column has malformed JSON

**Causes:**
1. Special characters not escaped
2. NULL values not handled
3. Empty arrays creating invalid JSON

**Solution:**
```sql
-- Safe JSON generation
TO_JSON_STRING(
  IFNULL(
    (SELECT AS STRUCT * FROM UNNEST(labels)),
    STRUCT('' AS key, '' AS value)
  )
) AS Tags
```

---

## Summary

This comprehensive mapping guide provides:

✅ Complete field-by-field mapping from GCP to FOCUS  
✅ Complex transformation logic for charges, commitments, and credits  
✅ Service category mapping for all major GCP services  
✅ GCP-specific challenge solutions  
✅ Data quality validation queries  
✅ Implementation guide with optimization tips

### Next Steps

1. Review the companion SQL file: `bigquery/gcp_billing_to_focus.sql`
2. Customize the transformation for your specific needs
3. Validate the output against your GCP invoices
4. Set up automated validation checks
5. Create dashboards and reports using FOCUS-formatted data

### Additional Resources

- [FOCUS Specification](https://focus.finops.org/)
- [GCP Billing Export Documentation](https://cloud.google.com/billing/docs/how-to/export-data-bigquery)
- [Google Cloud FOCUS Guide](https://cloud.google.com/resources/google-cloud-focus)
- [FinOps Foundation](https://www.finops.org/)

---

**Document Version:** 1.0  
**Last Updated:** 2025-11-17  
**Maintained By:** AWS-CUR-2 FinOps Team
