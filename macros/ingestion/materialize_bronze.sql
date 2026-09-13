{#
    Materializa em Delta os arquivos que a Function de ponte (apolo-infra)
    ja deixou no Volume gerenciado do Unity Catalog (bronze.landing.raw_files).
    Isso e um passo de ingestao, nao de transformacao - roda antes do "dbt build"
    via "dbt run-operation", separado por tier pra bater com o Job que o aciona
    (transform_job_geral / transform_job_frequente).
#}

{% macro materialize_bronze_padrao() %}
    {{ create_bronze_table_from_volume('erp_ficticio_clientes') }}
    {{ create_bronze_table_from_volume('erp_ficticio_produtos') }}
{% endmacro %}

{% macro materialize_bronze_frequente() %}
    {{ create_bronze_table_from_volume('erp_ficticio_pedidos') }}
{% endmacro %}

{% macro create_bronze_table_from_volume(file_name) %}
    {% set schema_sql %}
        create schema if not exists bronze.erp_ficticio
    {% endset %}
    {% do run_query(schema_sql) %}

    {% set table_sql %}
        create or replace table bronze.erp_ficticio.{{ file_name }} as
        select * from read_files(
            '/Volumes/bronze/landing/raw_files/{{ file_name }}.parquet',
            format => 'parquet'
        )
    {% endset %}
    {% do run_query(table_sql) %}

    {{ log("Materializado bronze.erp_ficticio." ~ file_name ~ " a partir do Volume", info=True) }}
{% endmacro %}
