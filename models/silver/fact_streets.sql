{{ config(
    tags=['streets', 'monthly'],
    unique_key='street_year',
    partition_by='street_year'
) }}

select *,
    st_transform(geom, '{{ var("madison_crs") }}', 'EPSG:4326') as geom_4326
from {{ ref('stg_streets') }} streets
left outer join {{ ref('int_streets_join_area_plans') }} area_plans
    on streets.street_id = area_plans.street_id
    and streets.street_year = area_plans.street_year
    and area_plans.intersect_rank = 1
left outer join {{ ref('int_streets_join_alder_districts') }} alder_districts
    on streets.street_id = alder_districts.street_id
    and streets.street_year = alder_districts.street_year
    and alder_districts.intersect_rank = 1
{% if is_incremental() %}
where streets.street_year >= (select max(street_year) from {{ this }})
{% endif %}