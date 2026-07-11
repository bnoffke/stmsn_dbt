{{ config(
    tags=['alder_districts']
)}}

with source as (
    select ald_dist as alder_district_id,
        'District ' || ald_dist::text as alder_district_name,
        st_area(ST_MakeValid(geometry)) as alder_district_sqft,
        ST_MakeValid(geometry) as geom
    from {{ source('arcgis','madison_alder_districts') }}
    -- max-year subquery over the same hive-partitioned glob hits a DuckDB 1.5.4
    -- internal error (dynamic filter pushdown on the partition column)
    qualify year = max(year) over ()
),

mendota as (
    select st_buffer(
        st_transform(st_flipcoordinates(st_makevalid(geometry)), 'EPSG:4326', '{{ var("madison_crs") }}'),
        3.281
    ) as geom
    from {{ source('legacy','madison_lakes_and_rivers') }}
    where objectid = 132
),

monona as (
    select st_buffer(
        st_transform(st_flipcoordinates(st_makevalid(geometry)), 'EPSG:4326', '{{ var("madison_crs") }}'),
        3.281
    ) as geom
    from {{ source('legacy','madison_lakes_and_rivers') }}
    where objectid = 131
),

differences as (
    select
        alder_district_id,
        alder_district_name,
        alder_district_sqft,
        geom,
        case
            when alder_district_id = '8' then st_difference(geom, (select geom from mendota))
            when alder_district_id = '4' then st_difference(geom, (select geom from monona))
            else geom
        end as diff_geom
    from source
),

largest_part as (
    select
        alder_district_id,
        part.geom as display_geom
    from differences,
        unnest(st_dump(diff_geom)) as t(part)
    where alder_district_id in ('4', '8')
    qualify row_number() over (
        partition by alder_district_id
        order by st_area(part.geom) desc
    ) = 1
)

select
    d.alder_district_id,
    d.alder_district_name,
    d.alder_district_sqft,
    d.geom,
    coalesce(lp.display_geom, d.geom) as display_geom
from differences d
left join largest_part lp on d.alder_district_id = lp.alder_district_id
