{% macro generate_fact_overlay(overlay_ref,overlay_alias,overlay_name) %}

{% set ref_streets_join = "stg_streets_join_" ~ overlay_alias %}

with parcel_info as (
    select 
        {{overlay_alias}}.{{overlay_name}},
        {{overlay_alias}}.geom,
        parcels.parcel_year,

        count(parcels.site_parcel_id) as total_parcels,
        sum(parcels.bedrooms) as total_bedrooms,
        sum(parcels.current_land_value) as total_land_value,
        sum(parcels.current_improvement_value) as total_improvement_value,
        sum(parcels.current_total_value) as total_value,
        sum(parcels.net_taxes) as total_net_taxes,
        sum(parcels.total_taxes) as total_taxes,
        sum(parcels.total_dwelling_units) as total_dwelling_units,
        sum(case when parcels.total_taxes > 0 then parcels.lot_size else 0 end) as total_area,

        max(parcels.current_total_land_value_city) as current_total_land_value_city,
        max(parcels.current_total_value_city) as current_total_value_city,
        max(parcels.total_net_taxes_city) as total_net_taxes_city,

        sum(parcels.total_taxes) / total_area as avg_taxes_per_sqft

    from {{ ref(overlay_ref) }} {{overlay_alias}}
    left outer join {{ ref('fact_sites') }} parcels
        on {{overlay_alias}}.{{overlay_name}} = parcels.{{overlay_name}}
    group by
        {{overlay_alias}}.{{overlay_name}},
        {{overlay_alias}}.geom,
        parcels.parcel_year
),

street_info as (
    select
        {{overlay_alias}}.{{overlay_name}},
        {{overlay_alias}}.geom,
        streets.street_year,
        
        sum(streets.street_width * streets.intersect_street_length) as total_street_sqft,
        sum(streets.city_maintains * streets.street_width * streets.intersect_street_length) as total_city_maint_street_sqft,
        sum(streets.intersect_street_length * streets.speed_limit) / sum(streets.intersect_street_length) as avg_speed_limit,
        ST_Union_agg(streets.intersect_geom) as streets_geom,
        ST_Union_agg(case when streets.city_maintains = 1 then streets.intersect_geom else null end) as city_maint_streets_geom

    from {{ ref(overlay_ref) }} {{overlay_alias}}
    left outer join {{ ref(ref_streets_join)}} streets
        on {{overlay_alias}}.{{overlay_name}} = streets.{{overlay_name}}
    group by {{overlay_alias}}.{{overlay_name}},
        {{overlay_alias}}.geom,
        streets.street_year
)

select
    parcel_info.{{overlay_name}},
    parcel_info.parcel_year as year_number,
    parcel_info.geom,
    st_transform(parcel_info.geom, '{{ var("madison_crs") }}', 'EPSG:4326') as geom_4326,
    ST_AsGeoJSON(ST_SimplifyPreserveTopology(st_transform(parcel_info.geom, '{{ var("madison_crs") }}', 'EPSG:4326'), 0.00001).ST_FlipCoordinates()) as geom_4326_geojson,
    parcel_info.total_parcels,
    parcel_info.total_bedrooms,
    parcel_info.total_land_value,
    parcel_info.total_improvement_value,
    parcel_info.total_value,
    parcel_info.total_net_taxes,
    parcel_info.total_taxes,
    parcel_info.total_dwelling_units,
    parcel_info.total_area,
    parcel_info.current_total_land_value_city,
    parcel_info.current_total_value_city,
    parcel_info.total_net_taxes_city,

    parcel_info.total_net_taxes / nullif(parcel_info.total_value, 0) as tax_rate,
    parcel_info.total_net_taxes / nullif(parcel_info.total_area, 0) as net_taxes_per_sqft_lot,
    parcel_info.total_taxes / nullif(parcel_info.total_area, 0) as total_taxes_per_sqft_lot,
    parcel_info.total_land_value / nullif(parcel_info.total_area, 0) as land_value_per_sqft_lot,
    parcel_info.total_land_value / nullif(parcel_info.total_value, 0) as land_share_property,
    parcel_info.total_land_value / nullif(parcel_info.current_total_land_value_city, 0) as land_share_city,
    parcel_info.total_value / nullif(parcel_info.current_total_value_city, 0) as total_share_city,
    land_share_city / nullif(total_share_city, 0) as land_total_ratio_city,
    total_share_city / nullif(land_share_city, 0) as land_value_alignment_index,
    land_share_city * parcel_info.total_net_taxes_city as land_value_shift_taxes,

    street_info.total_street_sqft,
    street_info.total_city_maint_street_sqft,
    street_info.avg_speed_limit,
    street_info.streets_geom,
    street_info.city_maint_streets_geom,

    parcel_info.total_taxes / street_info.total_city_maint_street_sqft as taxes_per_city_maint_street_sqft

from parcel_info
left outer join street_info
    on parcel_info.{{overlay_name}} = street_info.{{overlay_name}}
    and parcel_info.parcel_year = street_info.street_year

{% endmacro %}