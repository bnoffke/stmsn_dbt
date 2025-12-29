{{ config(
    tags=['alder_districts']
)}}

select ald_dist as alder_district_id,
    'District ' || ald_dist::text as alder_district_name,
    st_area(ST_MakeValid(geometry)) as alder_district_sqft,
    ST_MakeValid(geometry) as geom
from {{ source('arcgis','madison_alder_districts') }}
where year = (select max(year) from {{ source('arcgis','madison_alder_districts') }})