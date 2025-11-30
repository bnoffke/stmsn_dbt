{{ config(
    location=get_external_location(),
    tags=['parcels']
) 
}}


with 
agg_cte as (

    select 
        x_ref_parcel as parcel_id,
        parcel_year,

        mode(property_class) as property_class,
        mode(property_use) as property_use,
        mode(area_name) as area_name,
        mode(lot_type_1) as lot_type_1,
        mode(lot_type_2) as lot_type_2,
        mode(zoning_all) as zoning_all,
        mode(neighborhood_primary) as neighborhood_primary,
        ward,
        alder_district,
        geom,
        max(case when parcel_id = x_ref_parcel then parcel_address end) as parcel_address,
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
        sum(total_dwelling_units) as total_dwelling_units
    from {{ ref('fact_parcels') }} parcels
    group by 
        x_ref_parcel,
        parcel_year,
        ward,
        alder_district,
        geom
)