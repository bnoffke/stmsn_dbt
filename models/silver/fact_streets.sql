{{ config(
    tags=['streets'],
    location=get_external_location()
) 
}}

select *,
    st_transform(geom, '{{ var("madison_crs") }}', 'EPSG:4326') as geom_4326
from {{ ref('stg_streets') }} streets
left outer join {{ ref('stg_streets_join_area_plans') }} area_plans
    on streets.street_id = area_plans.street_id
    and streets.street_year = area_plans.street_year
    and area_plans.intersect_rank = 1
left outer join {{ ref('stg_streets_join_alder_districts') }} alder_districts
    on streets.street_id = alder_districts.street_id
    and streets.street_year = alder_districts.street_year
    and alder_districts.intersect_rank = 1