{{ config(tags=["route_traffic","daily"], materialized='view') }}

-- Latest attribute snapshot per route_name; app fetches this once for corridor selector and map preview.
select distinct on (route_name)
    route_name,
    corridor,
    direction,
    origin,
    destination,
    intermediate,
    description,
    distance_meters,
    encoded_polyline
from {{ ref('fact_route_traffic') }}
order by route_name, request_time_utc desc
