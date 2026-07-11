{{ config(
    tags=['area_plans']
)}}

select sequence as area_plan_id,
    district_name as area_plan_name,
    shape_st_areax as area_plan_sqft,
    ST_MakeValid(geometry) as geom
from {{ source('arcgis','madison_area_plans') }}
-- max-year subquery over the same hive-partitioned glob hits a DuckDB 1.5.4
-- internal error (dynamic filter pushdown on the partition column)
qualify year = max(year) over ()