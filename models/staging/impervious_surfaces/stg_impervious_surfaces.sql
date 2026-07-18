{{
    config(
        tags=['impervious_surfaces', 'monthly']
    )
}}

select objectid as impervious_surface_id,
    "year" as impervious_surface_year,
    ST_MakeValid(geometry) as geom,
    source_area_desc as surface_type,
    case when surface_type in ('Sidewalks','Playgrounds') then 1 else 0 end as is_people_surface,
    case when surface_type in ('Parking','Unpaved Parking','Driveways','Streets','Alleys') then 1 else 0 end as is_vehicle_surface,
from {{ source('arcgis','madison_impervious_surfaces') }}
