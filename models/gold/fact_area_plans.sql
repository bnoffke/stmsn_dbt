{{
    config(
        tags=['area_plans'],
        location=get_external_location()
    )
}}

{{ generate_fact_overlay('stg_area_plans','area_plans','area_plan_name') }}