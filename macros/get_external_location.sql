{% macro get_external_location() %}
  {% set layer = model.path.split('/')[0]%}
  {% set model_name = this.name %}

  {% if target.name == 'prod' %}
    {{ return('gs://stmsn-' ~ layer ~ '/' ~ model_name ~ '.parquet') }}
  {% else %}
    {% set dev_path = '~/data/stmsn_dbt/' ~ layer %}
    {{ return(dev_path ~ '/' ~ model_name ~ '.parquet') }}
  {% endif %}

{% endmacro %}