{{
    config(
        tags=['streets','area_plans']
    )
}}

{{ apply_overlay_to_streets('stg_area_plans','area_plans','area_plan_name')}}


