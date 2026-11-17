
## Copias de seguridad y restauración

El proyecto incluye scripts en `scripts/` para respaldar la base de datos y `wp-content`:
- **Crear copia:** `./scripts/backup.sh` (genera los ficheros en `backups/` y mantiene las últimas 7 copias).
- **Listar copias:** `./scripts/restore.sh`
- **Restaurar copia:** `./scripts/restore.sh AAAAMMDD-HHMMSS` (requiere confirmar escribiendo `SI`).
