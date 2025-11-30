{{ config(
    tags=['parcels'],
    location=get_external_location()
) 
}}

select *
from {{ ref('stg_parcels_fix_lot_size') }}