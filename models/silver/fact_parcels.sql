{{ config(
    tags=['parcels'],
    location=get_external_location()
) 
}}

select *,
    net_taxes / nullif(current_total_value, 0) as tax_rate,
    net_taxes / nullif(lot_size, 0) as net_taxes_per_sqft_lot,
    current_land_value / nullif(lot_size, 0) as land_value_per_sqft_lot,
    sum(net_taxes) over (partition by 1) as total_net_taxes_city,
    sum(current_land_value) over (partition by 1) as current_total_land_value_city,
    sum(current_total_value) over (partition by 1) as current_total_value_city,
    current_land_value / nullif(current_total_value, 0) as land_share_property,
    current_land_value /  nullif(current_total_land_value_city, 0) as land_share_city,
    current_total_value / nullif(current_total_value_city, 0) as total_share_city,
    land_share_city / nullif(total_share_city, 0) as land_total_ratio_city,
    total_share_city / nullif(land_share_city, 0) as land_value_alignment_index,
    land_share_city * total_net_taxes_city as land_value_shift_taxes,
    st_transform(geom, '{{ var("madison_crs") }}', 'EPSG:4326') as geom_4326,
    TRIM(
            CONCAT(
                CAST(house_nbr AS VARCHAR),
                CASE WHEN street_dir IS NOT NULL AND street_dir != '' THEN ' ' || street_dir ELSE '' END,
                ' ', street_name,
                CASE WHEN street_type IS NOT NULL AND street_type != '' THEN ' ' || street_type ELSE '' END,
                CASE WHEN unit IS NOT NULL AND unit != '' THEN ' Unit ' || CAST(unit AS VARCHAR) ELSE '' END
            )
        ) AS full_address,
from {{ ref('stg_parcels_fix_lot_size') }}