{{ config(
    tags=['streets']
)}}

select
    asset_id as street_id,
    year as street_year,
    ST_MakeValid(geometry) as geom,
    speed_limit,
    surface_width as street_width,
    lanes as street_lanes,
    shape_st_lengthx as street_length,
    truck_route as is_truck_route,
    case when sidewalk in ('1','2','3') then 1 else 0 end as has_sidewalk,
    median_width,
    case when oneway::int > 0 then 1 else 0 end as is_oneway,
    case when city_maintains = 'Yes' then 1
         when maintained_by = 'MAD-C' then 1
         else 0 end city_maintains,
    ald_dist as alder_district,

from {{ source('arcgis','madison_streets') }}