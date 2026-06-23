# Calculated Metrics and Derived Columns

This file contains documentation for calculated metrics and derived columns used in fact models for property tax and land value analysis.

## Identifiers and Linking

{% docs site_parcel_id %}
The primary parcel identifier for a site, used to group parcels that share the same geographic footprint. Multiple parcels may share a single site_parcel_id when they represent subdivisions or condominiums on the same property. Use this for site-level aggregations and analysis.
{% enddocs %}

{% docs alder_district_name %}
The name of the aldermanic district in which the property is located, joined from the alder district overlay spatial analysis. This provides the human-readable district name corresponding to the alder_district number. Use this for district-level reporting and filtering.
{% enddocs %}

{% docs area_plan_name %}
The name of the area plan zone in which the property is located, joined from the area plan overlay spatial analysis. Area plans guide development and land use policies for specific neighborhoods or districts. Use this for planning analysis and development impact assessment.
{% enddocs %}

## Address Fields

{% docs full_address %}
The complete formatted street address for the property, concatenated from house_nbr, street_dir, street_name, street_type, and unit components. Format: "{house_nbr} {street_dir} {street_name} {street_type} Unit {unit}" with proper spacing and null handling. Use this for display, geocoding, and address matching.
{% enddocs %}

## Tax Rate Metrics

{% docs tax_rate %}
The effective property tax rate calculated as net taxes divided by current total property value (net_taxes / current_total_value). Represents the percentage of property value paid in net taxes annually. Use this to compare tax burdens across properties of different values. Note: Values can be null or infinite when current_total_value is zero.
{% enddocs %}

{% docs net_taxes_per_sqft_lot %}
Net property taxes per square foot of lot area, calculated as net_taxes divided by lot_size. Measures the tax burden relative to land area, useful for comparing properties of different sizes. Higher values indicate higher taxation density on the land. Use this for per-area tax comparisons and land value analysis.
{% enddocs %}

{% docs total_taxes_per_sqft_lot %}
Total property taxes (including special assessments and other charges) per square foot of lot area, calculated as total_taxes divided by lot_size. Provides a comprehensive view of all tax obligations relative to land area. Use this when you need to account for the full tax burden including special assessments.
{% enddocs %}

## Land Value Metrics

{% docs land_value_per_sqft_lot %}
The assessed land value per square foot of lot area, calculated as current_land_value divided by lot_size. Represents the per-unit-area value of the land itself, excluding improvements. Use this to identify high-value land, compare land values across neighborhoods, or detect underutilized properties.
{% enddocs %}

{% docs land_share_property %}
The proportion of total property value attributable to land (versus improvements), calculated as current_land_value divided by current_total_value. Ranges from 0 to 1, where higher values indicate land represents a larger share of total value. Use this to identify land-intensive properties or detect potential teardown candidates where land value exceeds improvement value.
{% enddocs %}

## City-Wide Comparison Metrics

{% docs current_total_land_value_city %}
The total assessed land value for all properties in the city, calculated using a window function: sum(current_land_value) over (partition by 1). This is a constant value across all rows representing the citywide total. Use this as a denominator for calculating property shares of city totals. Computed using window functions for efficient calculation.
{% enddocs %}

{% docs current_total_value_city %}
The total assessed property value (land + improvements) for all properties in the city, calculated using a window function: sum(current_total_value) over (partition by 1). This is a constant value across all rows representing the citywide total. Use this for calculating a property's share of total city value or for city-wide aggregations.
{% enddocs %}

{% docs total_net_taxes_city %}
The total net property taxes collected across all properties in the city, calculated using a window function: sum(net_taxes) over (partition by 1). This is a constant value across all rows representing citywide tax revenue. Use this for calculating a property's share of city tax revenue or estimating revenue impacts.
{% enddocs %}

## Land Value Tax Analysis

{% docs land_share_city %}
The property's land value as a proportion of the city's total land value, calculated as current_land_value divided by current_total_land_value_city. Indicates what percentage of the city's total land value this property represents. Use this for identifying high-value properties or analyzing concentration of land value. Small values (close to 0) are typical for individual properties.
{% enddocs %}

{% docs total_share_city %}
The property's total assessed value as a proportion of the city's total property value, calculated as current_total_value divided by current_total_value_city. Indicates what percentage of the city's total property value this property represents. Use this for analyzing property value concentration or identifying the highest-value properties.
{% enddocs %}

{% docs land_total_ratio_city %}
The ratio comparing a property's land value share to its total value share in the city, calculated as land_share_city divided by total_share_city. Values greater than 1 indicate the property's land is relatively more valuable compared to its total value share. Values less than 1 indicate improvements add proportionally more value than the land. Use this to identify properties where land value is disproportionately high or low relative to total value.
{% enddocs %}

{% docs land_value_alignment_index %}
An index measuring how aligned a property's land value is with its total value, calculated as total_share_city divided by land_share_city (inverse of land_total_ratio_city). Values greater than 1 indicate improvements add proportionally more value than land. Values less than 1 indicate land is proportionally more valuable. Use this for land value tax analysis and identifying redevelopment opportunities. A value of 1 indicates perfect alignment between land and total value proportions.
{% enddocs %}

{% docs land_value_shift_taxes %}
The hypothetical tax amount this property would pay if city taxes were based solely on land value share rather than total property value, calculated as land_share_city multiplied by total_net_taxes_city. This represents what the property owner would pay under a pure land value tax system. Compare this to actual net_taxes to understand how a land value tax would shift the tax burden for this property. Properties with high land values would pay more; properties with valuable improvements would pay less.
{% enddocs %}

## Special Assessments

{% docs special_assessment %}
Special assessments levied against the property for specific improvements or services, such as street construction, sewer connections, or local infrastructure projects. These are additional charges beyond regular property taxes. This column may also be labeled as special_assmnt in some source tables. Use this to analyze the full cost burden on property owners beyond standard taxation.
{% enddocs %}
