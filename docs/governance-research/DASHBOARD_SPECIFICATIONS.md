# Governance Dashboard Technical Specifications
# LookML Implementation Guide for AWS CUR 2.0

**Version:** 1.0  
**Last Updated:** 2025-11-17  
**Purpose:** Technical specifications for implementing governance dashboards

---

## Dashboard 1: Executive Governance Scorecard

### Data Requirements

**Base Explore:** `cur2`  
**Required Dimensions:**
- `line_item_usage_start_date`
- `line_item_usage_account_name`
- `line_item_product_code`
- `product_region_code`
- `resource_tags`
- `environment`
- `line_item_resource_id`

**Required Measures:**
- `total_unblended_cost`
- `count_unique_resources`
- `tag_coverage_rate`
- `count`

**Calculated Fields Needed:**

```lookml
# Security Posture Score (composite measure)
measure: security_posture_score {
  type: number
  sql: 
    (${iam_compliance_score} * 0.30) +
    (${encryption_coverage_pct} * 0.25) +
    (${network_security_score} * 0.20) +
    (${vulnerability_remediation_score} * 0.25)
  ;;
  value_format: "0"
  description: "Composite security posture score (0-100)"
}

# IAM Compliance Score
measure: iam_compliance_score {
  type: number
  sql:
    CASE
      WHEN COUNT(DISTINCT CASE 
        WHEN ${resource_tags} LIKE '%MFAEnabled:true%' 
        THEN ${line_item_resource_id} 
      END) * 100.0 / NULLIF(COUNT(DISTINCT ${line_item_resource_id}), 0) >= 95 
      THEN 100
      WHEN COUNT(DISTINCT CASE 
        WHEN ${resource_tags} LIKE '%MFAEnabled:true%' 
        THEN ${line_item_resource_id} 
      END) * 100.0 / NULLIF(COUNT(DISTINCT ${line_item_resource_id}), 0) >= 80 
      THEN 80
      ELSE 60
    END
  ;;
  description: "IAM security compliance score based on MFA and policies"
}

# Encryption Coverage Percentage
measure: encryption_coverage_pct {
  type: number
  sql:
    COUNT(DISTINCT CASE 
      WHEN ${resource_tags} LIKE '%Encrypted:true%' 
        OR ${product_product_name} LIKE '%encrypted%'
      THEN ${line_item_resource_id} 
    END) * 100.0 / NULLIF(COUNT(DISTINCT ${line_item_resource_id}), 0)
  ;;
  value_format: "0.0"
  description: "Percentage of resources with encryption enabled"
}

# Governance Health Score
measure: governance_health_score {
  type: number
  sql:
    (${security_posture_score} * 0.35) +
    (${compliance_score} * 0.30) +
    (${policy_compliance_score} * 0.20) +
    (${operational_maturity_score} * 0.15)
  ;;
  value_format: "0"
  description: "Overall governance health score (0-100)"
}

# Compliance Score (multi-framework)
measure: compliance_score {
  type: number
  sql:
    CASE
      WHEN ${tag_coverage_rate} >= 0.90 
        AND ${encryption_coverage_pct} >= 95
        AND ${data_residency_compliance_pct} >= 98
      THEN 95
      WHEN ${tag_coverage_rate} >= 0.80 
        AND ${encryption_coverage_pct} >= 85
      THEN 85
      WHEN ${tag_coverage_rate} >= 0.70 
      THEN 75
      ELSE 65
    END
  ;;
  description: "Multi-framework compliance score"
}

# Data Residency Compliance
measure: data_residency_compliance_pct {
  type: number
  sql:
    COUNT(DISTINCT CASE 
      WHEN ${region_country} IN ('United States', 'Ireland', 'Germany', 'United Kingdom')
        OR ${resource_tags} LIKE '%DataResidency:Compliant%'
      THEN ${line_item_resource_id}
    END) * 100.0 / NULLIF(COUNT(DISTINCT ${line_item_resource_id}), 0)
  ;;
  value_format: "0.0\"%\""
  description: "Percentage of resources in compliant regions"
}

# Critical Findings Count
measure: critical_findings_count {
  type: count_distinct
  sql: ${line_item_resource_id} ;;
  filters: [
    is_public_exposed: "Yes",
    encryption_coverage_pct: "<80"
  ]
  description: "Count of resources with critical security findings"
}

# Policy Compliance Score
measure: policy_compliance_score {
  type: number
  sql:
    (${tag_coverage_rate} * 0.40) +
    (${naming_standard_compliance} * 0.30) +
    (${budget_compliance_pct} * 0.30)
  ;;
  value_format: "0"
}

# Naming Standard Compliance
measure: naming_standard_compliance {
  type: number
  sql:
    COUNT(DISTINCT CASE 
      WHEN ${line_item_resource_id} RLIKE '^[a-z0-9-]+-(dev|stg|prod)-[a-z0-9-]+$'
      THEN ${line_item_resource_id}
    END) * 100.0 / NULLIF(COUNT(DISTINCT ${line_item_resource_id}), 0)
  ;;
  description: "Resources following naming conventions"
}
```

