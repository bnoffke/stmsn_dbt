{{
    config(
        tags=['streets', 'area_plans', 'monthly']
    )
}}

{{ apply_overlay_to_streets('stg_area_plans','area_plans','area_plan_name')}}


