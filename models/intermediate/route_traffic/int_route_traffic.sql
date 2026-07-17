{{ config(
    tags=["route_traffic", "daily"]
) }}

select * from {{ ref('stg_route_traffic') }}
