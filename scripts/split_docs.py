#!/usr/bin/env python3
"""
Script to split _docs.md into organized domain-specific files.
"""

import re
from pathlib import Path

# Define the categorization of doc blocks
CATEGORIES = {
    '_docs_parcels_core.md': [
        'ogc_fid', 'obj_id', 'parcel', 'x_ref_parcel', 'parcel_id', 'parcel_year', 'parcel_address',
        'property_class', 'property_use', 'property_use_code', 'year_built', 'home_style', 'more_than_one_build',
        'bedrooms', 'full_baths', 'half_baths', 'total_living_area',
        'first_floor', 'second_floor', 'third_floor', 'above_third_floor',
        'finished_attic', 'basement', 'finished_basement',
        'fireplaces', 'central_air', 'exterior_wall_1', 'exterior_wall_2',
    ],
    '_docs_parcels_extended.md': [
        'lot_size', 'lot_depth', 'lot_width', 'lot_type_1', 'lot_type_2', 'lot_number',
        'zoning_1', 'zoning_2', 'zoning_3', 'zoning_4', 'zoning_all', 'zoning_board_appeal',
        'ward', 'alder_district', 'area_plan', 'area_name', 'planning_district', 'building_district', 'assessment_area',
        'tax_school_dist', 'attendance_school', 'elementary_school', 'middle_school', 'high_school',
        'state_assembly_district', 'senate_district', 'supervisor_district',
        'refuse_district', 'refuse_url', 'fire_district', 'fire_demand_zone', 'fire_demand_sub_zone',
        'police_district', 'police_sector',
        'heating_district', 'electrical_district', 'plumbing_district', 'env_health_district',
        'flood_plain', 'wetland_info', 'park_proximity', 'landfill_proximity', 'landfill_remediation',
        'water_frontage', 'type_water_frontage', 'frontage_street', 'railroad_frontage',
        'landmark', 'local_historical_dist', 'national_historical_dist', 'urban_design_district',
        'conditional_use', 'deed_restriction', 'deed_page', 'deed_volume',
        'noise_airport', 'noise_railroad', 'noise_street',
        'tif_district', 'tif_year', 'tif_impr', 'tif_land', 'traffic_analysis_zone',
        'block_number', 'capitol_fire_district', 'landscape_buffer',
    ],
    '_docs_streets.md': [
        'street_id', 'street_year', 'intersect_geom_4326', 'intersect_street_length',
        'local_geom', 'streets_geom_4326', 'city_maint_streets_geom_4326',
        'street_width', 'street_length', 'street_lanes', 'median_width',
        'city_maintains', 'speed_limit', 'avg_speed_limit', 'is_oneway', 'is_truck_route', 'has_sidewalk',
        'total_street_sqft', 'total_city_maint_street_sqft',
    ],
    '_docs_tax_assessment.md': [
        'tax_year', 'current_land', 'current_impr', 'current_total',
        'current_land_value', 'current_improvement_value', 'current_total_value',
        'previous_land', 'previous_impr', 'previous_total',
        'previous_land_2', 'previous_impr_2', 'previous_total_2',
        'assessed_value_land', 'assessed_value_improvement', 'total_assessed_value',
        'est_fair_mkt_land', 'est_fair_mkt_improvement', 'total_estimated_fair_market',
        'net_taxes', 'total_taxes', 'special_assmnt', 'other_charges',
        'current_county_net_tax', 'current_city_net_tax', 'current_school_net_tax',
        'current_matc_net_tax', 'total_current_net_tax', 'total_current_tax',
        'partial_assessed', 'assessed_by_state', 'exemption_type',
    ],
    '_docs_geography.md': [
        'x_coord', 'y_coord', 'geom', 'geom_4326', 'geom_local',
        'shape_length', 'shape_area', 'st_transform',
        'intersect_area', 'intersect_rank',
    ],
    '_docs_aggregates.md': [
        'id', 'district_id', 'taxes_per_sqft', 'avg_taxes_per_sqft', 'taxes_per_city_maint_street_sqft',
        'total_parcels', 'total_bedrooms', 'total_land_value', 'total_improvement_value', 'total_value',
        'total_net_taxes', 'total_dwelling_units', 'total_area',
        'current_total_land_value_city', 'current_total_value_city', 'total_net_taxes_city',
        'year_number',
    ],
    '_docs_system.md': [
        'load_dttm', 'date_added', 'date_parcel_changed', 'parcel_change_date', 'property_change_date',
        'owner_change_date', 'assessment_change_date', 'obsolete_date',
        'reason_change_land', 'reason_change_impr', 'previous_class',
        'owner_occupied', 'pending', 'holds', 'council_hold', 'illegal_land_division',
        'key_set', 'num_records', 'first_seen_dt', 'last_seen_dt',
        'storm_outfall', 'fuel_storage_proximity', 'neighborhood_desc', 'neighborhood_primary',
        'neighborhood_sub', 'neighborhood_vuln', 'uw_police', 'mcd_code', 'parcel_code', 'max_construction_year',
    ],
    '_docs_address.md': [
        'house_nbr', 'street_dir', 'street_name', 'street_type', 'unit',
    ],
}

def parse_doc_blocks(content):
    """Parse all doc blocks from content."""
    # Pattern to match doc blocks
    pattern = r'{%\s*docs\s+(\w+)\s*%}(.*?){%\s*enddocs\s*%}'
    matches = re.findall(pattern, content, re.DOTALL)

    doc_blocks = {}
    for name, description in matches:
        full_block = f"{{% docs {name} %}}{description}{{% enddocs %}}"
        doc_blocks[name] = full_block

    return doc_blocks

def main():
    project_root = Path(__file__).parent.parent
    docs_dir = project_root / "docs"

    # Read original _docs.md
    with open(docs_dir / "_docs.md", 'r') as f:
        content = f.read()

    # Parse all doc blocks
    doc_blocks = parse_doc_blocks(content)
    print(f"Found {len(doc_blocks)} doc blocks in _docs.md")

    # Track categorized and uncategorized blocks
    categorized = set()

    # Write to category files
    for filename, column_names in CATEGORIES.items():
        filepath = docs_dir / filename

        blocks_found = []
        for col_name in column_names:
            if col_name in doc_blocks:
                blocks_found.append(doc_blocks[col_name])
                categorized.add(col_name)

        if blocks_found:
            with open(filepath, 'w') as f:
                f.write('\n\n'.join(blocks_found))
                f.write('\n')

            print(f"✓ Created {filename} with {len(blocks_found)} doc blocks")

    # Check for uncategorized blocks
    uncategorized = set(doc_blocks.keys()) - categorized
    if uncategorized:
        print(f"\n⚠ Warning: {len(uncategorized)} uncategorized doc blocks:")
        for name in sorted(uncategorized):
            print(f"  - {name}")

    # Backup original file
    import shutil
    shutil.copy(docs_dir / "_docs.md", docs_dir / "_docs.md.backup")
    print(f"\n✓ Created backup: _docs.md.backup")

    print(f"\nSummary:")
    print(f"  Total doc blocks: {len(doc_blocks)}")
    print(f"  Categorized: {len(categorized)}")
    print(f"  Uncategorized: {len(uncategorized)}")

if __name__ == "__main__":
    main()
