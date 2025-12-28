{{ config(
    location=get_external_location(),
    tags=['parcels']
) 
}}


with 
agg_cte as (

    select 
        site_parcel_id,
        parcel_year,

        mode(property_class) as property_class,
        mode(property_use) as property_use,
        mode(area_name) as area_name,
        mode(lot_type_1) as lot_type_1,
        mode(lot_type_2) as lot_type_2,
        mode(zoning_all) as zoning_all,
        mode(ward) as ward,
        mode(alder_district_name) as alder_district_name,
        mode(area_plan_name) as area_plan_name,
        
        geom,
        geom_4326,
        max(case when parcel_id = site_parcel_id then parcel_address end) as parcel_address,
        sum(bedrooms) as bedrooms,
        sum(full_baths) as full_baths,
        sum(half_baths) as half_baths,
        sum(total_living_area) as total_living_area,
        sum(first_floor) as first_floor,
        sum(second_floor) as second_floor,
        sum(third_floor) as third_floor,
        sum(above_third_floor) as above_third_floor,
        sum(finished_attic) as finished_attic,
        sum(basement) as basement,
        sum(finished_basement) as finished_basement,
        sum(fireplaces) as fireplaces,
        mode(central_air) as central_air,
        sum(current_land_value) as current_land_value,
        sum(current_improvement_value) as current_improvement_value,
        sum(current_total_value) as current_total_value,
        sum(special_assessment) as special_assessment,
        sum(other_charges) as other_charges,
        sum(net_taxes) as net_taxes,
        sum(total_taxes) as total_taxes,
        max(lot_size) as lot_size,
        sum(total_dwelling_units) as total_dwelling_units,

        max(current_total_land_value_city) as current_total_land_value_city,
        max(current_total_value_city) as current_total_value_city,
        max(total_net_taxes_city) as total_net_taxes_city

    from {{ ref('fact_parcels') }} parcels
    group by 
        site_parcel_id,
        parcel_year,
        geom,
        geom_4326
)

select *,
    ST_AsGeoJSON(ST_SimplifyPreserveTopology(geom_4326, 0.00001)) geom_4326_geojson,
    net_taxes / nullif(current_total_value, 0) as tax_rate,
    net_taxes / nullif(lot_size, 0) as net_taxes_per_sqft_lot,
    current_land_value / nullif(lot_size, 0) as land_value_per_sqft_lot,
    current_land_value / nullif(current_total_value, 0) as land_share_property,
    current_land_value /  nullif(current_total_land_value_city, 0) as land_share_city,
    current_total_value / nullif(current_total_value_city, 0) as total_share_city,
    land_share_city / nullif(total_share_city, 0) as land_total_ratio_city,
    total_share_city / nullif(land_share_city, 0) as land_value_alignment_index,
    land_share_city * total_net_taxes_city as land_value_shift_taxes
from agg_cte
