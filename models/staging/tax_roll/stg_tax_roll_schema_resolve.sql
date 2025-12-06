{{ config(
    tags=["tax_roll"]
) }}

select 
    coalesce(parcel,"Parcel", "PROP ID")::varchar(32) as parcel_id,
    coalesce(tax_year,"Tax Year", "TAX YEAR")::int as tax_year,
    coalesce("address","Prop Location", "PROP LOCATION")::varchar(64) as parcel_address,
    coalesce(assessed_value_land"Assessed Value Land", "LAND ASSESSMENT")::numeric(18,2) as assessed_value_land,
    coalesce("Assessed Value Improvement", "IMPR ASSESSMENT")::numeric(18,2) as assessed_value_improvement,
    coalesce("Total Assessed Value", "TOTAL ASSESSMENT")::numeric(18,2) as total_assessed_value,
    coalesce("Est. Fair Mkt. Land", "EST FMV LAND")::numeric(18,2) as est_fair_mkt_land,
    coalesce("Est. Fair Mkt. Improvement", "EST FMV IMPR")::numeric(18,2) as est_fair_mkt_improvement,
    coalesce("Total Estimated Fair Market", "EST FMV TOTAL")::numeric(18,2) as total_estimated_fair_market,
    coalesce("Current County Net Tax", "COUNTY TAX")::numeric(18,2) as current_county_net_tax,
    coalesce("Current City Net Tax", "CITY TAX")::numeric(18,2) as current_city_net_tax,
    coalesce("Current School Net Tax", "SCHOOL TAX")::numeric(18,2) as current_school_net_tax,
    coalesce("Current MATC Net Tax", "MATC TAX")::numeric(18,2) as current_matc_net_tax,
    coalesce("Total Current  Net Tax", "NET TAX")::numeric(18,2) as total_current_net_tax,
    coalesce("Total Current Tax", "GROSS TAX")::numeric(18,2) as total_current_tax
from {{ ref('stg_tax_roll_union') }}