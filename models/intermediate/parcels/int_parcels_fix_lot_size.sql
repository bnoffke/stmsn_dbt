{{ config(
    tags=['parcels', 'monthly']
) }}

select * exclude (lot_size),
    case 
        when parcel_id = site_parcel_id
                and lot_size < 10
            then st_area(geom)
        when parcel_id <> site_parcel_id
                and lot_size < 10
            then 0
        else lot_size
        end as lot_size
from {{ ref('int_parcels_union_broken_lots') }}