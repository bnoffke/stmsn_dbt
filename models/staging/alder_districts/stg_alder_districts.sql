{{ config(
    tags=['alder_districts']
)}}

with source as (
    select ald_dist as alder_district_id,
        'District ' || ald_dist::text as alder_district_name,
        st_area(ST_MakeValid(geometry)) as alder_district_sqft,
        ST_MakeValid(geometry) as geom
    from {{ source('arcgis','madison_alder_districts') }}
    where year = (select max(year) from {{ source('arcgis','madison_alder_districts') }})
),

mendota as (
    select st_buffer(
        st_transform(st_flipcoordinates(st_makevalid(geometry)), 'EPSG:4326', '{{ var("madison_crs") }}'),
        8
    ) as geom
    from {{ source('legacy','madison_lakes_and_rivers') }}
    where objectid = 132
),

monona as (
    select st_buffer(
        st_transform(st_flipcoordinates(st_makevalid(geometry)), 'EPSG:4326', '{{ var("madison_crs") }}'),
        8
    ) as geom
    from {{ source('legacy','madison_lakes_and_rivers') }}
    where objectid = 131
)

select alder_district_id,
    alder_district_name,
    alder_district_sqft,
    geom,
    case
        when alder_district_id = '8' then st_difference(geom, (select geom from mendota))
        when alder_district_id = '4' then st_difference(geom, (select geom from monona))
        else geom
    end as display_geom
from source
