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

{% docs dt %}
Collection date partition (UTC) for the record.
{% enddocs %}
