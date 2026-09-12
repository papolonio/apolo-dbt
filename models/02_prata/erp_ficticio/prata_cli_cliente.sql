with
cliente as (
    select * from {{ ref('stg_erp_ficticio__clientes') }}
)

, cliente_final as (
    select
        xxhash64(cliente.cod_cliente) as sk_cliente
        , cliente.cod_cliente
        , cliente.nome_cliente
        , {{ cpf_cnpj_cleaning('cliente.cnpj') }} as cnpj
        , cliente.cidade
        , cliente.uf
        , cliente.dt_cadastro
        , cliente.dt_ultima_ingestao
        , current_timestamp() + interval -3 hours as dt_ultima_atualizacao
    from cliente
)

select * from cliente_final
