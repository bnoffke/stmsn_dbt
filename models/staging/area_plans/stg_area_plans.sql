{{ config(
    tags=['area_plans']
)}}

select sequence as area_plan_id,
    district_name as area_plan_name,
    shape_st_areax as area_plan_sqft,
    geometry as geom
from {{ source('arcgis','madison_area_plans') }}
where year = (select max(year) from {{ source('arcgis','madison_area_plans') }})