#!/usr/bin/env bash
set -Eeuo pipefail

case "${1:-}" in
  prod) compose=deploy/docker-compose.yml; port=8081 ;;
  dev) compose=deploy/docker-compose.dev.yml; port=8082 ;;
  *) echo 'Uso: deploy-container.sh prod|dev' >&2; exit 2 ;;
esac

legacy="pca-study-$1"
backup="pca-notes-$1-previous"
renamed=false
stopped=false
was_running=false
attempted=false

rollback() {
  local status=$?
  trap - EXIT
  if [ "$status" -ne 0 ] && { [ "$renamed" = true ] || [ "$stopped" = true ]; }; then
    echo 'Falha no deploy; restaurando container anterior.' >&2
    if [ "$attempted" = true ]; then
      docker compose -f "$compose" down --remove-orphans || true
    fi
    if [ "$renamed" = true ]; then
      docker rename "$backup" "$legacy" || true
    fi
    if [ "$was_running" = true ]; then
      docker start "$legacy" || true
    fi
  fi
  exit "$status"
}
trap rollback EXIT

docker compose -f "$compose" build --pull

if docker container inspect "$legacy" >/dev/null 2>&1; then
  if docker container inspect "$backup" >/dev/null 2>&1; then
    echo "Backup $backup já existe; migração interrompida." >&2
    exit 1
  fi
  was_running=$(docker container inspect --format '{{.State.Running}}' "$legacy")
  if [ "$was_running" = true ]; then
    docker stop "$legacy"
    stopped=true
  fi
  docker rename "$legacy" "$backup"
  renamed=true
fi

attempted=true
docker compose -f "$compose" up -d --force-recreate

expected=$(sha256sum web/index.html | awk '{print $1}')
for attempt in 1 2 3 4 5; do
  actual=$(curl -fsS "http://127.0.0.1:$port/index.html" | sha256sum | awk '{print $1}') || actual=''
  if [ "$actual" = "$expected" ]; then
    echo "Deploy $1 validado: conteúdo corresponde aos arquivos enviados."
    exit 0
  fi
  echo "Tentativa $attempt: conteúdo ainda não corresponde." >&2
  sleep 2
done

echo 'Health check falhou: conteúdo incorreto ou indisponível.' >&2
exit 1
