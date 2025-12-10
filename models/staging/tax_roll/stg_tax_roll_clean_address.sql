{{ config(
    tags=["tax_roll"]
) }}

select * exclude(parcel_address),
    upper(trim(parcel_address)) as parcel_address
from {{ ref('stg_tax_roll_schema_resolve') }}