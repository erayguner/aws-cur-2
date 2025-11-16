#!/usr/bin/env python3
"""
Comprehensive LookML Dashboard Fixer
Fixes all 16 newly created dashboards to match the correct syntax pattern
"""

import re
from pathlib import Path
from typing import List, Dict, Tuple

# Dashboards to fix
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

# Visualization properties that should be in visualization_config
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
    'defaults_version', 'plot_size_by_dimension', 'hidden_fields',
}

def get_indent(line: str) -> int:
    """Get indentation level"""
    return len(line) - len(line.lstrip())

def parse_dashboard(filepath: Path) -> Tuple[List[str], List[str], List[str], List[str]]:
    """
    Parse dashboard into sections:
    - header (comments and metadata)
    - filters
    - elements
    - footer
    """
    with open(filepath, 'r') as f:
        lines = f.readlines()

    header = []
    filters = []
    elements = []

    section = 'header'
    base_indent = 0

    for i, line in enumerate(lines):
        stripped = line.strip()

        # Comments and document separator
        if stripped.startswith('#') or stripped == '---':
            if section == 'header':
                header.append(line)
            continue

        # Dashboard metadata
        if section == 'header' and (
            stripped.startswith('- dashboard:') or
            stripped.startswith('title:') or
            stripped.startswith('description:') or
            stripped.startswith('layout:') or
            stripped.startswith('preferred_viewer:') or
            stripped.startswith('auto_run:') or
            stripped.startswith('refresh:') or
            stripped.startswith('load_configuration:') or
            stripped.startswith('crossfilter_enabled:')
        ):
            header.append(line)
            if stripped.startswith('- dashboard:'):
                base_indent = get_indent(line)
            continue

        # Embed style block
        if 'embed_style:' in line:
            header.append(line)
            # Capture the entire embed_style block
            j = i + 1
            while j < len(lines):
                next_line = lines[j]
                if get_indent(next_line) > get_indent(line) or next_line.strip() == '':
                    header.append(next_line)
                    j += 1
                else:
                    break
            continue

        # Filters section
        if stripped.startswith('filters:'):
            section = 'filters'
            filters.append(line)
            continue

        if section == 'filters':
            if stripped.startswith('elements:'):
                section = 'elements'
                elements.append(line)
            elif stripped or get_indent(line) > base_indent:
                filters.append(line)
            continue

        # Elements section
        if section == 'elements':
            elements.append(line)

    return header, filters, elements

def fix_element(elem_lines: List[str], base_indent: int) -> List[str]:
    """Fix a single element by wrapping viz properties and adding note_text"""
    if not elem_lines:
        return elem_lines

    # Check if this is a text element (don't modify)
    is_text_element = any('type: text' in line for line in elem_lines)
    if is_text_element:
        return elem_lines

    # Parse element
    result = []
    viz_config_lines = []
    element_meta = []
    has_note_text = False
    has_viz_config = False
    title = "Element"
    in_nested_block = False
    nested_indent = 0

    for line in elem_lines:
        stripped = line.strip()
        indent_level = get_indent(line)

        # Check for title
        if stripped.startswith('title:'):
            title = stripped.split(':', 1)[1].strip().strip('"')
            element_meta.append(line)
            continue

        # Check for note_text
        if stripped.startswith('note_text:'):
            has_note_text = True
            element_meta.append(line)
            continue

        # Check for visualization_config
        if stripped.startswith('visualization_config:'):
            has_viz_config = True
            viz_config_lines.append(line)
            in_nested_block = True
            nested_indent = indent_level
            continue

        # Handle nested blocks (y_axes, series_colors, etc.)
        if in_nested_block:
            if indent_level > nested_indent or stripped == '':
                viz_config_lines.append(line)
                continue
            else:
                in_nested_block = False

        # Check if this is a visualization property
        prop_name = stripped.split(':')[0] if ':' in stripped else ''
        if prop_name in VIZ_PROPERTIES:
            # This should go in visualization_config
            viz_config_lines.append(' ' * (base_indent + 4) + stripped + '\n')
            # Handle multi-line properties
            j = elem_lines.index(line) + 1
            while j < len(elem_lines):
                next_line = elem_lines[j]
                if get_indent(next_line) > indent_level:
                    viz_config_lines.append(' ' * (base_indent + 4) + next_line.strip() + '\n')
                    j += 1
                else:
                    break
        else:
            element_meta.append(line)

    # Rebuild element
    result = []

    # Add element metadata
    for line in element_meta:
        if not (line.strip().startswith('row:') or line.strip().startswith('col:') or
                line.strip().startswith('width:') or line.strip().startswith('height:')):
            result.append(line)

    # Add visualization_config if there are viz properties
    if viz_config_lines and not has_viz_config:
        result.append(' ' * (base_indent + 2) + 'visualization_config:\n')
        result.extend(viz_config_lines)
    elif has_viz_config:
        result.extend(viz_config_lines)

    # Add note_text if missing
    if not has_note_text:
        result.append(' ' * (base_indent + 2) + f'note_text: "{title} visualization"\n')

    # Add position properties (row, col, width, height) at the end
    for line in element_meta:
        if (line.strip().startswith('row:') or line.strip().startswith('col:') or
            line.strip().startswith('width:') or line.strip().startswith('height:')):
            result.append(line)

    return result

def fix_dashboard_file(filepath: Path) -> bool:
    """Fix a complete dashboard file"""
    try:
        print(f"Processing {filepath.name}...")

        # Parse dashboard
        header, filters, elements = parse_dashboard(filepath)

        # Process elements
        fixed_elements = []
        current_element = []
        in_element = False
        element_start_indent = 0

        for line in elements:
            stripped = line.strip()

            # Start of elements section
            if stripped == 'elements:':
                fixed_elements.append(line)
                continue

            # Start of a new element
            if stripped.startswith('- title:') or stripped.startswith('- name:'):
                # Fix previous element if exists
                if current_element:
                    fixed = fix_element(current_element, element_start_indent)
                    fixed_elements.extend(fixed)

                # Start new element
                current_element = [line]
                in_element = True
                element_start_indent = get_indent(line)
            elif in_element:
                current_element.append(line)

        # Fix last element
        if current_element:
            fixed = fix_element(current_element, element_start_indent)
            fixed_elements.extend(fixed)

        # Write output
        with open(filepath, 'w') as f:
            # Write header
            f.writelines(header)

            # Write elements
            if not header[-1].endswith('\n'):
                f.write('\n')
            f.writelines(fixed_elements)

            # Write filters at the end
            if filters:
                f.write('\n')
                f.writelines(filters)

        print(f"✓ Successfully fixed {filepath.name}")
        return True

    except Exception as e:
        print(f"✗ Error fixing {filepath.name}: {e}")
        import traceback
        traceback.print_exc()
        return False

def main():
    """Main function"""
    dashboards_dir = Path('/home/user/aws-cur-2/dashboards')

    success_count = 0
    for dashboard_name in DASHBOARDS:
        filepath = dashboards_dir / dashboard_name
        if filepath.exists():
            if fix_dashboard_file(filepath):
                success_count += 1
        else:
            print(f"✗ File not found: {dashboard_name}")

    print(f"\n{'='*60}")
    print(f"Completed! Fixed {success_count}/{len(DASHBOARDS)} dashboards")
    print(f"{'='*60}")

if __name__ == '__main__':
    main()
