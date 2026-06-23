{% docs id %}
A unique identifier for each parcel of land or property within the municipality, essential for tracking ownership and property details.
{% enddocs %}

{% docs district_id %}
A unique identifier assigned to each district within the municipality. This ID is used to categorize and manage data specific to each district, facilitating better organization and analysis of local resources and services.
{% enddocs %}

{% docs taxes_per_sqft %}
This metric indicates the total taxes assessed per square foot of the parcel, useful for comparative analysis across properties.
{% enddocs %}

{% docs avg_taxes_per_sqft %}
The average tax amount levied per square foot across all properties, providing insight into taxation trends relative to property size. 
{% enddocs %}

{% docs taxes_per_city_maint_street_sqft %}
The amount of taxes generated per square foot of city-maintained streets. This metric provides insight into the financial contributions of street-related properties to municipal revenue and can influence budget decisions for infrastructure projects.
{% enddocs %}

{% docs total_parcels %}
The total number of parcels of land recorded in the municipality, representing the sum of all individual properties.
{% enddocs %}

{% docs total_bedrooms %}
The cumulative number of bedrooms across all properties within the specified area, providing insight into housing capacity and potential occupancy.
{% enddocs %}

{% docs total_land_value %}
The combined assessed value of all land parcels, which indicates the worth of the land itself excluding any improvements or structures.
{% enddocs %}

{% docs total_improvement_value %}
The total assessed value of improvements or structures on the land parcels, reflecting the investment in buildings and enhancements.
{% enddocs %}

{% docs total_value %}
The overall assessed value of all properties, calculated as the sum of total land value and total improvement value, representing the complete worth of properties.
{% enddocs %}

{% docs total_net_taxes %}
The total amount of taxes collected from all properties after accounting for any exemptions or reductions, critical for municipal revenue generation.
{% enddocs %}

{% docs total_dwelling_units %}
This indicates the total number of dwelling units present on the property.
{% enddocs %}

{% docs total_area %}
The sum of land area measured in square feet or acres for all parcels, which helps in planning and zoning processes.
{% enddocs %}

{% docs year_number %}
The year in which the data was collected or reported. This is typically used to analyze trends over time or to benchmark infrastructure changes and maintenance activities within a specific year.
{% enddocs %}

{% docs parcel_ids %}
The ordered list of individual parcel_ids that have been grouped into a single site record. fact_sites aggregates parcels sharing the same geographic footprint (site_parcel_id), so this array captures all constituent parcel identifiers for traceability back to the parcel level.
{% enddocs %}

{% docs total_people_impervious_surface_area %}
The total area in square feet of impervious surfaces classified as "people" surfaces (e.g., sidewalks, playgrounds, building footprints) within the district, plan boundary, or site. Summed from intersecting impervious surface polygons where is_people_surface = 1.
{% enddocs %}

{% docs total_vehicle_impervious_surface_area %}
The total area in square feet of impervious surfaces classified as "vehicle" surfaces (e.g., roads, parking lots, driveways, alleys) within the district, plan boundary, or site. Summed from intersecting impervious surface polygons where is_vehicle_surface = 1.
{% enddocs %}

{% docs people_to_vehicle_surface_ratio %}
The ratio of people impervious surface area to vehicle impervious surface area, calculated as total_people_impervious_surface_area divided by total_vehicle_impervious_surface_area. Values greater than 1 indicate more pedestrian-oriented surface coverage; values less than 1 indicate vehicle infrastructure dominates. Returns null when total_vehicle_impervious_surface_area is zero.
{% enddocs %}

{% docs people_surface_area_per_dwelling_unit %}
People impervious surface area (sidewalks, playgrounds, etc.) divided by the total number of dwelling units in the area, calculated as total_people_impervious_surface_area divided by total_dwelling_units. Measures the pedestrian surface coverage available per housing unit. Returns null when total_dwelling_units is zero.
{% enddocs %}

{% docs vehicle_surface_area_per_dwelling_unit %}
Vehicle impervious surface area (roads, parking, driveways, etc.) divided by the total number of dwelling units in the area, calculated as total_vehicle_impervious_surface_area divided by total_dwelling_units. Measures the vehicle surface coverage per housing unit and can indicate car-dependency of an area. Returns null when total_dwelling_units is zero.
{% enddocs %}
