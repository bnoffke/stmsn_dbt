{{
    config(
        tags=['alder_districts', 'monthly'],
        unique_key='year_number',
        partition_by='year_number'
    )
}}

{{ generate_fact_overlay('stg_alder_districts','alder_districts','alder_district_name', display_geom_col='display_geom') }}
