{#
    Remove pontuacao comum de CPF/CNPJ (pontos, barra, hifen, espacos),
    deixando so os digitos.
#}
{% macro cpf_cnpj_cleaning(column) -%}
    regexp_replace({{ column }}, '[ ./\\-]', '')
{%- endmacro %}
