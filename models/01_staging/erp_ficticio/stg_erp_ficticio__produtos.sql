{{ config(tags=['tier_padrao']) }}

with
produto as (
    select
        try_cast(cod_produto as bigint) as cod_produto
        , descricao_produto
        , categoria
        , unidade_medida
        , try_cast(dt_cadastro as date) as dt_cadastro
        , try_cast(ingestion_datetime as timestamp) as dt_ultima_ingestao
    from {{ source('erp_ficticio', 'produtos') }}
)

select * from produto
