{{ config(
    tags=["route_traffic", "daily"],
    materialized='incremental',
    incremental_strategy='delete+insert',
    unique_key='request_date_local'
) }}

select *
from {{ ref('int_route_traffic') }}
{% if is_incremental() %}
where request_date_local >= (select max(request_date_local) from {{ this }})
  and request_date_local < current_date
{% endif %}
