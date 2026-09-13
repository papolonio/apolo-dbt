{{ config(tags=['tier_frequente']) }}

{#
    Aqui aplicamos o padrao de "quarentena" do template: pedidos com cod_cliente nulo
    (dado essencial ausente) sao sinalizados via flag_registro_invalido_quarentena,
    para serem separados na camada Ouro (fct_pedido_venda vs fct_pedido_venda_quarentena),
    nunca descartados silenciosamente.
#}
with
pedido as (
    select * from {{ ref('stg_erp_ficticio__pedidos') }}
)

, pedido_final as (
    select
        xxhash64(pedido.cod_pedido) as sk_pedido
        , pedido.cod_pedido
        , xxhash64(pedido.cod_cliente) as sk_cliente
        , pedido.cod_cliente
        , xxhash64(pedido.cod_produto) as sk_produto
        , pedido.cod_produto
        , pedido.qtd_pedida
        , pedido.valor_unitario
        , pedido.qtd_pedida * pedido.valor_unitario as valor_total_pedido
        , pedido.dt_pedido
        , (pedido.cod_cliente is null or pedido.cod_produto is null) as flag_registro_invalido_quarentena
        , pedido.dt_ultima_ingestao
        , current_timestamp() + interval -3 hours as dt_ultima_atualizacao
    from pedido
)

select * from pedido_final
