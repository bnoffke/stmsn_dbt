{{ config(tags=["route_traffic", "daily"]) }}

with base as (
    select * from {{ ref('stg_route_traffic') }}
),

with_local_time as (
    select
        *,
        request_time_utc at time zone 'America/Chicago' as request_time_local
    from base
),

with_holiday as (
    select
        wlt.*,
        h.holiday_date is not null as is_holiday
    from with_local_time wlt
    left join {{ ref('holidays') }} h
        on wlt.request_date_local = h.holiday_date
),

final as (
    select
        -- pass-through from staging
        route_name,
        corridor,
        direction,
        origin,
        destination,
        intermediate,
        alternative_index,
        description,
        distance_meters,
        duration_seconds,
        static_duration_seconds,
        encoded_polyline,
        request_time_utc,
        schedule_name,
        run_id,
        request_date_local,

        -- derived time columns
        request_time_local,
        dayname(request_time_local)                         as day_of_week_name,
        isodow(request_time_local) <= 5                     as is_weekday,
        is_holiday,
        date_trunc('week', request_date_local)::date        as week_start_date_local,
        strftime(
            time_bucket(interval '10 minutes', request_time_local::timestamp),
            '%H:%M'
        )                                                   as slot_local,

        -- window classification
        case
            when isodow(request_time_local) > 5
                then 'WEEKEND_PROBE'
            when hour(request_time_local) between 6 and 9
                then 'AM'
            when hour(request_time_local) = 12
                then 'NOON'
            when hour(request_time_local) between 15 and 19
                then 'PM'
            else 'OTHER'
        end                                                 as time_window,

        -- expected polls per window per day (for coverage calculations)
        case
            when isodow(request_time_local) > 5
                then 2
            when hour(request_time_local) between 6 and 9
                then 24
            when hour(request_time_local) = 12
                then 1
            when hour(request_time_local) between 15 and 19
                then 25
            else null
        end                                                 as expected_poll_count,

        -- metrics
        duration_seconds - static_duration_seconds          as delay_seconds,
        duration_seconds::double
            / nullif(static_duration_seconds, 0)            as travel_time_index

    from with_holiday
)

select * from final
