{% macro apply_overlay_to_streets(overlay_ref,overlay_alias,overlay_name) %}

select
    streets.street_id,
    streets.street_year,
    {{overlay_alias}}.{{overlay_name}},
    ST_Intersection(streets.geom,{{overlay_alias}}.geom) as intersect_geom,
    streets.street_length * (ST_Length(ST_Intersection(streets.geom,{{overlay_alias}}.geom)) / ST_Length(streets.geom)) as intersect_street_length,
    streets.street_width,
    streets.city_maintains,
    streets.speed_limit

from {{ ref('stg_streets') }} streets
inner join {{ ref(overlay_ref) }} as {{overlay_alias}}
    on ST_Intersects(streets.geom,{{overlay_alias}}.geom)

{% endmacro %}