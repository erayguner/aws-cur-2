# FinOps FOCUS (FinOps Open Cost and Usage Specification)
## Comprehensive Specification Document v1.2

**Document Version:** 1.2  
**FOCUS Specification Version:** 1.2 (Latest: May 29, 2025)  
**Last Updated:** 2025-11-17  
**Purpose:** Foundation for AWS CUR v2 and GCP billing export mapping

---

## Table of Contents

1. [FOCUS Overview](#1-focus-overview)
2. [Version History and Current State](#2-version-history-and-current-state)
3. [Governance Model](#3-governance-model)
4. [FOCUS Column Categories](#4-focus-column-categories)
5. [Core FOCUS Dimensions](#5-core-focus-dimensions)
6. [Data Quality Requirements](#6-data-quality-requirements)
7. [Multi-Cloud Benefits](#7-multi-cloud-benefits)
8. [Implementation Patterns](#8-implementation-patterns)
9. [Cloud Provider Mappings](#9-cloud-provider-mappings)
10. [Appendix: Reference Materials](#10-appendix-reference-materials)

---

## 1. FOCUS Overview

### 1.1 What is FOCUS?

The **FinOps Open Cost and Usage Specification (FOCUS™)** is an open technical specification for cloud billing data that defines clear requirements for cloud vendors to produce uniform cost and usage datasets.

**Key Definition:**  
> "An open specification for billing data that defines a common schema, terminology aligned with the FinOps Framework, and minimum requirements for consumption-based billing datasets."

### 1.2 Why FOCUS is Important

#### Business Value
- **Reduces Complexity:** Eliminates the need for proprietary normalization schemas
- **Enables Multi-Cloud Analysis:** Merge billing data from multiple Cloud Service Providers (CSPs) seamlessly
- **Improves Interoperability:** Standardized approach across AWS, Azure, GCP, Oracle, Alibaba, Tencent
- **Enhances Transparency:** Common vocabulary for cloud cost management
- **Supports Data-Driven Decisions:** Consistent metrics for cost optimization

#### Technical Value
- **Vendor-Neutral Schema:** Works across all major cloud providers
- **Optimized for Scale:** Designed for large-scale data analysis
- **Extensible Framework:** Supports custom provider-specific columns (x_ prefix)
- **ETL-Friendly:** Improved metadata for Extract Transform Load processes
- **Tool Compatibility:** Works with Looker, Tableau, PowerBI, and other BI platforms

### 1.3 Adoption Status

#### Cloud Providers Supporting FOCUS
- **Amazon Web Services (AWS)** - FOCUS 1.0 and 1.0-preview exports available
- **Microsoft Azure** - Full FOCUS 1.2-preview support with enhanced metadata
- **Google Cloud Platform (GCP)** - FOCUS BigQuery views and Looker templates
- **Oracle Cloud Infrastructure (OCI)** - FOCUS datasets available
- **Alibaba Cloud** - FOCUS support released
- **Tencent Cloud** - FOCUS datasets available

#### Industry Adoption
- **General Availability (GA):** June 2024
- **Contributing Organizations:** 50+ contributors
- **GitHub Activity:** 261 stars, 58 forks, 201 open issues
- **Version Releases:** v1.0 (June 2024), v1.1, v1.2 (May 2025)

---

## 2. Version History and Current State

### 2.1 Version Timeline

| Version | Release Date | Key Features |
|---------|--------------|--------------|
| **v0.5** | Pre-GA | Initial draft specification |
| **v1.0** | June 2024 | General Availability with 43 core columns |
| **v1.0-preview** | 2024 | AWS preview implementation |
| **v1.1** | 2024 | Added 4 new columns for capacity reservations and commitment tracking |
| **v1.2** | May 29, 2025 | SaaS/PaaS support, invoice reconciliation, deeper cloud allocation (105 total columns) |

### 2.2 FOCUS v1.0 - Core Release (43 Columns)

**Mandatory Columns:** 18  
**Conditional Columns:** 25  
**Focus:** Basic billing, cost, usage, and resource identification

### 2.3 FOCUS v1.1 - Commitment Enhancements (47 Columns)

**New Columns Added:**
1. **CapacityReservationId** (Conditional)
   - Type: String
   - Purpose: Identifier for capacity reservation allocation
   
2. **CapacityReservationStatus** (Conditional)
   - Type: String
   - Allowed Values: "Used" or "Unused"
   - Purpose: Indicates consumption status of capacity reservation

3. **CommitmentDiscountQuantity** (Conditional)
   - Type: Decimal
   - Purpose: Amount of commitment discount purchased or accounted for
   
4. **CommitmentDiscountUnit** (Conditional)
   - Type: String
   - Purpose: Measurement unit for commitment discount quantity

**Key Improvements:**
- Enhanced commitment discount tracking
- Better support for "chargeback for commitments" use cases
- Capacity optimization analysis capabilities

### 2.4 FOCUS v1.2 - Enterprise Features (105 Columns)

**Major Enhancements:**
- SaaS/PaaS service support
- Invoice reconciliation capabilities
- Deeper cloud allocation mechanisms
- ServiceSubcategory framework (2-tier service classification)
- Enhanced metadata for ETL processes

### 2.5 Versioning Approach

- **Semantic Versioning 2.0** compliance
- **RFC 2119/8174** requirement language (MUST, SHOULD, MAY)
- Layout changes are not versioned
- Backward compatibility is a goal but not strictly enforced

---

## 3. Governance Model

### 3.1 Project Structure

**Main Repository:**  
https://github.com/FinOps-Open-Cost-and-Usage-Spec/FOCUS_Spec

**Official Website:**  
https://focus.finops.org/

**Foundation:**  
FinOps Foundation (part of Linux Foundation)

### 3.2 Contributing Organizations

- **Founding Members:** AWS, Azure, Google Cloud
- **50+ Active Contributors**
- **Steering Committee:** Guides specification evolution
- **Working Groups:** Open Billing Standards Working Group

### 3.3 Contribution Process

- **Public GitHub Repository:** All changes tracked openly
- **Issue Tracking:** 201+ open issues for feature requests and clarifications
- **Pull Request Review:** Community-driven approval process
- **Charter and Legal:** Project charter and membership agreements in foundation repo

### 3.4 Compliance Requirements

To claim FOCUS compliance, implementations:
- **MUST** satisfy all mandatory column requirements
- **MUST** implement conditional columns when criteria apply
- **SHOULD** include recommended columns
- **MAY** add custom columns with "x_" prefix

---

## 4. FOCUS Column Categories

### 4.1 Overview of Column Types

FOCUS organizes billing data into logical categories, each serving specific analytical purposes.

### 4.2 Identification Columns

**Purpose:** Uniquely identify resources, services, and billing constructs

| Column | Type | Requirement | Description |
|--------|------|-------------|-------------|
| BillingAccountId | String | Mandatory | Provider-assigned billing account identifier |
| BillingAccountName | String | Conditional | Display name for billing account |
| SubAccountId | String | Conditional | Sub-account or department identifier |
| SubAccountName | String | Conditional | Display name for sub-account |
| ResourceId | String | Conditional | Unique resource identifier (e.g., ARM ID, ARN) |
| ResourceName | String | Conditional | Display name for resource |
| InvoiceIssuer | String | Mandatory | Entity responsible for invoicing |
| Provider | String | Mandatory | Entity making resources/services available |
| Publisher | String | Mandatory | Entity producing resources/services |

### 4.3 Date/Time Columns

**Purpose:** Track billing periods, charge periods, and usage time windows

| Column | Type | Requirement | Description | Format |
|--------|------|-------------|-------------|--------|
| BillingPeriodStart | DateTime | Mandatory | Inclusive start of billing period | ISO 8601 |
| BillingPeriodEnd | DateTime | Mandatory | Exclusive end of billing period | ISO 8601 |
| ChargePeriodStart | DateTime | Mandatory | Inclusive start of charge period | ISO 8601 |
| ChargePeriodEnd | DateTime | Mandatory | Exclusive end of charge period | ISO 8601 |

**Key Specifications:**
- **Format:** ISO 8601 standard (YYYY-MM-DDTHH:MM:SSZ)
- **v1.2:** Includes explicit seconds
- **Null Handling:** NOT NULL for mandatory date columns
- **Time Zones:** UTC recommended for consistency

**Charge Period Behavior:**
- Continuous usage: Matches dataset granularity (1 hour for hourly, 1 day for daily)
- Purchases: May span entire commitment period
- Adjustments: Reflects correction timeframe

### 4.4 Cost Columns (The Cost Cube)

**Purpose:** Provide multiple cost perspectives for comprehensive analysis

| Column | Type | Requirement | Description | Use Case |
|--------|------|-------------|-------------|----------|
| **BilledCost** | Decimal | Mandatory | Basis for invoicing, inclusive of discounts, excluding amortization | Invoice reconciliation |
| **ListCost** | Decimal | Mandatory | Cost at published list unit price | Savings analysis |
| **ContractedCost** | Decimal | Mandatory | Cost using negotiated unit price (after custom discounts) | Contract value tracking |
| **EffectiveCost** | Decimal | Mandatory | Amortized cost after all discounts and prepaid applications | True cost allocation |

**Cost Cube Relationships:**

```
ListCost (Public pricing)
    ↓ (Negotiated discounts)
ContractedCost (Your negotiated rate)
    ↓ (Commitment discounts: RIs, SPs)
BilledCost (Invoice amount)
    ↓ (Amortization of upfront purchases)
EffectiveCost (True unit economics)
```

**Numeric Format Requirements:**
- Type: Decimal
- Precision: Provider-specific (typically 10+ decimal places)
- Negative Values: Supported for corrections and credits
- Currency: Specified in BillingCurrency (ISO 4217)
- Null: NOT allowed for cost columns

### 4.5 Pricing Columns

**Purpose:** Track unit pricing and pricing models

| Column | Type | Requirement | Description |
|--------|------|-------------|-------------|
| ListUnitPrice | Decimal | Conditional | Published unit price per PricingUnit |
| ContractedUnitPrice | Decimal | Conditional | Negotiated unit price per PricingUnit |
| PricingQuantity | Decimal | Mandatory | Volume used or purchased for pricing |
| PricingUnit | String | Mandatory | Measurement unit for pricing (e.g., "Hours", "GB-Hours") |
| PricingCategory | String | Conditional | Pricing model classification |

**PricingCategory Allowed Values:**

| Value | Definition | Example |
|-------|------------|---------|
| **Standard** | Predetermined agreed rates | Pay-as-you-go at negotiated rate |
| **Dynamic** | Variable pricing determined by provider | Spot instances, surge pricing |
| **Committed** | Reduced rates via commitment discounts | Reserved Instance pricing |
| **Other** | Non-standard pricing models | Custom pricing agreements |
| *null* | No pricing model applies | Free tier usage |

**PricingQuantity Calculation:**
- For usage: `PricingQuantity = ConsumedQuantity ÷ PricingBlockSize`
- For purchases: Represents commitment quantity
- Azure example: `UsageQuantity ÷ x_PricingBlockSize = PricingQuantity`

### 4.6 Usage Columns

**Purpose:** Track actual resource consumption

| Column | Type | Requirement | Description |
|--------|------|-------------|-------------|
| ConsumedQuantity | Decimal | Conditional | Actual resource consumption amount |
| ConsumedUnit | String | Conditional | Measurement unit for consumption |

**Usage Metrics:**
- Compute: vCPU-Hours, Core-Hours
- Storage: GB-Month, GB-Hours
- Network: GB transferred, requests
- Database: DTU-Hours, RU-Hours

### 4.7 Resource Columns

**Purpose:** Identify and classify cloud resources

| Column | Type | Requirement | Description |
|--------|------|-------------|-------------|
| ResourceId | String | Conditional | Unique resource identifier |
| ResourceName | String | Conditional | Display name of resource |
| ResourceType | String | Conditional | Resource type classification |
| AvailabilityZone | String | Conditional | Physically isolated deployment area |
| RegionId | String | Conditional | Geographic region identifier |
| RegionName | String | Conditional | Display name for region |

**Resource Identification Patterns:**
- **AWS:** ARN (Amazon Resource Name) - `arn:aws:ec2:us-east-1:123456789012:instance/i-1234567890abcdef0`
- **Azure:** ARM Resource ID - `/subscriptions/{sub}/resourceGroups/{rg}/providers/{type}/{name}`
- **GCP:** Resource name - `projects/{project}/zones/{zone}/instances/{name}`

### 4.8 Service Columns

**Purpose:** Classify cloud services and offerings

| Column | Type | Requirement | Description |
|--------|------|-------------|-------------|
| ServiceName | String | Mandatory | Name of service offering purchased |
| ServiceCategory | String | Mandatory | High-level service classification |
| ServiceSubcategory | String | Conditional (v1.1+) | Secondary service classification |

**ServiceCategory - 19 Allowed Values:**

| Category | Description | Examples |
|----------|-------------|----------|
| **AI and Machine Learning** | AI/ML services and platforms | SageMaker, Azure ML, Vertex AI |
| **Analytics** | Data analytics and warehousing | Redshift, Synapse, BigQuery |
| **Business Applications** | Enterprise applications | Dynamics 365, Workspace |
| **Compute** | Virtual machines and compute | EC2, Virtual Machines, Compute Engine |
| **Databases** | Managed database services | RDS, Cosmos DB, Cloud SQL |
| **Developer Tools** | Development and CI/CD | CodeBuild, DevOps, Cloud Build |
| **Identity** | Identity and access management | IAM, Active Directory, Identity |
| **Integration** | Application integration | EventBridge, Logic Apps, Pub/Sub |
| **Internet of Things** | IoT platforms | IoT Core, IoT Hub, IoT Core |
| **Management and Governance** | Monitoring and management | CloudWatch, Monitor, Operations |
| **Media** | Media processing services | Elemental, Media Services, Transcoder |
| **Migration** | Migration tools | DMS, Migrate, Transfer |
| **Mobile** | Mobile development | Amplify, App Service, Firebase |
| **Multicloud** | Multi-cloud services | Anthos, Arc |
| **Networking** | Network services | VPC, Virtual Network, VPC |
| **Security** | Security services | GuardDuty, Defender, Security Command |
| **Storage** | Object and block storage | S3, Blob Storage, Cloud Storage |
| **Web** | Web hosting and CDN | CloudFront, Front Door, Cloud CDN |
| **Other** | Services not fitting other categories | Miscellaneous services |

**ServiceSubcategory Framework (v1.1+):**

Two-tier classification for granular analysis. Example for **Compute**:
- Containers (ECS, AKS, GKE)
- End User Computing (WorkSpaces, AVD)
- Quantum Compute (Braket, Azure Quantum)
- Serverless Compute (Lambda, Functions, Cloud Functions)
- Virtual Machines (EC2, VMs, Compute Engine)
- Other (Compute)

**ServiceName vs ServiceCategory:**
- **ServiceName:** Provider's specific offering (e.g., "Amazon EC2", "Azure Virtual Machines")
- **ServiceCategory:** Universal classification (e.g., "Compute")
- **ServiceSubcategory:** Refined classification (e.g., "Virtual Machines")

### 4.9 SKU Columns

**Purpose:** Link to provider pricing catalogs

| Column | Type | Requirement | Description |
|--------|------|-------------|-------------|
| SkuId | String | Conditional | Unique SKU identifier for catalog lookup |
| SkuPriceId | String | Conditional | Specific price point within SKU |

**SKU Patterns:**
- **AWS:** SKU format - `YTZ4RZWGMCMP5KND` (opaque)
- **Azure:** SKU Meter ID - GUID format
- **GCP:** SKU ID - `services/{service}/skus/{sku}`

### 4.10 Commitment Discount Columns

**Purpose:** Track Reserved Instances, Savings Plans, and other commitment-based discounts

| Column | Type | Requirement | Description |
|--------|------|-------------|-------------|
| CommitmentDiscountId | String | Conditional | Identifier for commitment discount |
| CommitmentDiscountName | String | Conditional | Display name for commitment |
| CommitmentDiscountType | String | Conditional | Specific commitment type label |
| CommitmentDiscountCategory | String | Conditional | Usage or Spend based |
| CommitmentDiscountStatus | String | Conditional | Usage tracking status |
| CommitmentDiscountQuantity | Decimal | Conditional (v1.1+) | Commitment amount purchased |
| CommitmentDiscountUnit | String | Conditional (v1.1+) | Unit of measurement for commitment |
| CapacityReservationId | String | Conditional (v1.1+) | Capacity reservation identifier |
| CapacityReservationStatus | String | Conditional (v1.1+) | "Used" or "Unused" |

**CommitmentDiscountCategory Values:**

| Value | Definition | Examples |
|-------|------------|----------|
| **Usage** | Usage-based commitments | Reserved Instances (AWS), Reserved VM Instances (Azure), Committed Use Discounts (GCP) |
| **Spend** | Spend-based commitments | Savings Plans (AWS, Azure), Flexible Committed Use (GCP) |

**CommitmentDiscountStatus Values:**
- **Used:** Commitment discount was applied to this charge
- **Unused:** Represents unused portion of commitment
- **null:** Not a commitment-related charge

**CapacityReservationStatus Values (v1.1+):**
- **Used:** Capacity reservation was consumed
- **Unused:** Capacity reservation went unused
- **null:** Not a capacity reservation charge

**Commitment Tracking Patterns:**

1. **Purchase Row:** Initial commitment purchase
   - ChargeCategory: "Purchase"
   - BilledCost: Upfront amount paid
   - CommitmentDiscountQuantity: Amount purchased
   
2. **Usage Row:** Commitment applied to usage
   - ChargeCategory: "Usage"
   - PricingCategory: "Committed"
   - CommitmentDiscountId: Links to purchase
   
3. **Amortization Row:** Spreading upfront cost
   - EffectiveCost: Allocated portion
   - CommitmentDiscountStatus: "Used" or "Unused"

### 4.11 Charge Classification Columns

**Purpose:** Categorize the nature of charges

| Column | Type | Requirement | Description |
|--------|------|-------------|-------------|
| ChargeDescription | String | Mandatory | Self-contained charge summary |
| ChargeCategory | String | Mandatory | Usage, Purchase, Tax, Credit, or Adjustment |
| ChargeClass | String | Mandatory | "Correction" only, else null |
| ChargeFrequency | String | Conditional | How often charge occurs |

**ChargeCategory - 5 Allowed Values:**

| Value | Definition | Examples |
|-------|------------|---------|
| **Usage** | Charge based on consumption over a period | EC2 instance hours, storage GB-months |
| **Purchase** | Service acquisition not tied to usage | Reserved Instance purchase, Support plan |
| **Tax** | Governmental or regulatory fees | Sales tax, VAT, GST |
| **Credit** | Vouchers or incentives | Promotional credits, SLA credits |
| **Adjustment** | Other charges not fitting above categories | Billing corrections, rounding |

**ChargeClass Values:**
- **"Correction":** Refunds, cancellations, or billing adjustments for previous periods
- **null:** Not a correction OR correction within current billing period

**Key Insight:**  
"FOCUS can convey usage refunds separately from purchase refunds" - enabling granular refund analysis.

**ChargeFrequency Values:**
- **"Recurring":** Repeating charges (e.g., monthly support)
- **"One-Time":** Single occurrence (e.g., RI purchase)
- **"Usage-Based":** Variable based on consumption
- **null:** No defined frequency

### 4.12 Tags and Metadata Columns

**Purpose:** User-defined resource categorization

| Column | Type | Requirement | Description |
|--------|------|-------------|-------------|
| Tags | JSON | Conditional | Key-value pairs for resource tagging |

**Tag Format Requirements:**
- **Type:** JSON object
- **Structure:** `{"key1": "value1", "key2": "value2"}`
- **Provider Prefixes:** Supported (e.g., `{"aws:CreatedBy": "user@example.com"}`)
- **Case Sensitivity:** Keys are case-sensitive
- **Null Handling:** Can be null if no tags exist

**Common Tag Patterns:**
```json
{
  "Environment": "Production",
  "CostCenter": "Engineering",
  "Project": "DataPipeline",
  "Owner": "team-data@company.com",
  "aws:CreatedBy": "arn:aws:iam::123456789012:user/john"
}
```

### 4.13 Currency Columns

**Purpose:** Handle multi-currency billing

| Column | Type | Requirement | Description |
|--------|------|-------------|-------------|
| BillingCurrency | String | Mandatory | ISO 4217 currency code used for billing |

**BillingCurrency Specifications:**
- **Format:** ISO 4217 three-letter codes
- **Examples:** USD, EUR, GBP, JPY, CNY, INR
- **Null:** NOT allowed
- **Consistency:** All cost values in row use this currency

**Multi-Currency Handling:**
- **Pricing Currency:** May differ from billing currency
- **Exchange Rates:** Provider-specific conversion (Azure: `x_BillingExchangeRate`)
- **Conversion:** `BilledCost = (PricingCost × ExchangeRate)`

---

## 5. Core FOCUS Dimensions

### 5.1 Complete Column Reference

This section provides an exhaustive reference of all FOCUS columns with detailed specifications.

#### 5.1.1 Billing Account & Period Columns

| Column Name | Type | Requirement | Null | Description | Examples |
|-------------|------|-------------|------|-------------|----------|
| **BillingAccountId** | String | Mandatory | NOT NULL | Provider-assigned identifier for billing account | AWS: 123456789012<br>Azure: EA/MCA account ID<br>GCP: Billing account ID |
| **BillingAccountName** | String | Conditional | Nullable | Display name for billing account | "Production Account"<br>"Dev Team Subscription" |
| **BillingCurrency** | String | Mandatory | NOT NULL | ISO 4217 currency code | USD, EUR, GBP, JPY |
| **BillingPeriodStart** | DateTime | Mandatory | NOT NULL | Inclusive start of billing period | 2025-01-01T00:00:00Z |
| **BillingPeriodEnd** | DateTime | Mandatory | NOT NULL | Exclusive end of billing period | 2025-02-01T00:00:00Z |

#### 5.1.2 Sub-Account Columns

| Column Name | Type | Requirement | Null | Description | Examples |
|-------------|------|-------------|------|-------------|----------|
| **SubAccountId** | String | Conditional | Nullable | Sub-account grouping identifier | AWS: Account ID in Org<br>Azure: Subscription ID<br>GCP: Project ID |
| **SubAccountName** | String | Conditional | Nullable | Display name for sub-account | "API-Services"<br>"Marketing-Analytics" |

#### 5.1.3 Charge Columns

| Column Name | Type | Requirement | Null | Description | Examples |
|-------------|------|-------------|------|-------------|----------|
| **ChargeCategory** | String | Mandatory | NOT NULL | Usage, Purchase, Tax, Credit, Adjustment | "Usage", "Purchase" |
| **ChargeClass** | String | Mandatory | Nullable | "Correction" for refunds, else null | "Correction", null |
| **ChargeDescription** | String | Mandatory | NOT NULL | Self-contained charge summary | "USD 0.10 per GB - first 10 TB / month data transfer" |
| **ChargeFrequency** | String | Conditional | Nullable | How often charge occurs | "Recurring", "One-Time", "Usage-Based" |
| **ChargePeriodStart** | DateTime | Mandatory | NOT NULL | Inclusive start of charge period | 2025-01-15T00:00:00Z |
| **ChargePeriodEnd** | DateTime | Mandatory | NOT NULL | Exclusive end of charge period | 2025-01-15T01:00:00Z |

#### 5.1.4 Cost Columns

| Column Name | Type | Requirement | Null | Description | Formula / Notes |
|-------------|------|-------------|------|-------------|-----------------|
| **BilledCost** | Decimal | Mandatory | NOT NULL | Invoice basis, includes discounts, excludes amortization | What you see on invoice |
| **EffectiveCost** | Decimal | Mandatory | NOT NULL | Amortized cost after all discounts and prepaid | True economic cost |
| **ListCost** | Decimal | Mandatory | NOT NULL | Cost at public list price | ListUnitPrice × PricingQuantity |
| **ContractedCost** | Decimal | Mandatory | NOT NULL | Cost at negotiated rate | ContractedUnitPrice × PricingQuantity |

#### 5.1.5 Usage Columns

| Column Name | Type | Requirement | Null | Description | Examples |
|-------------|------|-------------|------|-------------|----------|
| **ConsumedQuantity** | Decimal | Conditional | Nullable | Actual resource consumption | 24.5 (hours), 1024.0 (GB) |
| **ConsumedUnit** | String | Conditional | Nullable | Unit of consumed quantity | "Hours", "GB", "Requests" |

#### 5.1.6 Pricing Columns

| Column Name | Type | Requirement | Null | Description | Examples |
|-------------|------|-------------|------|-------------|----------|
| **PricingCategory** | String | Conditional | Nullable | Standard, Dynamic, Committed, Other | "Standard", "Committed" |
| **PricingQuantity** | Decimal | Mandatory | NOT NULL | Volume for pricing calculation | 1.0, 730.0 |
| **PricingUnit** | String | Mandatory | NOT NULL | Measurement unit for pricing | "Hours", "GB-Hours", "1000 Requests" |
| **ListUnitPrice** | Decimal | Conditional | Nullable | Public list price per unit | 0.096, 0.023 |
| **ContractedUnitPrice** | Decimal | Conditional | Nullable | Negotiated price per unit | 0.085, 0.020 |

#### 5.1.7 Provider Columns

| Column Name | Type | Requirement | Null | Description | Examples |
|-------------|------|-------------|------|-------------|----------|
| **Provider** | String | Mandatory | NOT NULL | Entity making resources available | "AWS", "Azure", "GCP" |
| **Publisher** | String | Mandatory | NOT NULL | Entity producing the service | "Microsoft", "HashiCorp", "MongoDB" |
| **InvoiceIssuer** | String | Mandatory | NOT NULL | Entity responsible for invoicing | "Amazon Web Services", "Microsoft" |

#### 5.1.8 Region and Availability Columns

| Column Name | Type | Requirement | Null | Description | Examples |
|-------------|------|-------------|------|-------------|----------|
| **RegionId** | String | Conditional | Nullable | Geographic region identifier | AWS: us-east-1<br>Azure: eastus<br>GCP: us-central1 |
| **RegionName** | String | Conditional | Nullable | Display name for region | "US East (N. Virginia)"<br>"East US" |
| **AvailabilityZone** | String | Conditional | Nullable | Physically isolated area | "us-east-1a", "eastus-1" |

#### 5.1.9 Resource Columns

| Column Name | Type | Requirement | Null | Description | Examples |
|-------------|------|-------------|------|-------------|----------|
| **ResourceId** | String | Conditional | Nullable | Unique resource identifier | ARN, ARM ID, GCP resource name |
| **ResourceName** | String | Conditional | Nullable | Display name of resource | "web-server-01", "prod-db" |
| **ResourceType** | String | Conditional | Nullable | Resource type classification | "AWS::EC2::Instance"<br>"Microsoft.Compute/virtualMachines" |

#### 5.1.10 Service Columns

| Column Name | Type | Requirement | Null | Description | Examples |
|-------------|------|-------------|------|-------------|----------|
| **ServiceName** | String | Mandatory | NOT NULL | Provider's service offering | "Amazon EC2", "Azure Virtual Machines", "Compute Engine" |
| **ServiceCategory** | String | Mandatory | NOT NULL | High-level classification (19 values) | "Compute", "Storage", "Databases" |
| **ServiceSubcategory** | String | Conditional (v1.1+) | Nullable | Secondary classification | "Virtual Machines", "Containers" |

#### 5.1.11 SKU Columns

| Column Name | Type | Requirement | Null | Description | Examples |
|-------------|------|-------------|------|-------------|----------|
| **SkuId** | String | Conditional | Nullable | SKU identifier for catalog | Provider-specific format |
| **SkuPriceId** | String | Conditional | Nullable | Specific price point ID | Provider-specific format |

#### 5.1.12 Commitment Discount Columns

| Column Name | Type | Requirement | Null | Description | Examples |
|-------------|------|-------------|------|-------------|----------|
| **CommitmentDiscountId** | String | Conditional | Nullable | Commitment identifier | RI ID, Savings Plan ID |
| **CommitmentDiscountName** | String | Conditional | Nullable | Display name | "Production-RI-2024" |
| **CommitmentDiscountType** | String | Conditional | Nullable | Specific commitment type | "Reserved Instance", "Savings Plan" |
| **CommitmentDiscountCategory** | String | Conditional | Nullable | "Usage" or "Spend" | "Usage", "Spend" |
| **CommitmentDiscountStatus** | String | Conditional | Nullable | "Used", "Unused", or null | "Used" |
| **CommitmentDiscountQuantity** | Decimal | Conditional (v1.1+) | Nullable | Amount purchased | 10.0, 1000.0 |
| **CommitmentDiscountUnit** | String | Conditional (v1.1+) | Nullable | Unit of commitment | "Hours", "USD" |

#### 5.1.13 Capacity Reservation Columns (v1.1+)

| Column Name | Type | Requirement | Null | Description | Examples |
|-------------|------|-------------|------|-------------|----------|
| **CapacityReservationId** | String | Conditional | Nullable | Capacity reservation identifier | Provider-specific ID |
| **CapacityReservationStatus** | String | Conditional | Nullable | "Used" or "Unused" | "Used", "Unused" |

#### 5.1.14 Tags Column

| Column Name | Type | Requirement | Null | Description | Examples |
|-------------|------|-------------|------|-------------|----------|
| **Tags** | JSON | Conditional | Nullable | Key-value pairs for categorization | `{"Environment": "Prod", "Team": "Data"}` |

### 5.2 Column Naming Conventions

**FOCUS Column Standards:**
- **Case:** PascalCase (e.g., BillingAccountId)
- **Abbreviations:** Avoided (e.g., "Identifier" not "Id" except as suffix)
- **Suffixes:** "Id" for identifiers, "Name" for display names
- **No Special Characters:** Only alphanumeric (A-Z, a-z, 0-9)

**Custom Provider Columns:**
- **Prefix:** "x_" required
- **Example:** `x_BillingExchangeRate`, `x_ResourceGroupName`, `x_CostCenter`
- **Purpose:** Provider-specific extensions without breaking FOCUS compliance

### 5.3 Data Type Specifications

| FOCUS Type | Description | Examples | Precision |
|------------|-------------|----------|-----------|
| **String** | UTF-8 text | "Amazon EC2", "us-east-1" | Variable length |
| **Decimal** | Numeric with high precision | 0.0960000000, 1024.500 | 10+ decimal places |
| **DateTime** | ISO 8601 timestamp | 2025-01-15T14:30:00Z | Seconds precision (v1.2) |
| **JSON** | Structured key-value | `{"key": "value"}` | Valid JSON object |

---

## 6. Data Quality Requirements

### 6.1 Required vs Optional Fields

#### 6.1.1 Feature Levels

FOCUS defines four requirement levels:

| Level | Description | Compliance Requirement |
|-------|-------------|----------------------|
| **Mandatory** | MUST exist unconditionally | Required for FOCUS compliance |
| **Conditional** | MUST exist when criteria apply | Required if applicable |
| **Recommended** | SHOULD be present | Best practice, not required |
| **Optional** | MAY be present | Provider discretion |

#### 6.1.2 Mandatory Columns (18 in v1.0)

All FOCUS datasets **MUST** include:

- BillingAccountId
- BillingCurrency
- BillingPeriodStart
- BillingPeriodEnd
- BilledCost
- ChargeCategory
- ChargeClass
- ChargeDescription
- ChargePeriodStart
- ChargePeriodEnd
- ContractedCost
- EffectiveCost
- InvoiceIssuer
- ListCost
- PricingQuantity
- PricingUnit
- Provider
- Publisher
- ServiceCategory
- ServiceName

### 6.2 Data Type Requirements

#### 6.2.1 Decimal Specifications

**Requirements:**
- **MUST** be valid decimal value
- **MUST** conform to NumericFormat requirements
- **MUST** support negative values (for corrections)
- **PRECISION:** Minimum 10 decimal places
- **NULL:** NOT allowed for cost columns

**Examples:**
```
Valid:   0.0960000000, -15.5000000000, 1234567.8900000000
Invalid: "0.096" (string), NULL (for costs), NaN
```

#### 6.2.2 DateTime Specifications

**Requirements (ISO 8601):**
- **FORMAT:** `YYYY-MM-DDTHH:MM:SSZ`
- **v1.2:** Explicit seconds required
- **TIMEZONE:** UTC (Z) or explicit offset
- **PRECISION:** Seconds (no milliseconds required)

**Examples:**
```
Valid:   2025-01-15T14:30:00Z, 2025-01-15T14:30:00+00:00
Invalid: 2025-01-15, 15-01-2025, 2025/01/15
```

#### 6.2.3 String Specifications

**Requirements:**
- **ENCODING:** UTF-8
- **CASE:** Preserve original case
- **LENGTH:** No explicit limit (provider-defined)
- **SPECIAL CHARS:** Allowed in values
- **TRIMMING:** Leading/trailing whitespace handling per provider

### 6.3 Null Handling Rules

#### 6.3.1 NOT NULL Columns

These columns **MUST NEVER** be null:

**Billing & Period:**
- BillingAccountId
- BillingCurrency
- BillingPeriodStart
- BillingPeriodEnd
- ChargePeriodStart
- ChargePeriodEnd

**Costs:**
- BilledCost
- EffectiveCost
- ListCost
- ContractedCost

**Classification:**
- ChargeCategory
- ChargeDescription
- Provider
- Publisher
- InvoiceIssuer
- ServiceName
- ServiceCategory

**Pricing:**
- PricingQuantity
- PricingUnit

#### 6.3.2 Nullable Columns

These columns **MAY** be null when not applicable:

- ChargeClass (null when not a correction)
- ChargeFrequency
- PricingCategory (null when no pricing model)
- All Conditional columns when conditions not met
- Tags (null when no tags exist)
- ConsumedQuantity/ConsumedUnit (null for purchases)
- Commitment columns (null for non-commitment charges)

#### 6.3.3 Null Value Checks

**Best Practice:** Check conformance gap reports from providers
- AWS: CUR conformance reports
- Azure: Conformance gap documentation
- GCP: FOCUS view validation queries

**Common Null Issues:**
- Empty strings representing nulls (non-compliant)
- Whitespace-only strings (non-compliant)
- "N/A" or "None" strings (should be null)

### 6.4 Aggregation Best Practices

#### 6.4.1 Summable Metrics

**Can be summed across rows:**
- BilledCost
- EffectiveCost
- ListCost
- ContractedCost
- PricingQuantity
- ConsumedQuantity

**Aggregation Formula:**
```sql
-- Total effective cost by service
SELECT 
  ServiceName,
  ServiceCategory,
  SUM(EffectiveCost) AS TotalCost
FROM focus_data
GROUP BY ServiceName, ServiceCategory
```

#### 6.4.2 Non-Summable Dimensions

**Cannot be summed (use for grouping only):**
- Unit prices (ListUnitPrice, ContractedUnitPrice)
- Identifiers (ResourceId, CommitmentDiscountId)
- Names and descriptions
- Date/time fields

#### 6.4.3 Weighted Averages

For unit prices across aggregated rows:

```sql
-- Weighted average unit price
SELECT 
  ServiceName,
  SUM(BilledCost) / SUM(PricingQuantity) AS AvgUnitPrice
FROM focus_data
WHERE PricingQuantity > 0
GROUP BY ServiceName
```

#### 6.4.4 Amortization Aggregation

**Best Practice for commitments:**

```sql
-- Separate amortized from billed costs
SELECT 
  BillingPeriodStart,
  SUM(BilledCost) AS InvoicedAmount,
  SUM(EffectiveCost) AS AmortizedCost,
  SUM(EffectiveCost) - SUM(BilledCost) AS AmortizationDelta
FROM focus_data
GROUP BY BillingPeriodStart
```

### 6.5 Time Granularity Requirements

#### 6.5.1 Supported Granularities

FOCUS supports multiple time granularities:

| Granularity | ChargePeriod Duration | Use Case |
|-------------|----------------------|----------|
| **Hourly** | 1 hour | Real-time cost monitoring |
| **Daily** | 1 day | Standard cost analysis |
| **Monthly** | Variable (billing period) | Invoice reconciliation |
| **Resource-level** | Per usage instance | Detailed attribution |

#### 6.5.2 ChargePeriod Rules

**For Continuous Usage:**
- ChargePeriodEnd - ChargePeriodStart **MUST** match dataset granularity
- Hourly: 1-hour windows
- Daily: 1-day windows (00:00:00Z to 00:00:00Z next day)

**For Purchases:**
- May span entire commitment period (e.g., 1 year, 3 years)
- ChargePeriodStart: Purchase date
- ChargePeriodEnd: Commitment end date

**For Adjustments:**
- Reflects correction timeframe
- May span multiple billing periods

#### 6.5.3 Time Zone Handling

**Best Practice:**
- **USE:** UTC (Z) for all timestamps
- **AVOID:** Local time zones
- **CONVERSION:** Convert to local for display only

**Example:**
```sql
-- Convert UTC to local time (BigQuery)
SELECT 
  ChargePeriodStart AT TIME ZONE 'America/New_York' AS LocalStart,
  ChargePeriodEnd AT TIME ZONE 'America/New_York' AS LocalEnd,
  BilledCost
FROM focus_data
```

### 6.6 Data Validation Checks

#### 6.6.1 Cost Relationship Validations

**Expected Relationships:**
```
ListCost >= ContractedCost >= BilledCost
```

**Validation Query:**
```sql
-- Identify cost relationship violations
SELECT *
FROM focus_data
WHERE ListCost < ContractedCost 
   OR ContractedCost < BilledCost
```

#### 6.6.2 Charge Period Validations

**Rules:**
- ChargePeriodEnd > ChargePeriodStart
- ChargePeriodStart >= BillingPeriodStart
- ChargePeriodEnd <= BillingPeriodEnd (usually)

**Validation Query:**
```sql
-- Check invalid charge periods
SELECT *
FROM focus_data
WHERE ChargePeriodEnd <= ChargePeriodStart
   OR ChargePeriodStart < BillingPeriodStart
```

#### 6.6.3 Quantity and Cost Consistency

**Rules:**
- If ConsumedQuantity > 0, ConsumedUnit MUST NOT be null
- If ListUnitPrice exists, ListCost = ListUnitPrice × PricingQuantity

**Validation Query:**
```sql
-- Check quantity/unit consistency
SELECT *
FROM focus_data
WHERE (ConsumedQuantity IS NOT NULL AND ConsumedQuantity > 0)
  AND ConsumedUnit IS NULL
```

---

## 7. Multi-Cloud Benefits

### 7.1 Why Standardization Matters

#### 7.1.1 The Multi-Cloud Challenge

**Before FOCUS:**
- Each cloud provider used proprietary schemas
- Different column names for same concepts
- Inconsistent cost calculations
- Manual normalization required
- Siloed analysis per provider

**With FOCUS:**
- Universal schema across all providers
- Consistent terminology
- Standardized cost metrics
- Automated consolidation
- Unified multi-cloud dashboards

#### 7.1.2 Business Impact

| Benefit | Before FOCUS | With FOCUS | Improvement |
|---------|--------------|------------|-------------|
| **Data Normalization** | Manual ETL per provider | Automatic mapping | 80% time savings |
| **Cost Comparison** | Complex custom logic | Direct comparison | 100% accuracy |
| **Team Training** | Learn each provider | Learn once | 3x faster onboarding |
| **Tool Compatibility** | Provider-specific tools | Universal BI tools | Unified stack |
| **Audit Readiness** | Multiple formats | Single standard | Compliance simplified |

### 7.2 Cross-Cloud Analysis Capabilities

#### 7.2.1 Unified Cost Dashboards

**Single View Across Providers:**

```sql
-- Total cost by cloud provider
SELECT 
  Provider,
  BillingPeriodStart,
  SUM(EffectiveCost) AS TotalCost,
  COUNT(DISTINCT ResourceId) AS ResourceCount
FROM focus_data
WHERE BillingPeriodStart >= '2025-01-01'
GROUP BY Provider, BillingPeriodStart
ORDER BY BillingPeriodStart, TotalCost DESC
```

**Output:**
```
Provider | BillingPeriodStart | TotalCost | ResourceCount
---------|-------------------|-----------|---------------
AWS      | 2025-01-01        | 125,430.50 | 1,245
Azure    | 2025-01-01        | 98,220.75  | 892
GCP      | 2025-01-01        | 45,100.25  | 423
```

#### 7.2.2 Service Category Comparison

**Compare Compute costs across clouds:**

```sql
-- Compute costs by provider
SELECT 
  Provider,
  ServiceCategory,
  ServiceSubcategory,
  SUM(EffectiveCost) AS TotalCost,
  AVG(EffectiveCost) AS AvgCost
FROM focus_data
WHERE ServiceCategory = 'Compute'
  AND BillingPeriodStart >= '2025-01-01'
GROUP BY Provider, ServiceCategory, ServiceSubcategory
ORDER BY TotalCost DESC
```

#### 7.2.3 Commitment Optimization

**Identify commitment coverage across providers:**

```sql
-- Commitment discount usage
SELECT 
  Provider,
  CommitmentDiscountCategory,
  CommitmentDiscountType,
  SUM(CASE WHEN CommitmentDiscountStatus = 'Used' THEN EffectiveCost ELSE 0 END) AS UsedCost,
  SUM(CASE WHEN CommitmentDiscountStatus = 'Unused' THEN EffectiveCost ELSE 0 END) AS UnusedCost,
  SUM(CASE WHEN CommitmentDiscountStatus = 'Unused' THEN EffectiveCost ELSE 0 END) / 
    SUM(EffectiveCost) AS WastePercentage
FROM focus_data
WHERE CommitmentDiscountId IS NOT NULL
GROUP BY Provider, CommitmentDiscountCategory, CommitmentDiscountType
```

### 7.3 Reporting Consistency

#### 7.3.1 Standardized Metrics

**Key Metrics Available Across All Providers:**

| Metric | FOCUS Column | Use Case |
|--------|--------------|----------|
| **Total Spend** | SUM(BilledCost) | Invoice reconciliation |
| **True Cost** | SUM(EffectiveCost) | Showback/chargeback |
| **Savings** | SUM(ListCost - BilledCost) | Discount tracking |
| **Commitment Coverage** | Commitment rows / Total rows | Optimization analysis |
| **Waste** | Unused commitments | Efficiency tracking |

#### 7.3.2 Universal Dimensions

**Group by any FOCUS dimension:**
- ServiceCategory (Compute, Storage, etc.)
- ChargeCategory (Usage, Purchase, etc.)
- Region (us-east-1, eastus, us-central1)
- SubAccount (AWS Account, Azure Subscription, GCP Project)
- Tags (Environment, CostCenter, Application)

#### 7.3.3 Time-Series Consistency

**Month-over-month comparison:**

```sql
-- Cost trend across providers
SELECT 
  DATE_TRUNC('month', BillingPeriodStart) AS Month,
  Provider,
  ServiceCategory,
  SUM(EffectiveCost) AS MonthlyCost
FROM focus_data
WHERE BillingPeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH)
GROUP BY Month, Provider, ServiceCategory
ORDER BY Month, Provider, MonthlyCost DESC
```

### 7.4 Tool Compatibility

#### 7.4.1 Business Intelligence Tools

**FOCUS works natively with:**

| Tool | Implementation | Benefit |
|------|----------------|---------|
| **Looker** | Native FOCUS views | Pre-built dashboards |
| **Tableau** | Direct FOCUS connector | Drag-and-drop analysis |
| **PowerBI** | FOCUS datasets | Cross-cloud reports |
| **Grafana** | FOCUS queries | Real-time monitoring |
| **Sisense** | FOCUS models | Embedded analytics |

#### 7.4.2 FinOps Platforms

**Native FOCUS Support:**
- CloudHealth by VMware
- Cloudability (Apptio)
- Kubecost
- Vantage
- nOps
- CloudZero

**Benefits:**
- No custom normalization logic
- Faster onboarding
- Accurate multi-cloud cost allocation
- Consistent cost anomaly detection

#### 7.4.3 Custom ETL Pipelines

**Simplified Data Workflows:**

**Before FOCUS:**
```
AWS CUR → Custom Normalizer → Data Warehouse
Azure CSV → Custom Normalizer → Data Warehouse
GCP Export → Custom Normalizer → Data Warehouse
                ↓
        Custom Unification Logic
```

**With FOCUS:**
```
AWS FOCUS → Data Warehouse ┐
Azure FOCUS → Data Warehouse├→ Unified Analysis
GCP FOCUS → Data Warehouse  ┘
```

---

## 8. Implementation Patterns

### 8.1 ETL/ELT Approaches

#### 8.1.1 Extract-Transform-Load (ETL)

**Traditional ETL for FOCUS:**

```
1. EXTRACT
   ├─ AWS CUR files from S3
   ├─ Azure Cost Export from Blob
   └─ GCP Billing Export from Cloud Storage

2. TRANSFORM
   ├─ Map to FOCUS schema
   ├─ Validate data types
   ├─ Apply business rules
   └─ Calculate derived metrics

3. LOAD
   └─ Insert into Data Warehouse
      ├─ Partitioned by BillingPeriodStart
      ├─ Clustered by Provider, ServiceCategory
      └─ Deduplicated by unique constraints
```

**Tool Examples:**
- Apache Airflow with FOCUS transformers
- dbt models for FOCUS normalization
- AWS Glue with FOCUS converters
- Azure Data Factory with FOCUS mappings

#### 8.1.2 Extract-Load-Transform (ELT)

**Modern ELT for FOCUS (Recommended):**

```
1. EXTRACT & LOAD (Raw)
   ├─ AWS CUR → BigQuery (raw table)
   ├─ Azure CSV → BigQuery (raw table)
   └─ GCP Billing → BigQuery (raw table)

2. TRANSFORM (In Database)
   ├─ Create FOCUS views
   ├─ Apply schema mapping
   ├─ Union all providers
   └─ Materialized FOCUS table
```

**BigQuery Example:**

```sql
-- Create unified FOCUS view
CREATE OR REPLACE VIEW `project.dataset.focus_unified` AS

-- AWS FOCUS mapping
SELECT 
  line_item_usage_account_id AS BillingAccountId,
  bill_billing_period_start_date AS BillingPeriodStart,
  line_item_unblended_cost AS BilledCost,
  -- ... more mappings
  'AWS' AS Provider
FROM `project.dataset.aws_cur_raw`

UNION ALL

-- Azure FOCUS mapping  
SELECT
  BillingAccountId,
  BillingPeriodStart,
  x_BilledCost AS BilledCost,
  -- ... more mappings
  'Azure' AS Provider
FROM `project.dataset.azure_cost_raw`

UNION ALL

-- GCP FOCUS (already in FOCUS format)
SELECT *
FROM `project.dataset.gcp_focus_view`
```

#### 8.1.3 Hybrid Approach

**Best of Both Worlds:**

1. **Stream raw data** to data lake (S3, Blob, GCS)
2. **Load to warehouse** in native format
3. **Create FOCUS views** with transformations
4. **Materialize** for performance

### 8.2 BigQuery Best Practices

#### 8.2.1 Table Design

**Partitioning Strategy:**

```sql
-- Create partitioned FOCUS table
CREATE TABLE `project.dataset.focus_data`
PARTITION BY DATE(BillingPeriodStart)
CLUSTER BY Provider, ServiceCategory, SubAccountId
AS
SELECT * FROM `project.dataset.focus_unified_view`
```

**Benefits:**
- **Partitioning by BillingPeriodStart:** Reduces query costs (scan only needed months)
- **Clustering by Provider, ServiceCategory:** Optimizes common filters
- **SubAccountId clustering:** Faster chargeback queries

#### 8.2.2 Query Optimization

**Use partition filters:**

```sql
-- Good: Scans only January 2025
SELECT Provider, SUM(EffectiveCost)
FROM `project.dataset.focus_data`
WHERE BillingPeriodStart >= '2025-01-01'
  AND BillingPeriodStart < '2025-02-01'
GROUP BY Provider
```

**Avoid full scans:**

```sql
-- Bad: Scans entire table
SELECT Provider, SUM(EffectiveCost)
FROM `project.dataset.focus_data`
WHERE EXTRACT(YEAR FROM BillingPeriodStart) = 2025
GROUP BY Provider
```

#### 8.2.3 Materialization Strategy

**When to Materialize:**
- Complex FOCUS transformations
- Frequent queries on same dataset
- Union of multiple providers
- Pre-aggregated summaries

**Scheduled Refresh:**

```sql
-- Create scheduled materialized view
CREATE MATERIALIZED VIEW `project.dataset.focus_monthly_summary`
PARTITION BY BillingPeriodStart
AS
SELECT 
  DATE_TRUNC(BillingPeriodStart, MONTH) AS BillingMonth,
  Provider,
  ServiceCategory,
  SubAccountName,
  SUM(EffectiveCost) AS TotalCost,
  SUM(ListCost - EffectiveCost) AS TotalSavings
FROM `project.dataset.focus_data`
GROUP BY BillingMonth, Provider, ServiceCategory, SubAccountName
```

**Refresh Schedule:**
- Daily: Materialized views refresh automatically
- Incremental: Only new partitions processed

### 8.3 Incremental vs Full Refresh Strategies

#### 8.3.1 Full Refresh (Complete Rebuild)

**When to Use:**
- Initial setup
- Schema changes
- Data quality issues
- Monthly reconciliation

**Implementation:**

```sql
-- Full refresh: Replace entire table
CREATE OR REPLACE TABLE `project.dataset.focus_data` AS
SELECT * FROM `project.dataset.focus_unified_view`
```

**Pros:**
- Simple logic
- Guaranteed consistency
- Fixes any data drift

**Cons:**
- High processing cost
- Long execution time
- Overwrites corrections

#### 8.3.2 Incremental Refresh (Append New Data)

**When to Use:**
- Daily updates
- Large historical datasets
- Cost optimization

**Implementation:**

```sql
-- Incremental: Append only new billing periods
INSERT INTO `project.dataset.focus_data`
SELECT * 
FROM `project.dataset.focus_unified_view`
WHERE BillingPeriodStart >= (
  SELECT MAX(BillingPeriodStart) 
  FROM `project.dataset.focus_data`
)
```

**Enhanced: Handle Corrections**

```sql
-- Delete existing data for refresh window
DELETE FROM `project.dataset.focus_data`
WHERE BillingPeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY);

-- Insert updated data
INSERT INTO `project.dataset.focus_data`
SELECT * 
FROM `project.dataset.focus_unified_view`
WHERE BillingPeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY);
```

**Pros:**
- Fast execution
- Lower cost
- Scalable

**Cons:**
- Complex logic for corrections
- Potential for duplicates
- Requires deduplication

#### 8.3.3 Hybrid: Partition-Level Refresh

**Best Practice for Production:**

```sql
-- Replace specific partitions
-- Step 1: Identify partitions to refresh (last 7 days)
DECLARE partitions_to_refresh ARRAY<DATE>;
SET partitions_to_refresh = (
  SELECT ARRAY_AGG(DISTINCT DATE(BillingPeriodStart))
  FROM `project.dataset.focus_unified_view`
  WHERE BillingPeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
);

-- Step 2: Delete old partitions
DELETE FROM `project.dataset.focus_data`
WHERE DATE(BillingPeriodStart) IN UNNEST(partitions_to_refresh);

-- Step 3: Insert refreshed data
INSERT INTO `project.dataset.focus_data`
SELECT * 
FROM `project.dataset.focus_unified_view`
WHERE DATE(BillingPeriodStart) IN UNNEST(partitions_to_refresh);
```

**Benefits:**
- Handles late-arriving data
- Processes corrections
- Optimizes cost (only refreshes needed partitions)

### 8.4 Partitioning Recommendations

#### 8.4.1 Partition Column Choice

**Primary Recommendation: BillingPeriodStart**

```sql
PARTITION BY DATE(BillingPeriodStart)
```

**Reasoning:**
- Aligns with invoice cycles
- Most queries filter by date
- Reduces query costs significantly
- Supports incremental updates

**Alternative: ChargePeriodStart**
- Use for usage-based analysis
- Aligns charges to consumption windows
- Better for anomaly detection

#### 8.4.2 Partitioning Granularity

| Granularity | When to Use | Partitions/Year |
|-------------|-------------|-----------------|
| **Daily** | Hourly billing data, large datasets | 365 |
| **Monthly** | Standard billing, smaller datasets | 12 |
| **Yearly** | Long-term historical analysis | 1 |

**BigQuery Limits:**
- Maximum partitions: 10,000
- Recommendation: Daily for 27+ years of data

#### 8.4.3 Clustering Strategy

**Recommended Cluster Keys (in order):**

```sql
CLUSTER BY Provider, ServiceCategory, SubAccountId, ResourceType
```

**Reasoning:**
1. **Provider:** Common filter for multi-cloud analysis
2. **ServiceCategory:** Frequent grouping dimension
3. **SubAccountId:** Chargeback/showback queries
4. **ResourceType:** Detailed drill-downs

**Query Performance Impact:**

```sql
-- Optimized query (uses all cluster keys)
SELECT SUM(EffectiveCost)
FROM `project.dataset.focus_data`
WHERE BillingPeriodStart = '2025-01-01'  -- Partition filter
  AND Provider = 'AWS'                    -- Cluster key 1
  AND ServiceCategory = 'Compute'         -- Cluster key 2
  AND SubAccountId = '123456789012'       -- Cluster key 3
```

**Performance:** Scans only relevant data blocks

### 8.5 Data Pipeline Orchestration

#### 8.5.1 Apache Airflow DAG Example

```python
from airflow import DAG
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'finops',
    'depends_on_past': False,
    'start_date': datetime(2025, 1, 1),
    'retries': 2,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'focus_data_pipeline',
    default_args=default_args,
    schedule_interval='0 6 * * *',  # Daily at 6 AM UTC
    catchup=False,
)

# Task 1: Refresh AWS FOCUS mapping
refresh_aws = BigQueryInsertJobOperator(
    task_id='refresh_aws_focus',
    configuration={
        'query': {
            'query': 'CALL `project.dataset.refresh_aws_focus`()',
            'useLegacySql': False,
        }
    },
    dag=dag,
)

# Task 2: Refresh Azure FOCUS mapping
refresh_azure = BigQueryInsertJobOperator(
    task_id='refresh_azure_focus',
    configuration={
        'query': {
            'query': 'CALL `project.dataset.refresh_azure_focus`()',
            'useLegacySql': False,
        }
    },
    dag=dag,
)

# Task 3: Refresh GCP FOCUS view
refresh_gcp = BigQueryInsertJobOperator(
    task_id='refresh_gcp_focus',
    configuration={
        'query': {
            'query': 'CALL `project.dataset.refresh_gcp_focus`()',
            'useLegacySql': False,
        }
    },
    dag=dag,
)

# Task 4: Merge into unified FOCUS table
merge_focus = BigQueryInsertJobOperator(
    task_id='merge_focus_unified',
    configuration={
        'query': {
            'query': '''
                DELETE FROM `project.dataset.focus_data`
                WHERE DATE(BillingPeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY);
                
                INSERT INTO `project.dataset.focus_data`
                SELECT * FROM `project.dataset.focus_unified_view`
                WHERE DATE(BillingPeriodStart) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY);
            ''',
            'useLegacySql': False,
        }
    },
    dag=dag,
)

# Task 5: Data quality validation
validate_focus = BigQueryInsertJobOperator(
    task_id='validate_focus_data',
    configuration={
        'query': {
            'query': 'CALL `project.dataset.validate_focus_quality`()',
            'useLegacySql': False,
        }
    },
    dag=dag,
)

# Task dependencies
[refresh_aws, refresh_azure, refresh_gcp] >> merge_focus >> validate_focus
```

#### 8.5.2 dbt Models for FOCUS

**models/staging/stg_aws_focus.sql:**

```sql
{{ config(
    materialized='view',
    schema='staging'
) }}

SELECT
    -- Billing Account
    line_item_usage_account_id AS BillingAccountId,
    payer_account_id AS BillingAccountName,
    
    -- Billing Period
    PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%SZ', bill_billing_period_start_date) AS BillingPeriodStart,
    PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%SZ', bill_billing_period_end_date) AS BillingPeriodEnd,
    
    -- Charge Period
    PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%SZ', line_item_usage_start_date) AS ChargePeriodStart,
    PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%SZ', line_item_usage_end_date) AS ChargePeriodEnd,
    
    -- Costs
    bill_billing_currency AS BillingCurrency,
    line_item_unblended_cost AS BilledCost,
    line_item_net_unblended_cost AS EffectiveCost,
    pricing_public_on_demand_cost AS ListCost,
    line_item_unblended_cost AS ContractedCost,
    
    -- Provider
    'AWS' AS Provider,
    product_servicename AS Publisher,
    'Amazon Web Services, Inc.' AS InvoiceIssuer,
    
    -- Service
    product_servicename AS ServiceName,
    {{ map_aws_service_category('product_servicename') }} AS ServiceCategory,
    
    -- More mappings...
    
FROM {{ source('aws', 'cur_table') }}
```

**models/marts/focus_unified.sql:**

```sql
{{ config(
    materialized='incremental',
    partition_by={
        'field': 'BillingPeriodStart',
        'data_type': 'date',
        'granularity': 'day'
    },
    cluster_by=['Provider', 'ServiceCategory', 'SubAccountId'],
    unique_key=['Provider', 'BillingPeriodStart', 'ResourceId', 'ChargePeriodStart']
) }}

SELECT * FROM {{ ref('stg_aws_focus') }}
UNION ALL
SELECT * FROM {{ ref('stg_azure_focus') }}
UNION ALL
SELECT * FROM {{ ref('stg_gcp_focus') }}

{% if is_incremental() %}
WHERE BillingPeriodStart >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
{% endif %}
```

---

## 9. Cloud Provider Mappings

### 9.1 AWS Cost and Usage Report (CUR) Mapping

#### 9.1.1 AWS CUR to FOCUS Column Mapping

| FOCUS Column | AWS CUR Column | Notes |
|--------------|----------------|-------|
| **BillingAccountId** | line_item_usage_account_id | AWS Account ID using the resource |
| **BillingAccountName** | (Lookup via AWS Organizations API) | Not in CUR directly |
| **BillingCurrency** | bill_billing_currency | ISO 4217 code (USD, etc.) |
| **BillingPeriodStart** | bill_billing_period_start_date | Convert to ISO 8601 |
| **BillingPeriodEnd** | bill_billing_period_end_date | Convert to ISO 8601 |
| **SubAccountId** | line_item_usage_account_id | Same as BillingAccountId in AWS |
| **SubAccountName** | (Lookup via AWS Organizations API) | Not in CUR directly |
| **ChargeCategory** | Derived from line_item_line_item_type | See mapping below |
| **ChargeClass** | Derived | "Correction" if adjustment, else null |
| **ChargeDescription** | line_item_line_item_description | AWS-generated description |
| **ChargePeriodStart** | line_item_usage_start_date | Convert to ISO 8601 |
| **ChargePeriodEnd** | line_item_usage_end_date | Convert to ISO 8601 |
| **BilledCost** | line_item_unblended_cost | After all discounts |
| **EffectiveCost** | line_item_net_unblended_cost OR derived | Amortized cost |
| **ListCost** | pricing_public_on_demand_cost | Public on-demand pricing |
| **ContractedCost** | line_item_unblended_cost | Post-negotiated discounts |
| **ConsumedQuantity** | line_item_usage_amount | Resource consumption |
| **ConsumedUnit** | line_item_usage_type (parsed) | Extract unit from usage type |
| **PricingCategory** | Derived from pricing columns | See logic below |
| **PricingQuantity** | line_item_usage_amount | Same as ConsumedQuantity |
| **PricingUnit** | line_item_usage_type (parsed) | Extract from usage type |
| **ListUnitPrice** | pricing_public_on_demand_rate | Public rate |
| **ContractedUnitPrice** | Derived (cost / quantity) | Calculate from unblended |
| **Provider** | 'AWS' (hardcoded) | Constant |
| **Publisher** | product_servicename | Service provider |
| **InvoiceIssuer** | 'Amazon Web Services, Inc.' | Constant |
| **RegionId** | product_region | AWS region code |
| **RegionName** | product_region_name | Display name |
| **AvailabilityZone** | line_item_availability_zone | AZ identifier |
| **ResourceId** | line_item_resource_id | ARN or ID |
| **ResourceName** | (Parse from ResourceId or tags) | Not always available |
| **ResourceType** | line_item_product_code | Product code |
| **ServiceName** | product_servicename | AWS service name |
| **ServiceCategory** | Derived (map from servicename) | Custom mapping required |
| **SkuId** | product_sku | AWS SKU identifier |
| **SkuPriceId** | rate_id | Rate ID |
| **CommitmentDiscountId** | reservation_reservation_a_r_n OR savings_plan_savings_plan_a_r_n | ARN of RI or SP |
| **CommitmentDiscountName** | (Parse from ARN) | Not directly available |
| **CommitmentDiscountType** | Derived | "Reserved Instance" or "Savings Plan" |
| **CommitmentDiscountCategory** | Derived | "Usage" for RI, "Spend" for SP |
| **CommitmentDiscountStatus** | Derived | Logic based on line item type |
| **Tags** | resource_tags_* | Parse all resource_tags columns into JSON |

#### 9.1.2 AWS ChargeCategory Mapping Logic

```sql
CASE 
    WHEN line_item_line_item_type IN ('Usage', 'SavingsPlanCoveredUsage', 'DiscountedUsage') 
        THEN 'Usage'
    WHEN line_item_line_item_type IN ('Fee', 'RIFee', 'SavingsPlanRecurringFee', 'SavingsPlanUpfrontFee')
        THEN 'Purchase'
    WHEN line_item_line_item_type = 'Tax'
        THEN 'Tax'
    WHEN line_item_line_item_type IN ('Credit', 'EdpDiscount', 'PrivateRateDiscount', 'BundledDiscount')
        THEN 'Credit'
    WHEN line_item_line_item_type IN ('Refund', 'RIFeeDiscount')
        THEN 'Adjustment'
    ELSE 'Adjustment'
END AS ChargeCategory
```

#### 9.1.3 AWS PricingCategory Mapping Logic

```sql
CASE
    WHEN reservation_reservation_a_r_n IS NOT NULL 
      OR savings_plan_savings_plan_a_r_n IS NOT NULL
        THEN 'Committed'
    WHEN line_item_usage_type LIKE '%Spot%' 
      OR line_item_usage_type LIKE '%SpotInstance%'
        THEN 'Dynamic'
    WHEN pricing_public_on_demand_rate IS NOT NULL
        THEN 'Standard'
    ELSE 'Other'
END AS PricingCategory
```

#### 9.1.4 AWS ServiceCategory Mapping

**Example Mappings:**

| AWS ServiceName | FOCUS ServiceCategory |
|-----------------|----------------------|
| Amazon Elastic Compute Cloud | Compute |
| Amazon Simple Storage Service | Storage |
| Amazon Relational Database Service | Databases |
| Amazon Redshift | Analytics |
| Amazon Virtual Private Cloud | Networking |
| AWS Lambda | Compute |
| Amazon CloudFront | Web |
| Amazon SageMaker | AI and Machine Learning |
| AWS Identity and Access Management | Identity |

**Implementation:**

```sql
CASE product_servicename
    WHEN 'Amazon Elastic Compute Cloud' THEN 'Compute'
    WHEN 'Amazon Simple Storage Service' THEN 'Storage'
    WHEN 'Amazon Relational Database Service' THEN 'Databases'
    WHEN 'Amazon Redshift' THEN 'Analytics'
    WHEN 'Amazon Virtual Private Cloud' THEN 'Networking'
    WHEN 'AWS Lambda' THEN 'Compute'
    WHEN 'Amazon CloudFront' THEN 'Web'
    WHEN 'Amazon SageMaker' THEN 'AI and Machine Learning'
    WHEN 'AWS Identity and Access Management' THEN 'Identity'
    -- ... more mappings
    ELSE 'Other'
END AS ServiceCategory
```

#### 9.1.5 AWS Tags to FOCUS JSON

```sql
-- Convert AWS resource tags to JSON
SELECT
    TO_JSON_STRING(
        STRUCT(
            resource_tags_user_environment AS Environment,
            resource_tags_user_cost_center AS CostCenter,
            resource_tags_user_application AS Application,
            resource_tags_user_owner AS Owner
            -- Include all resource_tags_* columns
        )
    ) AS Tags
FROM aws_cur_table
```

### 9.2 Google Cloud Platform (GCP) Billing Export Mapping

#### 9.2.1 GCP Native FOCUS Support

**Key Advantage:** GCP provides native FOCUS BigQuery views

**Setup:**
1. Enable Detailed Billing Export
2. Enable Price Export
3. Deploy GCP FOCUS BigQuery View (SQL template provided)

**View Structure:**

```sql
-- GCP FOCUS view (simplified)
CREATE OR REPLACE VIEW `project.dataset.gcp_focus_view` AS
SELECT
    -- Already in FOCUS format
    billing_account_id AS BillingAccountId,
    invoice.month AS BillingPeriodStart,
    -- ... GCP provides pre-mapped columns
FROM `project.dataset.gcp_billing_export`
```

#### 9.2.2 GCP to FOCUS Column Mapping

| FOCUS Column | GCP Billing Export Column | Notes |
|--------------|---------------------------|-------|
| **BillingAccountId** | billing_account_id | GCP billing account ID |
| **BillingAccountName** | (Lookup via Cloud Billing API) | Not in export |
| **BillingCurrency** | currency | ISO 4217 code |
| **BillingPeriodStart** | invoice.month (PARSE_DATE) | First day of invoice month |
| **BillingPeriodEnd** | DATE_ADD(invoice.month, INTERVAL 1 MONTH) | Last day of invoice month |
| **SubAccountId** | project.id | GCP Project ID |
| **SubAccountName** | project.name | GCP Project Name |
| **ChargeCategory** | Derived from cost_type | See mapping below |
| **ChargeClass** | Derived from credits | "Correction" if adjustment |
| **ChargeDescription** | sku.description | GCP SKU description |
| **ChargePeriodStart** | usage_start_time | ISO 8601 timestamp |
| **ChargePeriodEnd** | usage_end_time | ISO 8601 timestamp |
| **BilledCost** | cost | Cost after all credits |
| **EffectiveCost** | cost (with amortization logic) | Requires custom calc |
| **ListCost** | cost + credits.amount (for discounts) | Reconstruct list price |
| **ContractedCost** | cost | After negotiated discounts |
| **ConsumedQuantity** | usage.amount | Resource consumption |
| **ConsumedUnit** | usage.unit | Usage unit |
| **PricingCategory** | Derived from labels and credits | See logic below |
| **PricingQuantity** | usage.amount_in_pricing_units | Pricing quantity |
| **PricingUnit** | usage.pricing_unit | Pricing unit |
| **ListUnitPrice** | price.effective_price (list tier) | From price export |
| **ContractedUnitPrice** | Derived (cost / pricing_quantity) | Calculate |
| **Provider** | 'GCP' (hardcoded) | Constant |
| **Publisher** | service.description | GCP service |
| **InvoiceIssuer** | 'Google Cloud' | Constant |
| **RegionId** | location.region | GCP region |
| **RegionName** | location.region (display name) | Same or lookup |
| **AvailabilityZone** | location.zone | GCP zone |
| **ResourceId** | resource.global_name | Resource identifier |
| **ResourceName** | labels.value (name label) | From labels |
| **ResourceType** | system_labels.value (resource_type) | From system labels |
| **ServiceName** | service.description | GCP service name |
| **ServiceCategory** | Derived (map from service) | Custom mapping |
| **SkuId** | sku.id | GCP SKU ID |
| **SkuPriceId** | price.pricing_info_id | Price ID |
| **CommitmentDiscountId** | labels.value (commitment label) | CUD ID from labels |
| **CommitmentDiscountType** | Derived from credits.type | "Committed Use Discount" |
| **CommitmentDiscountCategory** | Derived | "Usage" or "Spend" |
| **Tags** | labels (all) | Convert to JSON |

#### 9.2.3 GCP ChargeCategory Mapping Logic

```sql
CASE
    WHEN cost_type = 'regular' THEN 'Usage'
    WHEN cost_type = 'tax' THEN 'Tax'
    WHEN cost_type = 'adjustment' THEN 'Adjustment'
    WHEN cost_type = 'rounding_error' THEN 'Adjustment'
    WHEN credits.type = 'COMMITTED_USE_DISCOUNT' THEN 'Usage'  -- CUD usage
    WHEN credits.type = 'COMMITTED_USE_DISCOUNT_DOLLAR_BASE' THEN 'Purchase'  -- CUD purchase
    WHEN credits.type IN ('PROMOTION', 'FREE_TIER') THEN 'Credit'
    ELSE 'Adjustment'
END AS ChargeCategory
```

#### 9.2.4 GCP PricingCategory Mapping Logic

```sql
CASE
    WHEN credits.type IN ('COMMITTED_USE_DISCOUNT', 'COMMITTED_USE_DISCOUNT_DOLLAR_BASE')
        THEN 'Committed'
    WHEN labels.value LIKE '%preemptible%' OR sku.description LIKE '%Preemptible%'
        THEN 'Dynamic'
    WHEN price.effective_price IS NOT NULL
        THEN 'Standard'
    ELSE 'Other'
END AS PricingCategory
```

#### 9.2.5 GCP ServiceCategory Mapping

| GCP ServiceName | FOCUS ServiceCategory |
|-----------------|----------------------|
| Compute Engine | Compute |
| Cloud Storage | Storage |
| Cloud SQL | Databases |
| BigQuery | Analytics |
| Cloud Functions | Compute |
| Cloud Run | Compute |
| Cloud CDN | Web |
| Vertex AI | AI and Machine Learning |
| Cloud Identity | Identity |
| Pub/Sub | Integration |

### 9.3 Microsoft Azure Cost Export Mapping

#### 9.3.1 Azure FOCUS Support

**Microsoft provides:**
- Native FOCUS 1.2-preview datasets
- FOCUS conformance reports
- Extended columns with "x_" prefix

**Export Types:**
1. **Actual Cost (FOCUS):** Pre-mapped to FOCUS schema
2. **Amortized Cost (FOCUS):** Includes commitment amortization
3. **Custom (Legacy):** Requires manual mapping

#### 9.3.2 Azure to FOCUS Column Mapping

| FOCUS Column | Azure Cost Export Column | Notes |
|--------------|--------------------------|-------|
| **BillingAccountId** | x_BillingAccountId OR x_BillingProfileId | EA or MCA account |
| **BillingAccountName** | x_BillingAccountName OR x_BillingProfileName | Display name |
| **BillingCurrency** | BillingCurrency | ISO 4217 code |
| **BillingPeriodStart** | BillingPeriodStart | ISO 8601 |
| **BillingPeriodEnd** | BillingPeriodEnd | ISO 8601 |
| **SubAccountId** | x_InvoiceSectionId OR x_SubscriptionId | Subscription ID |
| **SubAccountName** | x_InvoiceSectionName OR x_SubscriptionName | Subscription name |
| **ChargeCategory** | ChargeCategory | Already in FOCUS format |
| **ChargeClass** | ChargeClass | "Correction" or null |
| **ChargeDescription** | ChargeDescription | Azure-generated |
| **ChargePeriodStart** | ChargePeriodStart | ISO 8601 |
| **ChargePeriodEnd** | ChargePeriodEnd | ISO 8601 |
| **BilledCost** | x_BilledCost | Invoice amount |
| **EffectiveCost** | x_EffectiveCostInUsd | Amortized cost in USD |
| **ListCost** | x_ListCostInUsd | Public list price in USD |
| **ContractedCost** | x_ContractedCostInUsd | Negotiated cost in USD |
| **ConsumedQuantity** | UsageQuantity (legacy) | Resource consumption |
| **ConsumedUnit** | UsageUnit (legacy) | Usage unit |
| **PricingCategory** | PricingCategory | Standard, Committed, etc. |
| **PricingQuantity** | PricingQuantity | Calculated from UsageQuantity / PricingBlockSize |
| **PricingUnit** | x_PricingUnitDescription | Pricing unit |
| **ListUnitPrice** | x_ListUnitPrice | Public unit price |
| **ContractedUnitPrice** | ContractedUnitPrice | Negotiated unit price |
| **Provider** | 'Azure' (hardcoded) | Constant |
| **Publisher** | PublisherName | Microsoft, third-party |
| **InvoiceIssuer** | InvoiceIssuer | Microsoft Corporation |
| **RegionId** | x_SkuRegion | Azure region |
| **RegionName** | RegionName | Display name |
| **AvailabilityZone** | (Not typically available) | Null for most Azure |
| **ResourceId** | ResourceId | ARM Resource ID |
| **ResourceName** | (Parse from ResourceId) | Extract from ID |
| **ResourceType** | x_ResourceType | ARM resource type |
| **ServiceName** | ServiceName | Azure service |
| **ServiceCategory** | ServiceCategory | Already mapped |
| **SkuId** | x_SkuMeterId | SKU meter ID |
| **SkuPriceId** | x_SkuPriceId | Price ID |
| **CommitmentDiscountId** | CommitmentDiscountId | Reservation or savings plan ID |
| **CommitmentDiscountName** | CommitmentDiscountName | Display name |
| **CommitmentDiscountType** | CommitmentDiscountType | "Reservation", "Savings Plan" |
| **CommitmentDiscountCategory** | CommitmentDiscountCategory | "Usage" or "Spend" |
| **CommitmentDiscountStatus** | CommitmentDiscountStatus | "Used", "Unused" |
| **Tags** | Tags | JSON format |

#### 9.3.3 Azure-Specific Extended Columns

Azure provides additional "x_" columns:

| Extended Column | Purpose |
|-----------------|---------|
| **x_BillingExchangeRate** | Currency conversion rate |
| **x_ResourceGroupName** | Azure resource group |
| **x_CostCenter** | Custom cost center tag |
| **x_PartnerCreditApplied** | CSP partner credit flag |
| **x_PricingBlockSize** | Pricing block size for quantity calculation |
| **x_SkuTier** | SKU tier (Standard, Premium) |
| **x_SkuMeterName** | Meter name for usage tracking |
| **x_AmortizationClass** | "Principal" or "Amortized Charge" |
| **x_ServicePeriodStart** | Service period start |
| **x_ServicePeriodEnd** | Service period end |

#### 9.3.4 Azure PricingQuantity Calculation

```sql
-- Azure PricingQuantity calculation
SELECT
    UsageQuantity,
    x_PricingBlockSize,
    UsageQuantity / x_PricingBlockSize AS PricingQuantity
FROM azure_cost_export
WHERE x_PricingBlockSize IS NOT NULL AND x_PricingBlockSize > 0
```

**Example:**
- UsageQuantity: 7,300,000 (API calls)
- x_PricingBlockSize: 10,000 (per 10K calls)
- PricingQuantity: 730 (billed units)

#### 9.3.5 Azure ServiceCategory Mapping

| Azure ServiceName | FOCUS ServiceCategory |
|-------------------|----------------------|
| Virtual Machines | Compute |
| Storage Accounts | Storage |
| Azure SQL Database | Databases |
| Azure Synapse Analytics | Analytics |
| Virtual Network | Networking |
| Azure Functions | Compute |
| Azure CDN | Web |
| Azure Machine Learning | AI and Machine Learning |
| Azure Active Directory | Identity |

### 9.4 Multi-Provider Comparison Table

#### 9.4.1 Key Differences Across Providers

| Aspect | AWS | GCP | Azure |
|--------|-----|-----|-------|
| **Native FOCUS Support** | Partial (FOCUS 1.0) | Full (BigQuery view) | Full (FOCUS 1.2-preview) |
| **Export Format** | Parquet, CSV, Athena | BigQuery tables | CSV, Parquet |
| **Export Frequency** | Daily, hourly | Daily | Daily |
| **Update Latency** | 24-48 hours | ~24 hours | 24-48 hours |
| **Historical Data** | 13 months | Unlimited (in BQ) | 13 months |
| **Commitment Types** | RI, Savings Plans | CUD, Flexible CUD | Reservations, Savings Plans |
| **Commitment Category** | Usage/Spend | Usage/Spend | Usage/Spend |
| **Tags Support** | resource_tags_* | labels | Tags (JSON) |
| **Extended Columns** | Limited | Via FOCUS view | Extensive (x_ prefix) |
| **SubAccount Mapping** | AWS Account ID | GCP Project ID | Azure Subscription ID |
| **ResourceId Format** | ARN | resource.global_name | ARM Resource ID |

#### 9.4.2 Cost Column Calculation Differences

**BilledCost (Invoice Amount):**
- **AWS:** `line_item_unblended_cost`
- **GCP:** `cost` (after credits)
- **Azure:** `x_BilledCost`

**EffectiveCost (Amortized):**
- **AWS:** `line_item_net_unblended_cost` OR custom amortization logic
- **GCP:** Requires custom amortization from CUD purchases
- **Azure:** `x_EffectiveCostInUsd` (pre-calculated)

**ListCost (Public Pricing):**
- **AWS:** `pricing_public_on_demand_cost`
- **GCP:** Reconstruct from `cost + credits.amount`
- **Azure:** `x_ListCostInUsd`

#### 9.4.3 Commitment Discount Tracking

**Reserved Instances / Committed Use:**

| Provider | CommitmentDiscountType | CommitmentDiscountCategory | Identifier Column |
|----------|------------------------|----------------------------|-------------------|
| **AWS RI** | "Reserved Instance" | "Usage" | reservation_reservation_a_r_n |
| **AWS SP** | "Savings Plan" | "Spend" | savings_plan_savings_plan_a_r_n |
| **GCP CUD** | "Committed Use Discount" | "Usage" | labels (commitment ID) |
| **GCP Flexible CUD** | "Flexible Committed Use" | "Spend" | labels (commitment ID) |
| **Azure RI** | "Reservation" | "Usage" | CommitmentDiscountId |
| **Azure SP** | "Savings Plan" | "Spend" | CommitmentDiscountId |

---

## 10. Appendix: Reference Materials

### 10.1 Official FOCUS Resources

#### 10.1.1 Primary Documentation

- **Official Website:** https://focus.finops.org/
- **Specification v1.0:** https://focus.finops.org/focus-specification/v1-0/
- **Specification v1.1:** https://focus.finops.org/focus-specification/v1-1/
- **Specification v1.2:** https://focus.finops.org/focus-specification/v1-2/
- **Column Library:** https://focus.finops.org/focus-columns/
- **FAQ:** https://focus.finops.org/faqs/

#### 10.1.2 GitHub Repositories

- **Main Spec Repo:** https://github.com/FinOps-Open-Cost-and-Usage-Spec/FOCUS_Spec
- **Foundation Repo:** https://github.com/FinOps-Open-Cost-and-Usage-Spec/foundation
- **FOCUS Converters:** https://github.com/finopsfoundation/focus_converters

#### 10.1.3 Provider Documentation

**AWS:**
- AWS FOCUS 1.0 Documentation: https://docs.aws.amazon.com/cur/latest/userguide/table-dictionary-focus-1-0-aws.html
- AWS CUR User Guide: https://docs.aws.amazon.com/cur/latest/userguide/

**GCP:**
- GCP FOCUS Guide: https://focus.finops.org/get-started/google-cloud/
- GCP Billing Export: https://cloud.google.com/billing/docs/how-to/export-data-bigquery
- GCP FOCUS BigQuery View: https://cloud.google.com/blog/topics/cost-management/new-bigquery-cloud-billing-view-based-on-focus

**Azure:**
- Azure FOCUS Schema: https://learn.microsoft.com/en-us/azure/cost-management-billing/dataset-schema/cost-usage-details-focus
- Azure Cost Management: https://learn.microsoft.com/en-us/azure/cost-management-billing/
- Azure FOCUS Conformance: https://learn.microsoft.com/en-us/cloud-computing/finops/focus/conformance-full-report

### 10.2 Community Resources

#### 10.2.1 Learning Materials

- **Microsoft Learning FOCUS Series:**
  - Charge Types and Pricing Models: https://techcommunity.microsoft.com/blog/finopsblog/learning-focus-charge-types-and-pricing-models/4357997
  - Service Columns: https://techcommunity.microsoft.com/blog/finopsblog/learning-focus-service-columns/4388703
  - Purchases: https://techcommunity.microsoft.com/blog/finopsblog/learning-focus-purchases/4404283

- **FinOps Foundation Blog Posts:**
  - FOCUS 1.0 GA Announcement: https://www.finops.org/insights/focus-1-0-available/
  - FOCUS 1.2 Announcement: https://www.finops.org/insights/focus-1-2-available/

#### 10.2.2 Tools and Utilities

- **FOCUS Converters:** CLI tools to convert native billing exports to FOCUS format
  - GitHub: https://github.com/finopsfoundation/focus_converters
  - Usage: `npx @finops/focus-converter convert --provider aws --input cur.csv --output focus.csv`

- **FOCUS Validators:** JSON schemas and validation tools
  - GitHub: https://github.com/openmeterio/finops-focus-schema

- **FOCUS Sandbox:** Sample FOCUS datasets for testing
  - FinOps Foundation: https://www.finops.org/insights/focus-sandbox/

### 10.3 Allowed Values Quick Reference

#### 10.3.1 ChargeCategory (5 values)

1. **Usage** - Consumption-based charges
2. **Purchase** - Service acquisition charges
3. **Tax** - Governmental/regulatory fees
4. **Credit** - Vouchers and incentives
5. **Adjustment** - Other charges

#### 10.3.2 ChargeClass (2 values)

1. **"Correction"** - Billing corrections/refunds
2. **null** - Not a correction

#### 10.3.3 PricingCategory (5 values)

1. **"Standard"** - Predetermined agreed rates
2. **"Dynamic"** - Variable provider-determined rates
3. **"Committed"** - Commitment discount rates
4. **"Other"** - Non-standard pricing
5. **null** - No pricing model

#### 10.3.4 CommitmentDiscountCategory (2 values)

1. **"Usage"** - Usage-based commitments
2. **"Spend"** - Spend-based commitments

#### 10.3.5 CommitmentDiscountStatus (3 values)

1. **"Used"** - Commitment was applied
2. **"Unused"** - Commitment went unused
3. **null** - Not commitment-related

#### 10.3.6 CapacityReservationStatus (3 values)

1. **"Used"** - Capacity was consumed
2. **"Unused"** - Capacity went unused
3. **null** - Not capacity reservation

#### 10.3.7 ServiceCategory (19 values)

1. AI and Machine Learning
2. Analytics
3. Business Applications
4. Compute
5. Databases
6. Developer Tools
7. Identity
8. Integration
9. Internet of Things
10. Management and Governance
11. Media
12. Migration
13. Mobile
14. Multicloud
15. Networking
16. Security
17. Storage
18. Web
19. Other

### 10.4 Data Type Formats

#### 10.4.1 DateTime Format (ISO 8601)

**Pattern:** `YYYY-MM-DDTHH:MM:SSZ`

**Examples:**
- `2025-01-15T14:30:00Z` (UTC)
- `2025-01-15T14:30:00+00:00` (UTC with explicit offset)
- `2025-01-15T09:30:00-05:00` (EST)

**Requirements:**
- MUST include seconds (v1.2+)
- SHOULD use UTC (Z)
- MUST be exclusive end for period end dates

#### 10.4.2 Decimal Format

**Pattern:** Numeric with high precision

**Examples:**
- `0.0960000000` (10 decimal places)
- `1234567.8900000000`
- `-15.5000000000` (negative for corrections)

**Requirements:**
- Minimum 10 decimal places recommended
- Supports negative values
- No thousand separators
- Period (.) as decimal separator

#### 10.4.3 Currency Code Format (ISO 4217)

**Pattern:** Three-letter uppercase code

**Common Values:**
- `USD` - US Dollar
- `EUR` - Euro
- `GBP` - British Pound
- `JPY` - Japanese Yen
- `CNY` - Chinese Yuan
- `INR` - Indian Rupee

#### 10.4.4 JSON Format (Tags)

**Pattern:** Valid JSON object

**Example:**
```json
{
  "Environment": "Production",
  "CostCenter": "Engineering",
  "Application": "WebApp",
  "Owner": "team-platform@company.com",
  "aws:CreatedBy": "arn:aws:iam::123456789012:user/john.doe"
}
```

**Requirements:**
- Valid JSON syntax
- Keys are case-sensitive
- Supports provider-prefixed keys
- Can be null if no tags

### 10.5 Common SQL Queries

#### 10.5.1 Total Cost by Provider

```sql
SELECT 
  Provider,
  BillingPeriodStart,
  SUM(EffectiveCost) AS TotalEffectiveCost,
  SUM(BilledCost) AS TotalBilledCost,
  SUM(ListCost - EffectiveCost) AS TotalSavings
FROM focus_data
WHERE BillingPeriodStart >= '2025-01-01'
GROUP BY Provider, BillingPeriodStart
ORDER BY BillingPeriodStart, TotalEffectiveCost DESC
```

#### 10.5.2 Top 10 Services by Cost

```sql
SELECT 
  ServiceName,
  ServiceCategory,
  Provider,
  SUM(EffectiveCost) AS TotalCost
FROM focus_data
WHERE BillingPeriodStart >= '2025-01-01'
  AND BillingPeriodStart < '2025-02-01'
GROUP BY ServiceName, ServiceCategory, Provider
ORDER BY TotalCost DESC
LIMIT 10
```

#### 10.5.3 Commitment Discount Utilization

```sql
SELECT 
  Provider,
  CommitmentDiscountType,
  CommitmentDiscountCategory,
  SUM(CASE WHEN CommitmentDiscountStatus = 'Used' THEN EffectiveCost ELSE 0 END) AS UsedCost,
  SUM(CASE WHEN CommitmentDiscountStatus = 'Unused' THEN EffectiveCost ELSE 0 END) AS UnusedCost,
  SAFE_DIVIDE(
    SUM(CASE WHEN CommitmentDiscountStatus = 'Used' THEN EffectiveCost ELSE 0 END),
    SUM(EffectiveCost)
  ) * 100 AS UtilizationPercentage
FROM focus_data
WHERE CommitmentDiscountId IS NOT NULL
  AND BillingPeriodStart >= '2025-01-01'
GROUP BY Provider, CommitmentDiscountType, CommitmentDiscountCategory
ORDER BY Provider, CommitmentDiscountType
```

#### 10.5.4 Cost by Tag

```sql
SELECT 
  JSON_EXTRACT_SCALAR(Tags, '$.Environment') AS Environment,
  JSON_EXTRACT_SCALAR(Tags, '$.CostCenter') AS CostCenter,
  Provider,
  ServiceCategory,
  SUM(EffectiveCost) AS TotalCost
FROM focus_data
WHERE Tags IS NOT NULL
  AND BillingPeriodStart >= '2025-01-01'
  AND BillingPeriodStart < '2025-02-01'
GROUP BY Environment, CostCenter, Provider, ServiceCategory
ORDER BY TotalCost DESC
```

#### 10.5.5 Daily Cost Trend

```sql
SELECT 
  DATE(ChargePeriodStart) AS UsageDate,
  Provider,
  ServiceCategory,
  SUM(EffectiveCost) AS DailyCost
FROM focus_data
WHERE ChargePeriodStart >= TIMESTAMP('2025-01-01')
  AND ChargePeriodStart < TIMESTAMP('2025-02-01')
GROUP BY UsageDate, Provider, ServiceCategory
ORDER BY UsageDate, Provider, DailyCost DESC
```

#### 10.5.6 Data Quality Check

```sql
-- Identify rows with data quality issues
SELECT 
  'Null mandatory field' AS IssueType,
  COUNT(*) AS RowCount
FROM focus_data
WHERE BilledCost IS NULL 
   OR EffectiveCost IS NULL
   OR ChargeCategory IS NULL

UNION ALL

SELECT 
  'Invalid cost relationship' AS IssueType,
  COUNT(*) AS RowCount
FROM focus_data
WHERE ListCost < ContractedCost 
   OR ContractedCost < BilledCost

UNION ALL

SELECT 
  'Invalid charge period' AS IssueType,
  COUNT(*) AS RowCount
FROM focus_data
WHERE ChargePeriodEnd <= ChargePeriodStart

UNION ALL

SELECT 
  'Missing quantity unit' AS IssueType,
  COUNT(*) AS RowCount
FROM focus_data
WHERE ConsumedQuantity IS NOT NULL 
  AND ConsumedQuantity > 0
  AND ConsumedUnit IS NULL
```

### 10.6 Glossary

#### Key Terms

- **FOCUS:** FinOps Open Cost and Usage Specification
- **FinOps:** Financial Operations for cloud cost management
- **CSP:** Cloud Service Provider (AWS, Azure, GCP, etc.)
- **CUR:** AWS Cost and Usage Report
- **ARM:** Azure Resource Manager (resource ID format)
- **ARN:** Amazon Resource Name (AWS resource ID format)
- **RI:** Reserved Instance (commitment discount type)
- **SP:** Savings Plan (commitment discount type)
- **CUD:** Committed Use Discount (GCP commitment type)
- **SKU:** Stock Keeping Unit (service catalog identifier)
- **ISO 8601:** International standard for date/time formatting
- **ISO 4217:** International standard for currency codes
- **RFC 2119:** Keywords for requirement levels (MUST, SHOULD, MAY)
- **ETL:** Extract, Transform, Load (data pipeline pattern)
- **ELT:** Extract, Load, Transform (modern data pipeline pattern)

---

## Document Revision History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-11-17 | Initial comprehensive FOCUS specification document |

---

## Next Steps for AWS CUR v2 and GCP Billing Export

### Recommended Actions:

1. **Review Provider Mappings:**
   - Validate AWS CUR column mappings (Section 9.1)
   - Validate GCP billing export mappings (Section 9.2)
   - Test Azure mappings for reference (Section 9.3)

2. **Implement Data Pipeline:**
   - Choose ELT approach for BigQuery (Section 8.1.2)
   - Set up partitioning by BillingPeriodStart (Section 8.4)
   - Configure incremental refresh strategy (Section 8.3.3)

3. **Create Transformation Logic:**
   - Build ChargeCategory mapping (Section 9.1.2, 9.2.3)
   - Implement PricingCategory logic (Section 9.1.3, 9.2.4)
   - Map ServiceCategory values (Section 9.1.4, 9.2.5)

4. **Validate Data Quality:**
   - Run validation queries (Section 6.6)
   - Check conformance reports from providers
   - Test aggregation logic (Section 6.4)

5. **Build Dashboards:**
   - Use unified FOCUS schema for Looker
   - Implement cross-cloud comparison queries (Section 7.2)
   - Create commitment optimization views (Section 7.2.3)

---

**END OF DOCUMENT**
