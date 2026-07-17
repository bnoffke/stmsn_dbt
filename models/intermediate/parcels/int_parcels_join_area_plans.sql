{{
    config(
        tags=['parcels', 'area_plans', 'monthly']
    )
}}


{{ apply_overlay_to_parcels('stg_area_plans','area_plans','area_plan_name')}}