### Dashboard Layout

**Tile Specifications:**

1. **Overall Governance Health Score** (Row 0, Col 0, 6x4)
   - Type: `single_value` with gauge visualization
   - Field: `governance_health_score`
   - Conditional formatting:
     - Green: >85
     - Yellow: 70-85
     - Red: <70

2. **Security Posture Score** (Row 0, Col 6, 6x4)
   - Type: `single_value`
   - Field: `security_posture_score`

3. **Compliance Score** (Row 0, Col 12, 6x4)
   - Type: `single_value`
   - Field: `compliance_score`

4. **Critical Findings** (Row 0, Col 18, 6x4)
   - Type: `single_value`
   - Field: `critical_findings_count`
   - Color: Red if > 0

5. **Score Breakdown** (Row 4, Col 0, 12x6)
   - Type: `looker_column`
   - Fields: IAM, Encryption, Network, Vulnerability scores

6. **Compliance by Framework** (Row 4, Col 12, 12x6)
   - Type: `looker_grid`
   - Manual entry for GDPR, HIPAA, SOC2, PCI-DSS, ISO 27001

7. **Trend Analysis** (Row 10, Col 0, 24x6)
   - Type: `looker_line`
   - Time series of governance scores

---

## Dashboard 2: Security Posture Management (CSPM)

### Required Custom Dimensions & Measures

