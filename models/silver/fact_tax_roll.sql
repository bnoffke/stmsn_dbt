{{ config(
    tags=["tax_roll"],
    location=get_external_location()
) }}

select *
from {{ ref('stg_tax_roll_clean_address') }}