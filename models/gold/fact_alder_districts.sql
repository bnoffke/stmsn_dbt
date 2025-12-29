{{
    config(
        tags=['alder_districts'],
        location=get_external_location()
    )
}}

{{ generate_fact_overlay('stg_alder_districts','alder_districts','alder_district_name') }}