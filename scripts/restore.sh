#!/usr/bin/env bash
set -euo pipefail
export MSYS_NO_PATHCONV=1

cd "$(dirname "$0")/.."
DESTINO="backups"

if [ $# -eq 0 ]; then
  echo "Copias disponibles (marca de fecha AAAAMMDD-HHMMSS):"
  ls -1 "$DESTINO"/db_*.sql.gz 2>/dev/null | sed -E 's/.*db_([0-9-]+)\.sql\.gz/  \1/' || echo "  (Ninguna)"
  echo "Uso: ./scripts/restore.sh AAAAMMDD-HHMMSS"
  exit 0
fi

FECHA="$1"
F_DB="$DESTINO/db_$FECHA.sql.gz"
F_WP="$DESTINO/wp-content_$FECHA.tar.gz"

if [ ! -f "$F_DB" ] || [ ! -f "$F_WP" ]; then
  echo "ERROR: No existen ambos ficheros para la fecha $FECHA en $DESTINO/" >&2
  exit 1
fi

read -r -p "ATENCIÓN: Se sobrescribirá la base de datos y wp-content con la copia $FECHA. Escribe SI para continuar: " CONF
if [ "$CONF" != "SI" ]; then
  echo "Restauración cancelada."
  exit 1
fi

echo "-> Restaurando base de datos..."
gunzip -c "$F_DB" | docker compose exec -T db sh -c 'mariadb -u"$WP_DB_USER" -p"$WP_DB_PASSWORD" "$WP_DB_NAME"'

echo "-> Restaurando wp-content..."
cat "$F_WP" | docker compose exec -T wordpress sh -c 'rm -rf /var/www/html/wp-content && tar -xzf - -C /var/www/html && chown -R www-data:www-data /var/www/html/wp-content'

echo "OK. Restauración de $FECHA completada."
