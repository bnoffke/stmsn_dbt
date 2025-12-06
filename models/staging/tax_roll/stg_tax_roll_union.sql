{{ config(
    tags=['tax_roll']
) }}

select * from {{ source('arcgis','madison_tax_roll') }}
union all by name
select * from {{ source('legacy','madison_tax_roll_legacy') }}