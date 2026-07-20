{% docs route_name %}
Name of the traffic route being measured.
{% enddocs %}

{% docs corridor %}
Corridor the route belongs to.
{% enddocs %}

{% docs direction %}
Direction of travel along the route.
{% enddocs %}

{% docs origin %}
Origin point of the route.
{% enddocs %}

{% docs destination %}
Destination point of the route.
{% enddocs %}

{% docs intermediate %}
Intermediate waypoint(s) along the route, if any.
{% enddocs %}

{% docs alternative_index %}
Index of the route alternative returned by the Google Routes API for a given request.
{% enddocs %}

{% docs description %}
Human-readable description of the route.
{% enddocs %}

{% docs distance_meters %}
Total route distance in meters.
{% enddocs %}

{% docs duration_seconds %}
Estimated travel duration in seconds accounting for current traffic conditions.
{% enddocs %}

{% docs static_duration_seconds %}
Estimated travel duration in seconds under typical (static, traffic-free) conditions.
{% enddocs %}

{% docs encoded_polyline %}
Google encoded polyline string describing the route geometry.
{% enddocs %}

{% docs request_time_utc %}
UTC timestamp at which the route traffic measurement was requested from the Google Routes API.
{% enddocs %}

{% docs schedule_name %}
Name of the collection schedule that produced this record.
{% enddocs %}

{% docs run_id %}
Identifier of the collection run that produced this record.
{% enddocs %}

{% docs request_date_local %}
Collection date in local time (America/Chicago). The hive partition key from bronze storage; derived from the local timestamp, not UTC, so PM polls collected after 6 pm local but before midnight UTC land on the correct local date.
{% enddocs %}

{% docs request_time_local %}
Request timestamp converted to America/Chicago local time (DST-aware via ICU). Use this instead of request_time_utc for any hour- or date-of-day calculations.
{% enddocs %}

{% docs day_of_week_name %}
Day of week name derived from request_time_local (e.g. Monday, Tuesday).
{% enddocs %}

{% docs is_weekday %}
True if request_time_local falls on Monday–Friday.
{% enddocs %}

{% docs is_holiday %}
True if request_date_local matches a date in the holidays seed. Combined with is_weekday to identify inference-eligible days.
{% enddocs %}

{% docs week_start_date_local %}
Monday of the local week containing request_date_local. Powers weekly adaptation views.
{% enddocs %}

{% docs slot_local %}
request_time_local floored to the nearest 10 minutes, formatted as HH:MM. Used as a time-of-day comparison key for within-window profiles.
{% enddocs %}

{% docs time_window %}
Peak-period classification: AM (06:00–09:59), NOON (12:00–12:59), PM (15:00–19:59), WEEKEND_PROBE (any weekend poll), OTHER (outside classified windows). Based on local time.
{% enddocs %}

{% docs expected_poll_count %}
Expected number of polls per route per day for this window: AM=24, PM=25, NOON=1, WEEKEND_PROBE=2, OTHER=null. Ad hoc debugging runs can push observed counts above these, so coverage checks are warn-level. Used with poll_count to compute coverage_pct in the daily aggregate.
{% enddocs %}

{% docs delay_seconds %}
Difference between observed duration_seconds and static_duration_seconds. static_duration_seconds is a historical-average baseline, not a floor, so negative values are valid and indicate lighter-than-typical traffic.
{% enddocs %}

{% docs travel_time_index %}
Ratio of observed duration to static duration (duration_seconds / static_duration_seconds). Values above 1.0 indicate congestion; used for reliability metrics like PTI.
{% enddocs %}
