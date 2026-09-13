"""Garante que todo model tenha exatamente uma tag de tier (tier_padrao ou
tier_frequente). Sem isso, um model fica ambiguo sobre qual Databricks Job
(transform_job_geral vs transform_job_frequente) e responsavel por mante-lo
atualizado - ou pode acabar sendo construido pelos dois, causando trabalho
duplicado e concorrencia na mesma tabela Delta.
"""

import json
import subprocess
import sys

TIER_TAGS = {"tier_padrao", "tier_frequente"}


def main() -> None:
    result = subprocess.run(
        ["dbt", "ls", "--resource-type", "model", "--output", "json", "--output-keys", "name", "tags"],
        capture_output=True,
        text=True,
        check=True,
    )

    errors = []
    for line in result.stdout.strip().splitlines():
        line = line.strip()
        if not line.startswith("{"):
            continue
        node = json.loads(line)
        name = node["name"]
        tier_tags = set(node.get("tags", [])) & TIER_TAGS

        if not tier_tags:
            errors.append(f"{name}: sem tag de tier (precisa de exatamente uma: {sorted(TIER_TAGS)})")
        elif len(tier_tags) > 1:
            errors.append(f"{name}: tem mais de uma tag de tier ({sorted(tier_tags)}), precisa de exatamente uma")

    if errors:
        print("Validacao de tier falhou:")
        for error in errors:
            print(f"  - {error}")
        sys.exit(1)

    print(f"OK: todos os models tem exatamente uma tag de tier ({sorted(TIER_TAGS)}).")


if __name__ == "__main__":
    main()
