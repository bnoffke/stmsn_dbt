{{ config(
    tags=["route_traffic", "daily"],
    materialized='incremental',
    incremental_strategy='delete+insert',
    unique_key='request_date_local'
) }}

select
    route_name,
    request_date_local,
    time_window,
    max(is_weekday)                                             as is_weekday,
    max(is_holiday)                                             as is_holiday,
    max(week_start_date_local)                                  as week_start_date_local,
    max(expected_poll_count)                                    as expected_poll_count,

    count(*)                                                    as poll_count,
    count(*)::double / nullif(max(expected_poll_count), 0)      as coverage_pct,

    -- duration_seconds aggregates
    quantile_cont(duration_seconds, 0.5)::int                  as duration_median,
    quantile_cont(duration_seconds, 0.25)::int                 as duration_p25,
    quantile_cont(duration_seconds, 0.75)::int                 as duration_p75,
    quantile_cont(duration_seconds, 0.95)::int                 as duration_p95,
    min(duration_seconds)                                       as duration_min,
    max(duration_seconds)                                       as duration_max,

    -- delay_seconds aggregates
    quantile_cont(delay_seconds, 0.5)::int                     as delay_median,
    quantile_cont(delay_seconds, 0.25)::int                    as delay_p25,
    quantile_cont(delay_seconds, 0.75)::int                    as delay_p75,
    quantile_cont(delay_seconds, 0.95)::int                    as delay_p95,
    min(delay_seconds)                                          as delay_min,
    max(delay_seconds)                                          as delay_max

from {{ ref('fact_route_traffic') }}
where time_window != 'OTHER'
{% if is_incremental() %}
  and request_date_local >= (select max(request_date_local) from {{ this }})
  and request_date_local < current_date
{% endif %}

group by route_name, request_date_local, time_window
