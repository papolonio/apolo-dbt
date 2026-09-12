{{ config(
    databricks_tags={
        'frequencia_atualizacao': 'D-1',
        'fonte': 'erp_ficticio',
        'dominio': 'vendas_ficticio',
        'assunto': 'cliente_pii'
    }
) }}

-- Versao PII: CNPJ em texto puro, sem mascaramento. Em producao, este tipo de
-- model deveria ter acesso controlado por grupo/permissao (Unity Catalog).
select
    sk_cliente
    , cod_cliente
    , nome_cliente
    , cnpj
    , cidade
    , uf
from {{ ref('prata_cli_cliente') }}
