{{ config(
    tags=["route_traffic", "daily"]
) }}

select
    route_name::varchar             as route_name,
    corridor::varchar               as corridor,
    direction::varchar              as direction,
    origin::varchar                 as origin,
    destination::varchar            as destination,
    intermediate::varchar           as intermediate,
    alternative_index::int          as alternative_index,
    description::varchar            as description,
    distance_meters::int            as distance_meters,
    duration_seconds::int           as duration_seconds,
    static_duration_seconds::int    as static_duration_seconds,
    encoded_polyline::varchar       as encoded_polyline,
    request_time_utc::timestamptz   as request_time_utc,
    schedule_name::varchar          as schedule_name,
    run_id::varchar                 as run_id,
    dt::date                        as dt
from {{ source('route-traffic', 'madison_route_traffic') }}
