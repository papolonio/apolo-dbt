# apolo-dbt

Projeto dbt da "Apolo" (empresa fictícia usada como contexto de negócio deste portfólio, no mesmo espírito do `jaffle_shop` da própria dbt Labs). Camada de analytics engineering: staging → prata → ouro sobre dados de ERP/vendas fictícios, rodando contra um workspace **Databricks Free Edition** (Unity Catalog nativo, serverless-only).

Este repositório é um dos três que compõem o projeto de portfólio [apolo-infra](https://github.com/papolonio/apolo-infra):

- [apolo-infra](https://github.com/papolonio/apolo-infra) — infraestrutura (Bicep: ADF, ADLS Gen2, Key Vault, Monitor) e setup do Databricks
- [apolo-adf](https://github.com/papolonio/apolo-adf) — pipelines do Azure Data Factory
- **apolo-dbt** (este repo) — projeto dbt

## Estrutura

```
apolo-dbt/
├── dbt_project.yml
├── profiles.yml            # usa env_var() — segredos reais ficam em .env local (gitignored)
├── packages.yml
├── models/
│   ├── 01_staging/
│   ├── 02_prata/
│   └── 03_ouro/
└── macros/
```

## Rodando localmente

```
python3 -m venv .venv
source .venv/bin/activate
pip install dbt-databricks

cp .exemplo.env .env   # preencher com host/http_path/token reais do Databricks
export DBT_PROFILES_DIR=.
dbt deps
dbt build
```

## Camadas

- **01_staging**: normalização direta das fontes (`source()`), 1:1 com a origem.
- **02_prata**: modelos de negócio limpos, com quarentena de registros inválidos.
- **03_ouro**: dimensões e fatos (`dim_*`/`fct_*`), incluindo segregação de PII (`dim_cliente` mascarado vs `dim_cliente_pii`).

A camada `bronze` (fonte) é alimentada pelo pipeline real do repositório `apolo-adf` (ADF) → `apolo-infra` (ponte para o Databricks), não por `dbt seed`.
