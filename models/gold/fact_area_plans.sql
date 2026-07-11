{{
    config(
        tags=['area_plans'],
        unique_key='year_number',
        partition_by='year_number'
    )
}}

{{ generate_fact_overlay('stg_area_plans','area_plans','area_plan_name') }}