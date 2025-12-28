{{ config(
    tags=['alder_districts']
)}}

select ald_dist as alder_district_id,
    'District ' || ald_dist::text as area_plan_name,
    st_area(geometry) as alder_district_sqft,
    geometry as geom
from {{ source('arcgis','madison_alder_districts') }}
where year = (select max(year) from {{ source('arcgis','madison_alder_districts') }})