{{ config(
    tags=["tax_roll"]
) }}

select
    coalesce(parcel, prop_id)::varchar(32) as parcel_id,
    tax_year::int as tax_year,
    coalesce(location, prop_location)::varchar(64) as parcel_address,
    coalesce(assessed_value_land, land_assessment)::numeric(18,2) as assessed_value_land,
    coalesce(assessed_value_improvement, impr_assessment)::numeric(18,2) as assessed_value_improvement,
    coalesce(total_assessed_value, total_assessment)::numeric(18,2) as total_assessed_value,
    coalesce(est_fair_mkt_land, est_fmv_land)::numeric(18,2) as est_fair_mkt_land,
    coalesce(est_fair_mkt_improvement, est_fmv_impr)::numeric(18,2) as est_fair_mkt_improvement,
    coalesce(total_estimated_fair_market, est_fmv_total)::numeric(18,2) as total_estimated_fair_market,
    coalesce(current_county_net_tax, county_tax)::numeric(18,2) as county_tax,
    coalesce(current_city_net_tax, city_tax)::numeric(18,2) as city_tax,
    coalesce(current_school_net_tax, school_tax)::numeric(18,2) as school_tax,
    coalesce(current_matc_net_tax, matc_tax)::numeric(18,2) as matc_tax,
    coalesce(total_current__net_tax, net_tax)::numeric(18,2) as net_tax,
    coalesce(total_current_tax, gross_tax)::numeric(18,2) as gross_tax
from {{ source('webfiles', 'madison_tax_roll') }}
