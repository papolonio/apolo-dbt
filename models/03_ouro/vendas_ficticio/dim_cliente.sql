{{ config(
    tags=['tier_padrao'],
    databricks_tags={
        'frequencia_atualizacao': 'D-1',
        'hora_inicio_atualizacao': '03:00',
        'fonte': 'erp_ficticio',
        'tipo_fonte': 'erp',
        'dominio': 'vendas_ficticio',
        'assunto': 'cliente'
    }
) }}

-- Versao publica: CNPJ mascarado por padrao (ver dim_cliente_pii.sql para a versao com dado bruto).
select
    sk_cliente
    , cod_cliente
    , nome_cliente
    , case
        when cnpj is null then null
        when length(cnpj) = 14 then substring(cnpj, 1, 2) || 'XXXXXX' || substring(cnpj, length(cnpj) - 5, 6)
        else 'XXXXXXXXXXXXXX'
    end as cnpj
    , cidade
    , uf
    , dt_cadastro
    , dt_ultima_ingestao
    , current_timestamp() + interval -3 hours as dt_ultima_atualizacao
from {{ ref('prata_cli_cliente') }}
