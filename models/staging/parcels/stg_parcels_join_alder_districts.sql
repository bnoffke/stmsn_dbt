{{
    config(
        tags=['parcels','alder_districts']
    )
}}

{{ apply_overlay_to_parcels('stg_alder_districts','alder_districts','alder_district_name')}}