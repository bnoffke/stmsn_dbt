{% macro apply_overlay_to_surfaces(overlay_ref,overlay_alias,overlay_name) %}

select
    surfaces.impervious_surface_id,
    surfaces.impervious_surface_year,
    {{overlay_alias}}.{{overlay_name}},
    ST_Intersection(surfaces.geom,{{overlay_alias}}.geom) as intersect_geom,
    ST_Area(intersect_geom) as intersect_impervious_surface_area,
    surfaces.surface_type,
    surfaces.is_people_surface,
    surfaces.is_vehicle_surface,

from {{ ref('stg_impervious_surfaces') }} surfaces
inner join {{ ref(overlay_ref) }} as {{overlay_alias}}
    on ST_Intersects(surfaces.geom,{{overlay_alias}}.geom)

{% endmacro %}