```lookml
# Misconfiguration Severity
dimension: misconfiguration_severity {
  type: string
  sql:
    CASE
      WHEN ${is_public_exposed} = 'Yes' AND ${is_encrypted} = 'No' THEN 'Critical'
      WHEN ${is_public_exposed} = 'Yes' OR ${is_encrypted} = 'No' THEN 'High'
      WHEN ${tag_coverage_rate} < 0.7 THEN 'Medium'
      ELSE 'Low'
    END
  ;;
  description: "Security misconfiguration severity level"
}

# Public Exposure Detection
dimension: is_public_exposed {
  type: yesno
  sql:
    ${resource_tags} LIKE '%PublicAccess:true%'
    OR ${resource_tags} LIKE '%0.0.0.0/0%'
    OR (${line_item_product_code} = 'AmazonS3' 
        AND ${resource_tags} NOT LIKE '%BlockPublicAccess:true%')
  ;;
  description: "Resource is publicly accessible"
}

# Encryption Status
dimension: is_encrypted {
  type: yesno
  sql:
    ${resource_tags} LIKE '%Encrypted:true%'
    OR ${product_product_name} LIKE '%encrypted%'
  ;;
}

# MFA Status
dimension: has_mfa_enabled {
  type: yesno
  sql: ${resource_tags} LIKE '%MFAEnabled:true%' ;;
}

# IAM Privilege Level
dimension: iam_privilege_level {
  type: string
  sql:
    CASE
      WHEN ${resource_tags} LIKE '%IAMRole:%*:*%' THEN 'Admin Access'
      WHEN ${resource_tags} LIKE '%IAMRole:%PowerUser%' THEN 'Power User'
      WHEN ${resource_tags} LIKE '%IAMRole:%ReadOnly%' THEN 'Read Only'
      ELSE 'Standard'
    END
  ;;
}

# Vulnerability Risk Score (EPSS-based, requires external data)
measure: vulnerability_risk_score {
  type: average
  sql: 
    CASE
      WHEN ${resource_tags} LIKE '%EPSS:%' THEN
        CAST(REGEXP_EXTRACT(${resource_tags}, r'EPSS:([0-9.]+)') AS FLOAT64) * 100
      ELSE 0
    END
  ;;
  value_format: "0.0"
  description: "Average EPSS vulnerability risk score (0-100)"
}

# Time to Remediate (requires finding creation timestamp)
measure: mean_time_to_remediate_days {
  type: average
  sql: 
    DATE_DIFF(
      CURRENT_DATE(),
      PARSE_DATE('%Y-%m-%d', REGEXP_EXTRACT(${resource_tags}, r'FindingDate:([0-9-]+)')),
      DAY
    )
  ;;
  value_format: "0.0"
  description: "Average days to remediate security findings"
}

# Secret Age (for rotation tracking)
measure: avg_secret_age_days {
  type: average
  sql:
    DATE_DIFF(
      CURRENT_DATE(),
      PARSE_DATE('%Y-%m-%d', REGEXP_EXTRACT(${resource_tags}, r'SecretCreated:([0-9-]+)')),
      DAY
    )
  ;;
  filters: [line_item_product_code: "AWS Secrets Manager"]
}

# Security Group Rule Analysis
measure: overpermissive_sg_rules {
  type: count_distinct
  sql: ${line_item_resource_id} ;;
  filters: [
    line_item_product_code: "AmazonEC2",
    resource_tags: "%0.0.0.0/0%"
  ]
  description: "Security groups with overly permissive rules"
}
```

### Dashboard Elements

**CSPM Executive View:**

1. **Security Score Gauge** (0-100 scale)
2. **Misconfiguration by Severity** - Pie chart
3. **IAM Least Privilege Status** - Progress bar
4. **Encryption Coverage by Service** - Stacked bar
5. **Top 10 Security Risks** - Table with risk scores
6. **Vulnerability EPSS Matrix** - Scatter plot (EPSS vs Impact)
7. **Network Security Posture** - Security group analysis
8. **Remediation Velocity** - Line chart (MTTR trend)

---

## Dashboard 3: Regulatory Compliance Heatmap

### Required Measures

