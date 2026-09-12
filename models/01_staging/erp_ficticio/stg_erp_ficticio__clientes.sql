with
cliente as (
    select
        try_cast(cod_cliente as bigint) as cod_cliente
        , nome_cliente
        , cnpj
        , cidade
        , uf
        , try_cast(dt_cadastro as date) as dt_cadastro
        , try_cast(ingestion_datetime as timestamp) as dt_ultima_ingestao
    from {{ source('erp_ficticio', 'clientes') }}
)

select * from cliente
