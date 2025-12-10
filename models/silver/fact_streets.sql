{{ config(
    tags=['streets'],
    location=get_external_location()
) 
}}

select *,
    st_transform(geom, '{{ var("madison_crs") }}', 'EPSG:4326') as geom_4326
from {{ ref('stg_streets') }}