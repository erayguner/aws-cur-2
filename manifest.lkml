project_name: "aws-billing"

# 💰 AWS CUR v2.0 FinOps Analytics Platform
# Manifest configuration for enterprise AWS billing analytics

# Looker Marketplace Visualizations for Enhanced Analytics
visualization: {
  id: "gauge_vis"
  url: "https://marketplace.looker.com/packages/gauge-vis/files/gauge.js"
  label: "Gauge Visualization"
}

visualization: {
  id: "bar_gauge_vis"
  url: "https://marketplace.looker.com/packages/bar-gauge-vis/files/bar_gauge.js"
  label: "Bar Gauge Visualization"
}

visualization: {
  id: "radial_gauge_vis"
  url: "https://marketplace.looker.com/packages/radial-gauge-vis/files/radial_gauge.js"
  label: "Radial Gauge Visualization"
}

visualization: {
  id: "multiple_value"
  url: "https://marketplace.looker.com/packages/multiple-value/files/multiple_value.js"
  label: "Multiple Value Visualization"
}

visualization: {
  id: "sankey_vis"
  url: "https://marketplace.looker.com/packages/sankey-vis/files/sankey.js"
  label: "Sankey Flow Visualization"
}

visualization: {
  id: "histogram_vis"
  url: "https://marketplace.looker.com/packages/histogram-vis/files/histogram.js"
  label: "Histogram Visualization"
}

visualization: {
  id: "report_table"
  url: "https://marketplace.looker.com/packages/report-table/files/report_table.js"
  label: "Enhanced Report Table"
}

visualization: {
  id: "kpi_vis"
  url: "https://marketplace.looker.com/packages/kpi-vis/files/kpi.js"
  label: "KPI Visualization"
}

visualization: {
  id: "treemap_vis"
  url: "https://marketplace.looker.com/packages/treemap-vis/files/treemap.js"
  label: "Treemap Visualization"
}

visualization: {
  id: "waterfall_vis"
  url: "https://marketplace.looker.com/packages/waterfall-vis/files/waterfall.js"
  label: "Waterfall Chart"
}

constant: CONNECTION_NAME {
  value: "@{AWS_BILLING_CONNECTION}"
  export: override_required
}

constant: AWS_BILLING_CONNECTION {
  value: "<Your existing connection name>"
  export: override_required
}

constant: AWS_SCHEMA_NAME {
  value: "cid_data_export"  # Your CUR database/schema name
  export: override_optional
}

constant: AWS_TABLE_NAME {
  value: "cur2"  # Your CUR table name
  export: override_optional
}

# FinOps Configuration
constant: FISCAL_YEAR_OFFSET {
  value: "0"  # Set to month offset for fiscal year (0 = calendar year)
  export: override_optional
}

constant: DEFAULT_CURRENCY {
  value: "USD"
  export: override_optional
}

constant: COST_THRESHOLD_HIGH {
  value: "10000"  # High cost threshold for alerting
  export: override_optional
}

constant: COST_THRESHOLD_MEDIUM {
  value: "1000"  # Medium cost threshold for optimization
  export: override_optional
}

# Performance optimization constants
constant: AGGREGATE_AWARENESS {
  value: "yes"
  export: override_optional
}

constant: MAX_CACHE_AGE {
  value: "2 hours"
  export: override_optional
}

# Optimization constants
constant: RI_UTILIZATION_THRESHOLD {
  value: "0.8"  # 80% Reserved Instance utilization target
  export: override_optional
}

constant: WASTE_THRESHOLD {
  value: "0"  # Usage threshold for waste detection
  export: override_optional
}

# Tag-based cost allocation
constant: PRIMARY_COST_CENTER_TAG {
  value: "user:CostCenter"  # Primary tag for cost allocation
  export: override_optional
}

constant: PRIMARY_PROJECT_TAG {
  value: "user:Project"  # Primary tag for project allocation
  export: override_optional
}

constant: PRIMARY_ENVIRONMENT_TAG {
  value: "user:Environment"  # Primary tag for environment allocation
  export: override_optional
}

constant: PRIMARY_OWNER_TAG {
  value: "user:Owner"  # Primary tag for ownership tracking
  export: override_optional
}

constant: PRIMARY_TEAM_TAG {
  value: "user:Team"  # Primary tag for team allocation
  export: override_optional
}



# In manifest.lkml
#LAMS
#rule: K1{} # Primary key naming
#rule: K3{} # Primary keys first
#rule: K4{} # Primary keys hidden
#rule: K7{} # Provide one `primary_key`
#rule: K8{} # `primary_key` uses PK dims
#rule: F1{} # No cross-view fields
#rule: F2{} # No view-labeled fields
#rule: F3{} # Count fields filtered
#rule: F4{} # Description or hidden
#rule: E1{} # Join with substitution operator
#rule: E2{} # Join on PK for "one" joins
#rule: E6{} # FK joins are m:1
#rule: E7{} # Explore label 25-char max
#rule: T1{} # Triggers use datagroups
#rule: T2{} # Primary keys in DT
#rule: H1{} # Hoist identifiers
#rule: H2{} # Group fields
#rule: H3{} # Sort-group groups
#rule: H4{} # Group more
#rule: H5{} # Hoist main view
#rule: H6{} # Sort-group views
#rule: W1{} # Block indentation