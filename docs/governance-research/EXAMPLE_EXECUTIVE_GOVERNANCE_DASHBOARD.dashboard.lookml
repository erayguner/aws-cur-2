---
# =====================================================
# EXECUTIVE GOVERNANCE SCORECARD DASHBOARD (EXAMPLE)
# =====================================================
# This is a reference implementation showing how to build
# governance dashboards using AWS CUR 2.0 data
# =====================================================

- dashboard: executive_governance_scorecard
  title: "Executive Governance Scorecard"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Comprehensive governance health monitoring for executives and board-level reporting. Tracks security posture, compliance status, policy enforcement, and operational governance metrics."

  # Performance optimizations
  auto_run: false
  refresh: 30 minutes
  load_configuration: wait
  crossfilter_enabled: true

  # Dashboard styling
  embed_style:
    background_color: '#f8fafc'
    show_title: true
    show_filters_bar: true
    tile_text_color: '#1e293b'
    tile_background_color: '#ffffff'

  # =====================================================
  # FILTERS
  # =====================================================
  
  filters:
  - name: time_period
    title: "Time Period"
    type: field_filter
    default_value: "30 days"
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
    field: cur2.line_item_usage_start_date

  - name: aws_account
    title: "AWS Account"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
    model: aws_billing
    explore: cur2
    field: cur2.line_item_usage_account_name

  - name: environment
    title: "Environment"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: aws_billing
    explore: cur2
    field: cur2.environment

  - name: compliance_framework
    title: "Compliance Framework"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options:
      - GDPR
      - HIPAA
      - SOC2
      - PCI-DSS
      - ISO27001
      - NIST800-53
    model: aws_billing
    explore: cur2
    field: cur2.compliance_framework

  # =====================================================
  # ELEMENTS - ROW 0: HEADER
  # =====================================================

  elements:
  - name: dashboard_header
    type: text
    title_text: "<h1>🛡️ Executive Governance Scorecard</h1>"
    subtitle_text: "Comprehensive Cloud Governance Health Monitoring"
    body_text: |
      <div style='font-size: 14px; color: #64748b; line-height: 1.6;'>
      <p><strong>Purpose:</strong> Real-time visibility into cloud governance posture across security, compliance, policy enforcement, and operational maturity.</p>
      <p><strong>Update Frequency:</strong> Refreshed every 30 minutes | <strong>Data Source:</strong> AWS Cost & Usage Report 2.0</p>
      <p><strong>Target Audience:</strong> C-Suite, Board of Directors, Governance Committees</p>
      </div>
    row: 0
    col: 0
    width: 24
    height: 3

  # =====================================================
  # ELEMENTS - ROW 3: KEY PERFORMANCE INDICATORS
  # =====================================================

  - title: "Overall Governance Health"
    name: governance_health_score
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.governance_health_score]
    limit: 1
    visualization_config:
      type: single_value
      show_single_value_title: true
      single_value_title: "GOVERNANCE HEALTH SCORE"
      value_format: "0"
      show_comparison: true
      comparison_type: "progress_percentage"
      comparison_reverse_colors: false
      comparison_label: "vs Target (85)"
      font_size: xx-large
      text_color: "#1e293b"
      conditional_formatting:
      - type: greater than
        value: 85
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
      - type: between
        value: [70, 85]
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
      - type: less than
        value: 70
        background_color: "#fee2e2"
        font_color: "#991b1b"
        bold: true
    note_text: "Composite score: Security (35%), Compliance (30%), Policy (20%), Operations (15%)"
    listen:
      time_period: cur2.line_item_usage_start_date
      aws_account: cur2.line_item_usage_account_name
      environment: cur2.environment
    row: 3
    col: 0
    width: 6
    height: 5

  - title: "Security Posture Score"
    name: security_posture_score
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.security_posture_score]
    limit: 1
    visualization_config:
      gauge_fill_type: "arc"
      gauge_fill_colors: ["#dc2626", "#f59e0b", "#10b981"]
      angle_range: 270
      cutout: 60
      range_max: 100
      range_min: 0
      show_value_labels: true
      value_format: "0"
      font_size: large
      inner_radius: 60
      show_title: true
      title_text: "SECURITY POSTURE"
    note_text: "IAM (30%), Encryption (25%), Network (20%), Vulnerabilities (25%)"
    listen:
      time_period: cur2.line_item_usage_start_date
      aws_account: cur2.line_item_usage_account_name
      environment: cur2.environment
    row: 3
    col: 6
    width: 6
    height: 5

  - title: "Compliance Status"
    name: compliance_score
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.compliance_score, cur2.compliance_score_previous_period]
    limit: 1
    visualization_config:
      type: single_value
      show_single_value_title: true
      single_value_title: "COMPLIANCE SCORE"
      value_format: "0\"%\""
      show_comparison: true
      comparison_type: "change"
      comparison_reverse_colors: false
      comparison_label: "vs Previous Period"
      font_size: xx-large
      conditional_formatting:
      - type: greater than
        value: 95
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
      - type: between
        value: [85, 95]
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
      - type: less than
        value: 85
        background_color: "#fee2e2"
        font_color: "#991b1b"
        bold: true
    note_text: "Multi-framework compliance across GDPR, HIPAA, SOC2, PCI-DSS, ISO 27001"
    listen:
      time_period: cur2.line_item_usage_start_date
      aws_account: cur2.line_item_usage_account_name
      compliance_framework: cur2.compliance_framework
    row: 3
    col: 12
    width: 6
    height: 5

  - title: "Critical Findings"
    name: critical_findings
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.critical_findings_count]
    limit: 1
    visualization_config:
      type: single_value
      show_single_value_title: true
      single_value_title: "CRITICAL FINDINGS"
      value_format: "#,##0"
      show_comparison: false
      font_size: xx-large
      text_color: "#dc2626"
      conditional_formatting:
      - type: equal to
        value: 0
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
      - type: between
        value: [1, 10]
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
      - type: greater than
        value: 10
        background_color: "#fee2e2"
        font_color: "#991b1b"
        bold: true
    note_text: "Public exposure + unencrypted sensitive data + critical CVEs"
    listen:
      time_period: cur2.line_item_usage_start_date
      aws_account: cur2.line_item_usage_account_name
      environment: cur2.environment
    row: 3
    col: 18
    width: 6
    height: 5

  # =====================================================
  # ELEMENTS - ROW 8: SCORE BREAKDOWN
  # =====================================================

  - name: section_header_breakdown
    type: text
    title_text: "<h3>📊 Governance Score Breakdown</h3>"
    subtitle_text: "Detailed metrics across security, compliance, policy, and operations"
    body_text: ""
    row: 8
    col: 0
    width: 24
    height: 2

  - title: "Security Score Components"
    name: security_score_breakdown
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: 
    - cur2.iam_compliance_score
    - cur2.encryption_coverage_pct
    - cur2.network_security_score
    - cur2.vulnerability_remediation_score
    pivots: []
    sorts: [cur2.iam_compliance_score desc]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    x_axis_label: "Security Component"
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ""
    stacking: ""
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes:
    - label: "Score (0-100)"
      orientation: left
      series:
      - axisId: score
        id: score
        name: "Security Score"
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
      maxValue: 100
      minValue: 0
    series_colors:
      cur2.iam_compliance_score: "#3b82f6"
      cur2.encryption_coverage_pct: "#10b981"
      cur2.network_security_score: "#f59e0b"
      cur2.vulnerability_remediation_score: "#8b5cf6"
    reference_lines:
    - reference_type: line
      range_start: max
      range_end: min
      margin_top: undefined
      margin_value: mean
      margin_bottom: undefined
      label_position: right
      color: "#dc2626"
      line_value: 90
      label: "Target: 90"
    listen:
      time_period: cur2.line_item_usage_start_date
      aws_account: cur2.line_item_usage_account_name
      environment: cur2.environment
    row: 10
    col: 0
    width: 12
    height: 6

  - title: "Policy Compliance Metrics"
    name: policy_compliance_breakdown
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields:
    - cur2.tag_coverage_rate
    - cur2.naming_standard_compliance
    - cur2.budget_compliance_pct
    - cur2.iac_managed_pct
    sorts: [cur2.tag_coverage_rate desc]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    x_axis_label: "Compliance %"
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ""
    stacking: ""
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes:
    - label: ""
      orientation: bottom
      series:
      - axisId: compliance
        id: compliance
        name: "Compliance %"
      showLabels: true
      showValues: true
      maxValue: 100
      minValue: 0
    series_labels:
      cur2.tag_coverage_rate: "Tagging Compliance"
      cur2.naming_standard_compliance: "Naming Standards"
      cur2.budget_compliance_pct: "Budget Adherence"
      cur2.iac_managed_pct: "IaC Adoption"
    series_colors:
      cur2.tag_coverage_rate: "#10b981"
      cur2.naming_standard_compliance: "#3b82f6"
      cur2.budget_compliance_pct: "#f59e0b"
      cur2.iac_managed_pct: "#8b5cf6"
    reference_lines:
    - reference_type: line
      range_start: max
      range_end: min
      margin_top: undefined
      margin_value: mean
      margin_bottom: undefined
      label_position: right
      color: "#dc2626"
      line_value: 90
      label: "Target: 90%"
    listen:
      time_period: cur2.line_item_usage_start_date
      aws_account: cur2.line_item_usage_account_name
      environment: cur2.environment
    row: 10
    col: 12
    width: 12
    height: 6

  # =====================================================
  # ELEMENTS - ROW 16: COMPLIANCE BY FRAMEWORK
  # =====================================================

  - name: section_header_compliance
    type: text
    title_text: "<h3>✅ Compliance Status by Framework</h3>"
    subtitle_text: "Multi-framework regulatory compliance tracking"
    body_text: ""
    row: 16
    col: 0
    width: 24
    height: 2

  - title: "Compliance Framework Status"
    name: compliance_framework_status
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.compliance_framework
    - cur2.compliance_score
    - cur2.control_count_implemented
    - cur2.control_count_total
    - cur2.last_audit_date
    - cur2.next_audit_date
    - cur2.certification_status
    sorts: [cur2.compliance_score desc]
    limit: 500
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '11'
    conditional_formatting:
    - type: greater than
      value: 95
      background_color: "#dcfce7"
      font_color: "#166534"
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.compliance_score]
    - type: between
      value: [85, 95]
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.compliance_score]
    - type: less than
      value: 85
      background_color: "#fee2e2"
      font_color: "#991b1b"
      bold: true
      italic: false
      strikethrough: false
      fields: [cur2.compliance_score]
    series_labels:
      cur2.compliance_framework: "Framework"
      cur2.compliance_score: "Score (%)"
      cur2.control_count_implemented: "Controls Met"
      cur2.control_count_total: "Total Controls"
      cur2.last_audit_date: "Last Audit"
      cur2.next_audit_date: "Next Audit"
      cur2.certification_status: "Status"
    listen:
      time_period: cur2.line_item_usage_start_date
      aws_account: cur2.line_item_usage_account_name
      compliance_framework: cur2.compliance_framework
    row: 18
    col: 0
    width: 12
    height: 6

  - title: "Compliance Radar Chart"
    name: compliance_radar
    model: aws_billing
    explore: cur2
    type: looker_radar
    fields:
    - cur2.compliance_framework
    - cur2.compliance_score
    sorts: [cur2.compliance_framework]
    limit: 500
    visualization_config:
      type: "radial"
      show_value_labels: true
      font_size: 12
      hide_legend: false
      point_style: "circle"
      series_colors:
        cur2.compliance_score: "#3b82f6"
    listen:
      time_period: cur2.line_item_usage_start_date
      aws_account: cur2.line_item_usage_account_name
      compliance_framework: cur2.compliance_framework
    row: 18
    col: 12
    width: 12
    height: 6

  # =====================================================
  # ELEMENTS - ROW 24: CRITICAL FINDINGS
  # =====================================================

  - name: section_header_findings
    type: text
    title_text: "<h3>🚨 Critical Findings Requiring Immediate Action</h3>"
    subtitle_text: "High-priority security and compliance issues"
    body_text: ""
    row: 24
    col: 0
    width: 24
    height: 2

  - title: "Top 10 Critical Security Findings"
    name: critical_findings_table
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.finding_type
    - cur2.line_item_product_code
    - cur2.line_item_resource_id
    - cur2.environment
    - cur2.line_item_usage_account_name
    - cur2.risk_score
    - cur2.total_unblended_cost
    - cur2.days_since_finding
    filters:
      cur2.misconfiguration_severity: "Critical"
    sorts: [cur2.risk_score desc]
    limit: 10
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '11'
    rows_font_size: '10'
    conditional_formatting:
    - type: greater than
      value: 90
      background_color: "#fee2e2"
      font_color: "#991b1b"
      bold: true
      italic: false
      strikethrough: false
      fields: [cur2.risk_score]
    - type: greater than
      value: 7
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.days_since_finding]
    series_labels:
      cur2.finding_type: "Finding Type"
      cur2.line_item_product_code: "Service"
      cur2.line_item_resource_id: "Resource ID"
      cur2.environment: "Environment"
      cur2.line_item_usage_account_name: "Account"
      cur2.risk_score: "Risk Score"
      cur2.total_unblended_cost: "Monthly Cost"
      cur2.days_since_finding: "Days Open"
    listen:
      time_period: cur2.line_item_usage_start_date
      aws_account: cur2.line_item_usage_account_name
      environment: cur2.environment
    row: 26
    col: 0
    width: 24
    height: 8

  # =====================================================
  # ELEMENTS - ROW 34: TRENDS & INSIGHTS
  # =====================================================

  - name: section_header_trends
    type: text
    title_text: "<h3>📈 Governance Trends & Insights</h3>"
    subtitle_text: "Historical trends and predictive analytics"
    body_text: ""
    row: 34
    col: 0
    width: 24
    height: 2

  - title: "Governance Health Trend (12 Months)"
    name: governance_health_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields:
    - cur2.line_item_usage_start_month
    - cur2.governance_health_score
    - cur2.security_posture_score
    - cur2.compliance_score
    - cur2.policy_compliance_score
    fill_fields: [cur2.line_item_usage_start_month]
    filters:
      cur2.line_item_usage_start_date: "12 months"
    sorts: [cur2.line_item_usage_start_month]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    x_axis_label: "Month"
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ""
    stacking: ""
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes:
    - label: "Score (0-100)"
      orientation: left
      series:
      - axisId: cur2.governance_health_score
        id: cur2.governance_health_score
        name: "Overall Health"
      - axisId: cur2.security_posture_score
        id: cur2.security_posture_score
        name: "Security"
      - axisId: cur2.compliance_score
        id: cur2.compliance_score
        name: "Compliance"
      - axisId: cur2.policy_compliance_score
        id: cur2.policy_compliance_score
        name: "Policy"
      showLabels: true
      showValues: true
      maxValue: 100
      minValue: 0
    series_colors:
      cur2.governance_health_score: "#1e293b"
      cur2.security_posture_score: "#3b82f6"
      cur2.compliance_score: "#10b981"
      cur2.policy_compliance_score: "#f59e0b"
    series_labels:
      cur2.governance_health_score: "Overall Governance Health"
      cur2.security_posture_score: "Security Posture"
      cur2.compliance_score: "Compliance Status"
      cur2.policy_compliance_score: "Policy Compliance"
    reference_lines:
    - reference_type: line
      range_start: max
      range_end: min
      margin_top: undefined
      margin_value: mean
      margin_bottom: undefined
      label_position: right
      color: "#dc2626"
      line_value: 85
      label: "Target: 85"
    listen:
      aws_account: cur2.line_item_usage_account_name
      environment: cur2.environment
    row: 36
    col: 0
    width: 24
    height: 8

  # =====================================================
  # ELEMENTS - ROW 44: OPERATIONAL METRICS
  # =====================================================

  - name: section_header_operations
    type: text
    title_text: "<h3>⚙️ Operational Governance Metrics</h3>"
    subtitle_text: "Change management, IaC adoption, and FinOps maturity"
    body_text: ""
    row: 44
    col: 0
    width: 24
    height: 2

  - title: "IaC Adoption by Service"
    name: iac_adoption
    model: aws_billing
    explore: cur2
    type: looker_column
    fields:
    - cur2.line_item_product_code
    - cur2.iac_managed_pct
    - cur2.total_unblended_cost
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ""
    stacking: ""
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes:
    - label: "IaC Adoption %"
      orientation: left
      series:
      - axisId: cur2.iac_managed_pct
        id: cur2.iac_managed_pct
        name: "IaC %"
      showLabels: true
      showValues: true
      maxValue: 100
      minValue: 0
    - label: "Monthly Cost"
      orientation: right
      series:
      - axisId: cur2.total_unblended_cost
        id: cur2.total_unblended_cost
        name: "Cost"
      showLabels: true
      showValues: true
    series_colors:
      cur2.iac_managed_pct: "#8b5cf6"
      cur2.total_unblended_cost: "#f59e0b"
    listen:
      time_period: cur2.line_item_usage_start_date
      aws_account: cur2.line_item_usage_account_name
      environment: cur2.environment
    row: 46
    col: 0
    width: 12
    height: 6

  - title: "FinOps Maturity Progression"
    name: finops_maturity
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields:
    - cur2.finops_capability
    - cur2.finops_maturity_score
    - cur2.finops_maturity_target
    sorts: [cur2.finops_maturity_score desc]
    limit: 6
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    show_x_axis_label: true
    x_axis_label: "Maturity Score"
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ""
    stacking: ""
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes:
    - label: ""
      orientation: bottom
      series:
      - axisId: cur2.finops_maturity_score
        id: cur2.finops_maturity_score
        name: "Current"
      - axisId: cur2.finops_maturity_target
        id: cur2.finops_maturity_target
        name: "Target"
      showLabels: true
      showValues: true
      maxValue: 100
      minValue: 0
    series_colors:
      cur2.finops_maturity_score: "#10b981"
      cur2.finops_maturity_target: "#cbd5e1"
    series_labels:
      cur2.finops_capability: "Capability"
      cur2.finops_maturity_score: "Current Maturity"
      cur2.finops_maturity_target: "Target Maturity"
    listen:
      time_period: cur2.line_item_usage_start_date
      aws_account: cur2.line_item_usage_account_name
    row: 46
    col: 12
    width: 12
    height: 6

  # =====================================================
  # ELEMENTS - ROW 52: RECOMMENDATIONS
  # =====================================================

  - name: section_header_recommendations
    type: text
    title_text: "<h3>💡 Recommended Actions</h3>"
    subtitle_text: "AI-powered governance improvement recommendations"
    body_text: ""
    row: 52
    col: 0
    width: 24
    height: 2

  - title: "Top Governance Improvement Opportunities"
    name: recommendations
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.recommendation_priority
    - cur2.recommendation_category
    - cur2.recommendation_description
    - cur2.potential_risk_reduction
    - cur2.estimated_effort
    - cur2.cost_impact
    sorts: [cur2.recommendation_priority]
    limit: 10
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '11'
    rows_font_size: '10'
    conditional_formatting:
    - type: equal to
      value: "High"
      background_color: "#fee2e2"
      font_color: "#991b1b"
      bold: true
      italic: false
      strikethrough: false
      fields: [cur2.recommendation_priority]
    - type: equal to
      value: "Medium"
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.recommendation_priority]
    series_labels:
      cur2.recommendation_priority: "Priority"
      cur2.recommendation_category: "Category"
      cur2.recommendation_description: "Recommendation"
      cur2.potential_risk_reduction: "Risk Reduction"
      cur2.estimated_effort: "Effort"
      cur2.cost_impact: "Cost Impact"
    listen:
      time_period: cur2.line_item_usage_start_date
      aws_account: cur2.line_item_usage_account_name
      environment: cur2.environment
    row: 54
    col: 0
    width: 24
    height: 8

---

# =====================================================
# NOTES:
# =====================================================
# 
# This dashboard requires the following custom fields
# to be added to the cur2.view.lkml file:
#
# Measures:
# - governance_health_score
# - security_posture_score
# - compliance_score
# - iam_compliance_score
# - encryption_coverage_pct
# - network_security_score
# - vulnerability_remediation_score
# - critical_findings_count
# - tag_coverage_rate
# - naming_standard_compliance
# - budget_compliance_pct
# - iac_managed_pct
# - finops_maturity_score
#
# Dimensions:
# - compliance_framework
# - misconfiguration_severity
# - finding_type
# - risk_score
# - days_since_finding
# - finops_capability
#
# See DASHBOARD_SPECIFICATIONS.md for complete field
# definitions and implementation details.
#
# =====================================================
