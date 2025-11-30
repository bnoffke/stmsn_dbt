{{ config(
    tags=['parcels']
) }}

select * exclude (lot_size),
    case 
        when parcel_id = x_ref_parcel
                and lot_size < 10
            then st_area(geom)
        when parcel_id <> x_ref_parcel
                and lot_size < 10
            then 0
        else lot_size
        end as lot_size
from {{ ref('stg_parcels_column_rename') }}