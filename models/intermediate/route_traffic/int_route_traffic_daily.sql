{{ config(
    tags=["route_traffic", "daily"],
    materialized='incremental',
    incremental_strategy='delete+insert',
    unique_key='dt'
) }}

select *
from {{ ref('int_route_traffic') }}
{% if is_incremental() %}
where dt >= (select max(dt) from {{ this }})
  and dt < current_date
{% endif %}
