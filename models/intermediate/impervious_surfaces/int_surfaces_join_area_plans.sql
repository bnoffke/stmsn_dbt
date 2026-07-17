{{
    config(
        tags=['impervious_surfaces', 'area_plans', 'monthly']
    )
}}

{{ apply_overlay_to_surfaces('stg_area_plans','area_plans','area_plan_name')}}