```lookml
# GDPR Compliance Score
measure: gdpr_compliance_score {
  type: number
  sql:
    (${data_residency_compliance_pct} * 0.35) +
    (${encryption_coverage_pct} * 0.25) +
    (${audit_logging_completeness} * 0.25) +
    (${data_retention_compliance} * 0.15)
  ;;
  value_format: "0\"%\""
}

# HIPAA Compliance Score
measure: hipaa_compliance_score {
  type: number
  sql:
    (${ephi_encryption_coverage} * 0.30) +
    (${audit_logging_completeness} * 0.30) +
    (${access_control_effectiveness} * 0.25) +
    (${baa_coverage} * 0.15)
  ;;
  value_format: "0\"%\""
}

# SOC 2 Compliance Score
measure: soc2_compliance_score {
  type: number
  sql:
    (${security_controls_score} * 0.25) +
    (${availability_sla_compliance} * 0.20) +
    (${processing_integrity_score} * 0.20) +
    (${confidentiality_score} * 0.20) +
    (${privacy_controls_score} * 0.15)
  ;;
  value_format: "0\"%\""
}

# PCI-DSS Compliance Score
measure: pci_dss_compliance_score {
  type: number
  sql:
    (${cde_segmentation_score} * 0.30) +
    (${access_control_effectiveness} * 0.25) +
    (${vulnerability_scan_compliance} * 0.25) +
    (${monitoring_testing_score} * 0.20)
  ;;
  value_format: "0\"%\""
}

# Audit Logging Completeness
measure: audit_logging_completeness {
  type: number
  sql:
    COUNT(DISTINCT CASE 
      WHEN ${resource_tags} LIKE '%CloudTrail:Enabled%'
        OR ${resource_tags} LIKE '%Logging:Enabled%'
      THEN ${line_item_resource_id}
    END) * 100.0 / NULLIF(COUNT(DISTINCT ${line_item_resource_id}), 0)
  ;;
  value_format: "0.0\"%\""
}

# Data Retention Compliance
measure: data_retention_compliance {
  type: number
  sql:
    COUNT(DISTINCT CASE
      WHEN ${resource_tags} LIKE '%RetentionPolicy:%'
      THEN ${line_item_resource_id}
    END) * 100.0 / NULLIF(COUNT(DISTINCT ${line_item_resource_id}), 0)
  ;;
  value_format: "0.0\"%\""
}
```

### Heatmap Matrix Configuration

**Matrix Dimensions:**
- Rows: Compliance Framework (GDPR, HIPAA, SOC2, PCI-DSS, ISO 27001, NIST 800-53)
- Columns: Control Categories (Access Control, Encryption, Audit, Network, Data Protection)
- Cell Color: Compliance % (Green >95%, Yellow 85-95%, Red <85%)
- Cell Value: Compliance score + trend arrow

---

## Dashboard 4: Policy Enforcement & Governance

### Required Dimensions & Measures

```lookml
# SCP Violation Detection (requires CloudTrail integration)
dimension: scp_violation_type {
  type: string
  sql:
    CASE
      WHEN ${resource_tags} LIKE '%SCPDenied:Region%' THEN 'Region Restriction'
      WHEN ${resource_tags} LIKE '%SCPDenied:Service%' THEN 'Service Restriction'
      WHEN ${resource_tags} LIKE '%SCPDenied:Resource%' THEN 'Resource Creation'
      WHEN ${resource_tags} LIKE '%SCPDenied:Privilege%' THEN 'Privilege Escalation'
      ELSE 'No Violation'
    END
  ;;
}

# Account Compliance Status
dimension: account_compliance_status {
  type: string
  sql:
    CASE
      WHEN ${tag_coverage_rate} >= 0.90 
        AND ${naming_standard_compliance} >= 0.85 
      THEN 'Compliant'
      WHEN ${tag_coverage_rate} >= 0.70 THEN 'Partial'
      ELSE 'Non-Compliant'
    END
  ;;
}

# Budget Variance
measure: budget_variance_pct {
  type: number
  sql:
    (${total_unblended_cost} - ${budget_amount}) * 100.0 / 
    NULLIF(${budget_amount}, 0)
  ;;
  value_format: "0.0\"%\""
}

# Budget Amount (requires external budget data or tags)
measure: budget_amount {
  type: sum
  sql:
    CAST(REGEXP_EXTRACT(${resource_tags}, r'Budget:([0-9]+)') AS INT64)
  ;;
}

# Orphaned Resources
measure: orphaned_resources_count {
  type: count_distinct
  sql: ${line_item_resource_id} ;;
  filters: [
    resource_tags: "%-Owner:-%",
    line_item_resource_id: "-%"
  ]
}

# Shadow IT Detection
measure: unapproved_service_cost {
  type: sum
  sql: ${line_item_unblended_cost} ;;
  filters: [
    resource_tags: "%-Approved:false%"
  ]
}

# IaC Managed Resources
measure: iac_managed_pct {
  type: number
  sql:
    COUNT(DISTINCT CASE
      WHEN ${resource_tags} LIKE '%ManagedBy:Terraform%'
        OR ${resource_tags} LIKE '%ManagedBy:CloudFormation%'
      THEN ${line_item_resource_id}
    END) * 100.0 / NULLIF(COUNT(DISTINCT ${line_item_resource_id}), 0)
  ;;
  value_format: "0.0\"%\""
}
```

