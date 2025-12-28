{{
    config(
        tags=['area_plans']
    )
}}

{{ generate_fact_overlay('stg_area_plans','area_plans','area_plan_name') }}