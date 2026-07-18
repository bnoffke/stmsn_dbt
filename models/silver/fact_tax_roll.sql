{{ config(
    tags=["tax_roll", "yearly"],
    unique_key='tax_year',
    partition_by='tax_year'
) }}

select *
from {{ ref('int_tax_roll_clean_address') }}
{% if is_incremental() %}
where tax_year >= (select max(tax_year) from {{ this }})
{% endif %}