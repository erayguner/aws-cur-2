#!/usr/bin/env python3
"""
Ultimate Dashboard Fixer - Comprehensive solution for all 16 dashboards
Handles all required transformations:
1. Move filters to bottom
2. Wrap visualization properties in visualization_config
3. Add note_text to each element
4. Fix conditional_formatting structure
5. Ensure proper property order
"""

import re
from pathlib import Path
from typing import List, Dict

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

# Properties that should be wrapped in visualization_config
VIZ_PROPS = {
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
    'defaults_version', 'hidden_fields',
}

def get_indent(line):
    """Get indentation level"""
    return len(line) - len(line.lstrip())

def is_prop_start(line, prop_set):
    """Check if line starts a property from the given set"""
    stripped = line.strip()
    if ':' not in stripped:
        return False
    prop = stripped.split(':')[0]
    return prop in prop_set

def fix_dashboard_ultimate(filepath):
    """Ultimate dashboard fixer"""
    print(f"Processing {filepath.name}...")

    with open(filepath, 'r') as f:
        lines = f.readlines()

    # Step 1: Separate into header, elements, and filters
    header_lines = []
    elements_lines = []
    filters_lines = []

    section = 'header'

    for i, line in enumerate(lines):
        stripped = line.strip()

        if stripped.startswith('elements:'):
            section = 'elements'
            elements_lines.append(line)
        elif stripped.startswith('filters:') and section == 'header':
            section = 'filters'
            filters_lines.append(line)
        elif section == 'header':
            header_lines.append(line)
        elif section == 'elements':
            elements_lines.append(line)
        elif section == 'filters':
            filters_lines.append(line)

    # Step 2: Fix each element
    fixed_elements_lines = fix_elements_section(elements_lines)

    # Step 3: Rebuild file
    result = []
    result.extend(header_lines)
    result.extend(fixed_elements_lines)
    if filters_lines:
        result.append('\n')
        result.extend(filters_lines)

    with open(filepath, 'w') as f:
        f.writelines(result)

    print(f"  ✓ Successfully fixed")
    return True

def fix_elements_section(lines):
    """Fix all elements in the elements section"""
    if not lines or lines[0].strip() != 'elements:':
        return lines

    result = [lines[0]]  # Keep "elements:" line

    # Find element boundaries
    element_starts = []
    for i, line in enumerate(lines[1:], 1):
        if line.strip().startswith('- title:') or line.strip().startswith('- name:'):
            element_starts.append(i)

    # Process each element
    for idx, start in enumerate(element_starts):
        end = element_starts[idx + 1] if idx + 1 < len(element_starts) else len(lines)
        element_lines = lines[start:end]
        fixed_element = fix_single_element_ultimate(element_lines)
        result.extend(fixed_element)

    return result

def fix_single_element_ultimate(elem_lines):
    """Fix a single element - ultimate version"""
    if not elem_lines:
        return elem_lines

    # Check if text element
    if any('type: text' in line for line in elem_lines):
        return elem_lines

    # Parse element into sections
    metadata = []
    viz_config_props = []
    note_text = None
    listen_block = []
    position_props = []

    title = "Element"
    base_indent = get_indent(elem_lines[0]) + 2

    i = 0
    while i < len(elem_lines):
        line = elem_lines[i]
        stripped = line.strip()
        indent = get_indent(line)

        if not stripped:
            i += 1
            continue

        # Extract title
        if stripped.startswith('title:'):
            match = re.search(r'title:\s*(.+?)\s*$', stripped)
            if match:
                # Remove quotes if present
                title_raw = match.group(1).strip()
                if title_raw.startswith(('"', "'")):
                    title = title_raw[1:-1] if len(title_raw) > 1 and title_raw[0] == title_raw[-1] else title_raw
                else:
                    title = title_raw
            metadata.append(line)
            i += 1
            continue

        # Check for note_text
        if stripped.startswith('note_text:'):
            note_text = line
            i += 1
            continue

        # Check for visualization_config block (already exists)
        if stripped.startswith('visualization_config:'):
            # Skip this element, it's already fixed
            return elem_lines

        # Position properties
        if stripped.startswith(('row:', 'col:', 'width:', 'height:')):
            position_props.append(line)
            i += 1
            continue

        # Listen block
        if stripped.startswith('listen:'):
            listen_block.append(line)
            i += 1
            # Collect nested listen properties
            while i < len(elem_lines):
                next_line = elem_lines[i]
                next_indent = get_indent(next_line)
                if next_indent > indent and next_line.strip():
                    listen_block.append(next_line)
                    i += 1
                else:
                    break
            continue

        # Check if this is a visualization property
        prop = stripped.split(':')[0] if ':' in stripped else ''
        if prop in VIZ_PROPS:
            viz_config_props.append(line)
            i += 1
            # Collect nested properties (like conditional_formatting items, y_axes, etc.)
            while i < len(elem_lines):
                next_line = elem_lines[i]
                next_indent = get_indent(next_line)
                next_stripped = next_line.strip()
                # Check if this is a nested property
                if next_indent > indent or (next_stripped.startswith('-') and next_indent >= indent):
                    viz_config_props.append(next_line)
                    i += 1
                else:
                    break
            continue

        # Everything else is metadata
        metadata.append(line)
        i += 1

    # Rebuild element
    result = []

    # 1. Add metadata
    result.extend(metadata)

    # 2. Add visualization_config if we have viz properties
    if viz_config_props:
        result.append(' ' * base_indent + 'visualization_config:\n')
        for line in viz_config_props:
            # Increase indentation by 2 spaces
            result.append('  ' + line)

    # 3. Add note_text
    if note_text:
        result.append(note_text)
    else:
        result.append(' ' * base_indent + f'note_text: "{title} visualization"\n')

    # 4. Add listen block
    result.extend(listen_block)

    # 5. Add position properties
    result.extend(position_props)

    return result

def main():
    """Main function"""
    dashboards_dir = Path('/home/user/aws-cur-2/dashboards')

    success = 0
    for dashboard_name in DASHBOARDS:
        filepath = dashboards_dir / dashboard_name
        if filepath.exists():
            try:
                if fix_dashboard_ultimate(filepath):
                    success += 1
            except Exception as e:
                print(f"  ✗ Error: {e}")
                import traceback
                traceback.print_exc()
        else:
            print(f"✗ File not found: {dashboard_name}")

    print(f"\n{'='*60}")
    print(f"Completed! Fixed {success}/{len(DASHBOARDS)} dashboards")
    print(f"{'='*60}")

if __name__ == '__main__':
    main()
