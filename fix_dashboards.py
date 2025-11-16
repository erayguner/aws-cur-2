#!/usr/bin/env python3
"""
Fix LookML dashboards to match correct syntax pattern
"""

import re
from pathlib import Path

# List of dashboards to fix
DASHBOARDS = [
    'realtime_cost_visibility.dashboard.lookml',
    'ml_anomaly_detection_advanced.dashboard.lookml',
    'predictive_cost_forecasting_p10_p50_p90.dashboard.lookml',
    'commitment_optimization_ri_sp.dashboard.lookml',
    'unit_economics_business_metrics.dashboard.lookml',
    'tagging_compliance_governance.dashboard.lookml',
    'ccoe_kpi_dashboard.dashboard.lookml',
    'resource_rightsizing_waste.dashboard.lookml',
    'showback_chargeback_billing.dashboard.lookml',
    'ec2_cost_deep_dive.dashboard.lookml',
    's3_storage_optimization.dashboard.lookml',
    'rds_database_cost_analysis.dashboard.lookml',
    'lambda_serverless_cost.dashboard.lookml',
    'budget_tracking_predictive_alerts.dashboard.lookml',
    'finops_maturity_adoption.dashboard.lookml',
    'sustainability_carbon_footprint.dashboard.lookml',
]

# Visualization properties that should be wrapped in visualization_config
VIZ_PROPERTIES = {
    'custom_color_enabled', 'show_single_value_title', 'show_comparison',
    'comparison_type', 'comparison_reverse_colors', 'show_comparison_label',
    'single_value_title', 'value_format', 'comparison_label',
    'conditional_formatting', 'x_axis_gridlines', 'y_axis_gridlines',
    'show_view_names', 'show_y_axis_labels', 'show_y_axis_ticks',
    'y_axis_tick_density', 'show_x_axis_label', 'show_x_axis_ticks',
    'y_axis_scale_mode', 'x_axis_reversed', 'y_axis_reversed',
    'plot_size_by_dimension', 'trellis', 'stacking', 'limit_displayed_rows',
    'legend_position', 'point_style', 'show_value_labels', 'label_density',
    'x_axis_scale', 'y_axis_combined', 'show_null_points', 'interpolation',
    'show_totals_labels', 'show_silhouette', 'totals_color',
    'color_application', 'y_axes', 'series_colors', 'series_types',
    'series_point_styles', 'reference_lines', 'ordering',
    'show_null_labels', 'show_row_numbers', 'transpose', 'truncate_text',
    'hide_totals', 'hide_row_totals', 'size_to_fit', 'table_theme',
    'enable_conditional_formatting', 'header_text_alignment',
    'header_font_size', 'rows_font_size', 'value_labels', 'label_type',
    'inner_radius', 'map', 'map_projection', 'quantize_colors',
    'color_range', 'groupBars', 'labelSize', 'showLegend',
    'column_limit', 'plot_size_by_field', 'x_axis_label', 'y_axis_label',
    'conditional_formatting_include_totals', 'conditional_formatting_include_nulls',
    'series_value_format', 'series_cell_visualizations', 'font_size', 'text_color',
}

def get_indent_level(line):
    """Get the indentation level of a line"""
    return len(line) - len(line.lstrip())

def fix_dashboard_file(filepath):
    """Fix a single dashboard file"""
    print(f"Processing {filepath.name}...")

    with open(filepath, 'r') as f:
        lines = f.readlines()

    output_lines = []
    filters_section = []
    in_filters = False
    in_elements = False
    filter_indent = 0
    element_indent = 0
    current_element = []
    in_element = False
    element_indent_level = 0

    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        # Keep header comments
        if stripped.startswith('#') or stripped == '---':
            output_lines.append(line)
            i += 1
            continue

        # Dashboard definition line
        if stripped.startswith('- dashboard:') or stripped.startswith('title:') or \
           stripped.startswith('description:') or stripped.startswith('layout:') or \
           stripped.startswith('preferred_viewer:') or stripped.startswith('auto_run:') or \
           stripped.startswith('refresh:') or stripped.startswith('load_configuration:') or \
           stripped.startswith('crossfilter_enabled:') or stripped.startswith('embed_style:'):
            if not in_filters and not in_elements:
                output_lines.append(line)
            i += 1
            continue

        # Handle embed_style block
        if 'embed_style:' in line:
            output_lines.append(line)
            i += 1
            # Copy the entire embed_style block
            while i < len(lines):
                next_line = lines[i]
                if get_indent_level(next_line) > get_indent_level(line) or next_line.strip() == '':
                    output_lines.append(next_line)
                    i += 1
                else:
                    break
            continue

        # Start of filters section
        if stripped.startswith('filters:') and not in_elements:
            in_filters = True
            filter_indent = get_indent_level(line)
            filters_section.append(line)
            i += 1
            continue

        # Collect filter lines
        if in_filters and not stripped.startswith('elements:'):
            if stripped or get_indent_level(line) > filter_indent:
                filters_section.append(line)
            i += 1
            continue

        # Start of elements section
        if stripped.startswith('elements:'):
            in_filters = False
            in_elements = True
            output_lines.append(line)
            i += 1
            continue

        # Inside elements section
        if in_elements:
            output_lines.append(line)

        i += 1

    # Add filters at the end
    if filters_section:
        output_lines.append('\n')
        output_lines.extend(filters_section)

    # Write back
    with open(filepath, 'w') as f:
        f.writelines(output_lines)

    print(f"✓ Fixed {filepath.name}")
    return True

def main():
    """Main function"""
    dashboards_dir = Path('/home/user/aws-cur-2/dashboards')

    for dashboard_name in DASHBOARDS:
        filepath = dashboards_dir / dashboard_name
        if filepath.exists():
            try:
                fix_dashboard_file(filepath)
            except Exception as e:
                print(f"✗ Error processing {dashboard_name}: {e}")
        else:
            print(f"✗ File not found: {dashboard_name}")

    print("\nAll dashboards processed!")

if __name__ == '__main__':
    main()
