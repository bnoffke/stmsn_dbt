{#
  DuckLake never deletes data files on drop/delete/replace — old snapshots
  keep them alive for time travel. Without periodic expiry, every dbt run
  (especially --full-refresh) permanently grows the data path.

  Time travel isn't valuable here (bronze is immutable, the lake is fully
  rebuildable), so expire everything but the current snapshot and delete
  files no snapshot references. Pass a retention interval (e.g. '7 days')
  to keep recent snapshots queryable instead.
#}

{% macro ducklake_cleanup(retention=none) %}
  {%- if execute -%}
    {%- set cutoff = "now() - interval '" ~ retention ~ "'" if retention else "now()" -%}
    {#- 'stmsn' is the ducklake attach alias, not target.database (the in-memory default db) -#}
    {%- do run_query("call ducklake_expire_snapshots('stmsn', older_than => " ~ cutoff ~ ")") -%}
    {%- do run_query("call ducklake_cleanup_old_files('stmsn', cleanup_all => true)") -%}
  {%- endif -%}
{% endmacro %}