---

## Dashboard 5: Risk & Vulnerability Management

### EPSS Risk Matrix Implementation

```lookml
# EPSS Score (from tags or external data)
dimension: epss_score {
  type: number
  sql:
    CAST(REGEXP_EXTRACT(${resource_tags}, r'EPSS:([0-9.]+)') AS FLOAT64)
  ;;
  value_format: "0.000"
}

# Business Impact Score
dimension: business_impact_score {
  type: number
  sql:
    CASE
      WHEN ${environment} = 'production' AND ${resource_tags} LIKE '%CriticalApp:true%' THEN 10
      WHEN ${environment} = 'production' THEN 8
      WHEN ${environment} = 'staging' THEN 5
      WHEN ${environment} = 'development' THEN 3
      ELSE 1
    END
  ;;
}

# Risk Quadrant
dimension: risk_quadrant {
  type: string
  sql:
    CASE
      WHEN ${epss_score} >= 0.7 AND ${business_impact_score} >= 8 THEN 'Critical - Immediate Action'
      WHEN ${epss_score} >= 0.7 OR ${business_impact_score} >= 8 THEN 'High - Priority Remediation'
      WHEN ${epss_score} >= 0.4 OR ${business_impact_score} >= 5 THEN 'Medium - Scheduled Remediation'
      ELSE 'Low - Monitor'
    END
  ;;
}

# Internet Exposure
dimension: is_internet_exposed {
  type: yesno
  sql:
    ${resource_tags} LIKE '%InternetFacing:true%'
    OR ${is_public_exposed}
  ;;
}

# Data Sensitivity Classification
dimension: data_sensitivity {
  type: string
  sql:
    CASE
      WHEN ${resource_tags} LIKE '%DataClass:PII%' THEN 'PII'
      WHEN ${resource_tags} LIKE '%DataClass:PHI%' THEN 'PHI'
      WHEN ${resource_tags} LIKE '%DataClass:PCI%' THEN 'PCI'
      WHEN ${resource_tags} LIKE '%DataClass:Confidential%' THEN 'Confidential'
      WHEN ${resource_tags} LIKE '%DataClass:Internal%' THEN 'Internal'
      ELSE 'Public'
    END
  ;;
}

# Attack Path Identified
dimension: has_attack_path {
  type: yesno
  sql: ${resource_tags} LIKE '%AttackPath:true%' ;;
}

# Compensating Controls
dimension: has_compensating_controls {
  type: yesno
  sql: ${resource_tags} LIKE '%CompensatingControl:%' ;;
}
```

### Vulnerability Dashboard Elements

1. **EPSS Risk Matrix** - Scatter plot (EPSS vs Business Impact)
2. **Attack Path Visualization** - Network graph (requires custom viz)
3. **Internet-Exposed Critical CVEs** - Table
4. **Data Sensitivity Exposure** - Heat map
5. **MTTR by Severity** - Bar chart
6. **Remediation Funnel** - Sankey diagram

---

## Dashboard 6: AI/ML Governance

### Required Fields (External ML Platform Integration)

