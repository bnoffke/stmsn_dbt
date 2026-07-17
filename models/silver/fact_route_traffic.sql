{{ config(
    tags=["route_traffic", "daily"],
    materialized='view'
) }}

with historical as (
    select * from {{ ref('int_route_traffic_daily') }}
),

live as (
    select *
    from {{ ref('int_route_traffic') }}
    where dt > (select max(dt) from {{ ref('int_route_traffic_daily') }})
)

select * from historical
union all by name
select * from live
