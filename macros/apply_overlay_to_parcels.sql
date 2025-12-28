{% macro apply_overlay_to_parcels(overlay_ref,overlay_alias,overlay_name) %}

select

    parcels.parcel_id,
    parcels.parcel_year,
    {{overlay_alias}}.{{overlay_name}},
    ST_Area(ST_Intersection(parcels.geom,{{overlay_alias}}.geom)) as intersect_area,
    row_number() over (partition by parcels.parcel_id,parcels.parcel_year order by ST_Area(ST_Intersection(parcels.geom,{{overlay_alias}}.geom)) desc) as intersect_rank
    
from {{ ref('stg_parcels') }} parcels

inner join {{ ref(overlay_ref) }} {{overlay_alias}}
    on ST_Intersects(parcels.geom,{{overlay_alias}}.geom)

{% endmacro %}