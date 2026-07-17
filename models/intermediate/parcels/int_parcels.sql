{{ config(
    tags=['parcels', 'monthly']
)}}

select *
from {{ ref('int_parcels_fix_lot_size') }}