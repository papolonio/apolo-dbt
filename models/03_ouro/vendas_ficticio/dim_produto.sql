{{ config(
    databricks_tags={
        'frequencia_atualizacao': 'D-1',
        'hora_inicio_atualizacao': '03:00',
        'fonte': 'erp_ficticio',
        'tipo_fonte': 'erp',
        'dominio': 'vendas_ficticio',
        'assunto': 'produto'
    }
) }}

select
    sk_produto
    , cod_produto
    , descricao_produto
    , categoria
    , unidade_medida
    , dt_cadastro
    , dt_ultima_ingestao
    , current_timestamp() + interval -3 hours as dt_ultima_atualizacao
from {{ ref('prata_mat_produto') }}
