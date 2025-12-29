{{ config(
    tags=['parcels']
)}}

select *
from {{ ref('stg_parcels_fix_lot_size') }}