```lookml
# Model Registry Status (requires SageMaker/MLflow integration)
dimension: model_registry_status {
  type: string
  sql:
    CASE
      WHEN ${resource_tags} LIKE '%MLModel:Registered%' THEN 'Registered'
      WHEN ${resource_tags} LIKE '%MLModel:Unregistered%' THEN 'Unregistered'
      ELSE 'N/A'
    END
  ;;
}

# Bias Check Status
dimension: bias_check_passed {
  type: yesno
  sql: ${resource_tags} LIKE '%BiasCheck:Passed%' ;;
}

# Explainability Coverage
dimension: has_explainability {
  type: yesno
  sql:
    ${resource_tags} LIKE '%Explainability:SHAP%'
    OR ${resource_tags} LIKE '%Explainability:LIME%'
  ;;
}

# Model Drift Detected
dimension: model_drift_status {
  type: string
  sql:
    CASE
      WHEN ${resource_tags} LIKE '%Drift:Critical%' THEN 'Critical Drift'
      WHEN ${resource_tags} LIKE '%Drift:Warning%' THEN 'Warning'
      WHEN ${resource_tags} LIKE '%Drift:Normal%' THEN 'Normal'
      ELSE 'Not Monitored'
    END
  ;;
}

# EU AI Act Risk Classification
dimension: eu_ai_act_risk {
  type: string
  sql:
    CASE
      WHEN ${resource_tags} LIKE '%AIRisk:Unacceptable%' THEN 'Unacceptable'
      WHEN ${resource_tags} LIKE '%AIRisk:High%' THEN 'High'
      WHEN ${resource_tags} LIKE '%AIRisk:Limited%' THEN 'Limited'
      WHEN ${resource_tags} LIKE '%AIRisk:Minimal%' THEN 'Minimal'
      ELSE 'Unclassified'
    END
  ;;
}

# Model Version
dimension: model_version {
  type: string
  sql: REGEXP_EXTRACT(${resource_tags}, r'ModelVersion:([0-9.]+)') ;;
}

# Governance Gate Status
dimension: governance_gate_passed {
  type: yesno
  sql:
    ${bias_check_passed}
    AND ${has_explainability}
    AND ${model_registry_status} = 'Registered'
  ;;
}
```

### AI/ML Dashboard Elements

1. **Model Lifecycle Funnel** - Registered → Validated → Deployed
2. **Bias Detection Results** - Bar chart by protected attribute
3. **Explainability Coverage** - Gauge
4. **Model Drift Alerts** - Timeline
5. **EU AI Act Compliance** - Risk classification matrix
6. **Governance Gate Pass Rate** - Single value with trend

---

## Dashboard 7: Sustainability & Carbon Footprint

### Carbon Metrics (AWS CCFT Integration)

```lookml
# Carbon Emissions (requires CCFT data integration)
measure: carbon_emissions_mt_co2e {
  type: sum
  sql:
    CAST(REGEXP_EXTRACT(${resource_tags}, r'CarbonMT:([0-9.]+)') AS FLOAT64)
  ;;
  value_format: "0.000"
  description: "Carbon emissions in metric tons CO2e"
}

# Carbon Intensity
measure: carbon_intensity_per_compute_hour {
  type: number
  sql:
    ${carbon_emissions_mt_co2e} / 
    NULLIF(SUM(${line_item_usage_amount}), 0)
  ;;
  value_format: "0.0000"
}

# Renewable Energy Alignment
measure: renewable_energy_pct {
  type: number
  sql:
    COUNT(DISTINCT CASE
      WHEN ${product_region_code} IN (
        'eu-north-1',  -- Sweden (high renewable)
        'ca-central-1', -- Canada
        'us-west-2'     -- Oregon (high renewable)
      )
      THEN ${line_item_resource_id}
    END) * 100.0 / NULLIF(COUNT(DISTINCT ${line_item_resource_id}), 0)
  ;;
  value_format: "0.0\"%\""
}

# Carbon Avoidance
measure: carbon_avoidance_mt_co2e {
  type: number
  sql:
    ${carbon_emissions_mt_co2e} * 4.1  -- 4.1x more efficient than on-prem
  ;;
  description: "Carbon avoided vs on-premises equivalent"
}

# Energy-Efficient Instance Usage
measure: graviton_instance_pct {
  type: number
  sql:
    COUNT(DISTINCT CASE
      WHEN ${product_instance_type} LIKE '%g%'  -- Graviton instances
      THEN ${line_item_resource_id}
    END) * 100.0 / NULLIF(COUNT(DISTINCT ${line_item_resource_id}), 0)
  ;;
  filters: [line_item_product_code: "AmazonEC2"]
  value_format: "0.0\"%\""
}

# Storage Optimization
measure: intelligent_tiering_pct {
  type: number
  sql:
    SUM(CASE
      WHEN ${resource_tags} LIKE '%StorageClass:INTELLIGENT_TIERING%'
      THEN ${line_item_unblended_cost}
      ELSE 0
    END) * 100.0 / NULLIF(SUM(${line_item_unblended_cost}), 0)
  ;;
  filters: [line_item_product_code: "AmazonS3"]
  value_format: "0.0\"%\""
}
```

