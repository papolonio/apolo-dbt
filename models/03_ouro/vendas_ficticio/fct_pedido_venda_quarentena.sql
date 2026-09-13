{{ config(
    tags=['tier_frequente'],
    databricks_tags={
        'fonte': 'erp_ficticio',
        'dominio': 'vendas_ficticio',
        'assunto': 'pedido_venda_quarentena'
    }
) }}

-- Registros com chave estrangeira nula (cliente ou produto) ficam aqui, nunca
-- sao descartados silenciosamente do fct_pedido_venda principal.
select
    sk_pedido
    , cod_pedido
    , cod_cliente
    , cod_produto
    , qtd_pedida
    , valor_unitario
    , dt_pedido
    , case
        when cod_cliente is null then 'nulo: cod_cliente'
        when cod_produto is null then 'nulo: cod_produto'
    end as motivo_quarentena
    , dt_ultima_ingestao
from {{ ref('prata_ped_pedido') }}
where flag_registro_invalido_quarentena = true
