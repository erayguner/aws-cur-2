#!/usr/bin/env python3
"""
Final fix: Reorder properties within elements to match the correct pattern
"""

import re
from pathlib import Path

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

def fix_element_order(element_text):
    """Reorder properties within an element"""
    lines = element_text.strip().split('\n')
    
    # Check if text element
    if any('type: text' in line for line in lines):
        return element_text
    
    # Separate into sections
    metadata = []
    viz_config = []
    note_text_line = None
    listen_block = []
    position = []
    
    i = 0
    in_listen = False
    in_viz_config = False
    viz_config_indent = 0
    
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        indent = len(line) - len(line.lstrip())
        
        # Handle visualization_config block
        if stripped.startswith('visualization_config:'):
            in_viz_config = True
            viz_config_indent = indent
            viz_config.append(line)
            i += 1
            continue
        
        if in_viz_config:
            if stripped and indent > viz_config_indent:
                viz_config.append(line)
                i += 1
                continue
            else:
                in_viz_config = False
        
        # Handle note_text
        if stripped.startswith('note_text:'):
            note_text_line = line
            i += 1
            continue
        
        # Handle listen block
        if stripped.startswith('listen:'):
            in_listen = True
            listen_block.append(line)
            i += 1
            continue
        
        if in_listen:
            if stripped and not stripped.startswith(('row:', 'col:', 'width:', 'height:')):
                listen_block.append(line)
                i += 1
                continue
            else:
                in_listen = False
        
        # Handle position properties
        if stripped.startswith(('row:', 'col:', 'width:', 'height:')):
            position.append(line)
            i += 1
            continue
        
        # Everything else is metadata
        metadata.append(line)
        i += 1
    
    # Rebuild in correct order
    result = []
    result.extend(metadata)
    result.extend(viz_config)
    if note_text_line:
        result.append(note_text_line)
    result.extend(listen_block)
    result.extend(position)
    
    return '\n'.join(result)

def fix_dashboard(filepath):
    """Fix a dashboard file"""
    with open(filepath, 'r') as f:
        content = f.read()
    
    # Find all elements using regex
    # Match from "  - title:" or "  - name:" to the next one or end
    pattern = r'(  - (?:title|name):.*?)(?=\n  - (?:title|name):|\n  filters:|\Z)'
    
    def replace_element(match):
        return fix_element_order(match.group(1))
    
    fixed_content = re.sub(pattern, replace_element, content, flags=re.DOTALL)
    
    with open(filepath, 'w') as f:
        f.write(fixed_content)
    
    return True

# Process all dashboards
dashboards_dir = Path('/home/user/aws-cur-2/dashboards')
success = 0

for dashboard_name in DASHBOARDS:
    filepath = dashboards_dir / dashboard_name
    if filepath.exists():
        try:
            fix_dashboard(filepath)
            print(f"✓ Fixed {dashboard_name}")
            success += 1
        except Exception as e:
            print(f"✗ Error in {dashboard_name}: {e}")
    else:
        print(f"✗ Not found: {dashboard_name}")

print(f"\nCompleted: {success}/{len(DASHBOARDS)} dashboards")

