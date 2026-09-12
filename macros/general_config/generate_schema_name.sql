{#
    Override do generate_schema_name padrao do dbt: o schema final da tabela e o
    "custom_schema_name" definido na pasta (staging/prata/ouro), SEM concatenar
    com o schema default do profile/target — assim uma tabela de prata sempre
    cai no schema "prata", independente de qual target (dev/prod) voce estiver rodando.
#}

{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}
