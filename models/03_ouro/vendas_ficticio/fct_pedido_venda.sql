{{ config(
    materialized='incremental',
    unique_key=['cod_pedido'],
    on_schema_change='append_new_columns',
    databricks_tags={
        'frequencia_atualizacao': 'D-1',
        'hora_inicio_atualizacao': '03:00',
        'fonte': 'erp_ficticio',
        'tipo_fonte': 'erp',
        'dominio': 'vendas_ficticio',
        'assunto': 'pedido_venda'
    }
) }}

select
    sk_pedido
    , cod_pedido
    , sk_cliente
    , cod_cliente
    , sk_produto
    , cod_produto
    , qtd_pedida
    , valor_unitario
    , valor_total_pedido
    , dt_pedido
    , dt_ultima_ingestao
    , current_timestamp() + interval -3 hours as dt_ultima_atualizacao
from {{ ref('prata_ped_pedido') }}
where
    flag_registro_invalido_quarentena = false
    {% if is_incremental() %}
        and dt_ultima_ingestao > (select max(dt_ultima_ingestao) from {{ this }})
    {% endif %}
