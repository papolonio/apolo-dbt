{{ config(tags=['tier_frequente']) }}

with
pedido as (
    select
        try_cast(cod_pedido as bigint) as cod_pedido
        , try_cast(cod_cliente as bigint) as cod_cliente
        , try_cast(cod_produto as bigint) as cod_produto
        , try_cast(qtd_pedida as decimal(18, 3)) as qtd_pedida
        , try_cast(valor_unitario as decimal(18, 2)) as valor_unitario
        , try_cast(dt_pedido as date) as dt_pedido
        , try_cast(ingestion_datetime as timestamp) as dt_ultima_ingestao
    from {{ source('erp_ficticio', 'pedidos') }}
)

select * from pedido
