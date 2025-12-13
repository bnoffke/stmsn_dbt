{{ config(
    tags=['parcels']
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
from {{ ref('stg_parcels_column_rename') }}