### Sustainability Dashboard Elements

1. **Carbon Footprint Timeline** - Scope 1, 2, 3 stacked area
2. **Emissions by Service** - Pie chart
3. **Regional Carbon Intensity** - Map visualization
4. **Renewable Energy Alignment** - Progress bar
5. **Optimization Opportunities** - Table with carbon savings
6. **Green Architecture Metrics** - Graviton adoption, tiering, etc.

---

## Integration Requirements

### External Data Sources to Integrate

1. **AWS Security Hub** - Security findings with EPSS scores
2. **AWS Config** - Resource configuration compliance
3. **AWS CloudTrail** - SCP violations, API activity
4. **AWS Organizations** - Account structure, SCPs
5. **GRC Platform** - Compliance status, audit results
6. **AWS Customer Carbon Footprint Tool** - Emission data
7. **SageMaker/MLflow** - ML model metadata
8. **Third-party scanners** - Vulnerability data (Checkov, tfsec)

### Tagging Strategy Required

**Governance Tags:**
- `Owner`: Resource owner
- `CostCenter`: Billing allocation
- `Environment`: dev/stg/prod
- `Project`: Project identifier
- `ManagedBy`: Terraform/CloudFormation/Manual
- `DataClass`: PII/PHI/PCI/Confidential/Internal/Public
- `Approved`: true/false (shadow IT detection)
- `Budget`: Allocated budget

**Security Tags:**
- `Encrypted`: true/false
- `MFAEnabled`: true/false
- `PublicAccess`: true/false
- `ComplianceFramework`: GDPR/HIPAA/SOC2/PCI/ISO27001
- `FindingDate`: YYYY-MM-DD
- `EPSS`: 0.000-1.000
- `AttackPath`: true/false

**AI/ML Tags:**
- `MLModel`: Registered/Unregistered
- `BiasCheck`: Passed/Failed
- `Explainability`: SHAP/LIME/None
- `Drift`: Normal/Warning/Critical
- `AIRisk`: Unacceptable/High/Limited/Minimal
- `ModelVersion`: X.Y.Z

**Sustainability Tags:**
- `CarbonMT`: Metric tons CO2e
- `StorageClass`: INTELLIGENT_TIERING/STANDARD/etc.

---

## Dashboard Refresh & Performance

### Recommended Configuration

```lookml
# Performance optimizations for large datasets
- auto_run: false  # Require manual run for complex queries
- refresh: 30 minutes  # Cache refresh for real-time dashboards
- load_configuration: wait  # Wait for all tiles before display
- crossfilter_enabled: true  # Enable cross-filtering
```

### Query Optimization

1. **Use Aggregate Awareness** - Pre-aggregate tables for common queries
2. **Partition by Date** - Partition CUR table by usage_date
3. **Incremental PDTs** - For complex calculations
4. **Indexed Fields** - Index on account_id, product_code, region_code
5. **Query Result Caching** - Enable for frequently-run queries

---

**End of Technical Specifications**

*For LookML implementation examples, see dashboard files in /dashboards/governance/*
