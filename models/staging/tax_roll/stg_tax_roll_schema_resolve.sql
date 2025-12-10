{{ config(
    tags=["tax_roll"]
) }}

select
    coalesce(parcel, prop_id)::varchar(32) as parcel_id,
    tax_year::int as tax_year,
    coalesce(location, prop_location)::varchar(64) as parcel_address,
    coalesce(nullif(trim(coalesce(assessed_value_land, land_assessment)), ''), '0')::numeric(18,2) as assessed_value_land,
    coalesce(nullif(trim(coalesce(assessed_value_improvement, impr_assessment)), ''), '0')::numeric(18,2) as assessed_value_improvement,
    coalesce(nullif(trim(coalesce(total_assessed_value, total_assessment)), ''), '0')::numeric(18,2) as total_assessed_value,
    coalesce(nullif(trim(coalesce(est_fair_mkt_land, est_fmv_land)), ''), '0')::numeric(18,2) as est_fair_mkt_land,
    coalesce(nullif(trim(coalesce(est_fair_mkt_improvement, est_fmv_impr)), ''), '0')::numeric(18,2) as est_fair_mkt_improvement,
    coalesce(nullif(trim(coalesce(total_estimated_fair_market, est_fmv_total)), ''), '0')::numeric(18,2) as total_estimated_fair_market,
    coalesce(nullif(trim(coalesce(current_county_net_tax, county_tax)), ''), '0')::numeric(18,2) as county_tax,
    coalesce(nullif(trim(coalesce(current_city_net_tax, city_tax)), ''), '0')::numeric(18,2) as city_tax,
    coalesce(nullif(trim(coalesce(current_school_net_tax, school_tax)), ''), '0')::numeric(18,2) as school_tax,
    coalesce(nullif(trim(coalesce(current_matc_net_tax, matc_tax)), ''), '0')::numeric(18,2) as matc_tax,
    coalesce(nullif(trim(coalesce(total_current__net_tax, net_tax)), ''), '0')::numeric(18,2) as net_tax,
    coalesce(nullif(trim(coalesce(total_current_tax, gross_tax)), ''), '0')::numeric(18,2) as gross_tax
from {{ source('webfiles', 'madison_tax_roll') }}
