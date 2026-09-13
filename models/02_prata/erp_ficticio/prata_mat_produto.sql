{{ config(tags=['tier_padrao']) }}

with
produto as (
    select * from {{ ref('stg_erp_ficticio__produtos') }}
)

, produto_final as (
    select
        xxhash64(produto.cod_produto) as sk_produto
        , produto.cod_produto
        , produto.descricao_produto
        , produto.categoria
        , produto.unidade_medida
        , produto.dt_cadastro
        , produto.dt_ultima_ingestao
        , current_timestamp() + interval -3 hours as dt_ultima_atualizacao
    from produto
)

select * from produto_final
