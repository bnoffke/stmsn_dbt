{{ config(
    tags=['parcels']
)}}

select *
from {{ ref('int_parcels_fix_lot_size') }}