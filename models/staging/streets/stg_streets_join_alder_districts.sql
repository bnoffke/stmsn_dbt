{{
    config(
        tags=['streets','alder_districts']
    )
}}

{{ apply_overlay_to_streets('stg_alder_districts','alder_districts','alder_district_name') }}