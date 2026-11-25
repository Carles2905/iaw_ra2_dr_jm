# Informe RA3 - Pr�ctica 1: Usuarios, perfiles y m�dulos

## 1. Roles y capacidades

| Usuario | Rol | Puede | No puede |
|---|---|---|---|
| `admin` | Administrador | Control total del sistema, ajustes, plugins, temas y usuarios | - |
| `coord.web` | Editor | Publicar/editar entradas y p�ginas propias y ajenas, moderar comentarios | Modificar ajustes generales, gestionar plugins, temas o cuentas |
| `profe.redes` | Autor | Crear, editar, publicar y borrar sus propias entradas; subir im�genes | Editar contenido de otros usuarios ni crear p�ginas |
| `alumna.fct` | Colaborador | Redactar sus entradas y enviarlas a revisi�n | Publicar entradas directamente ni subir archivos multimedia |
| `familia.garcia` | Suscriptor | Acceder al panel y modificar los datos de su perfil personal | Redactar contenido, subir archivos o ver administraci�n |

* **Capacidad que permite publicar entradas:** `publish_posts`
* **Capacidad que permite subir ficheros multimedia:** `upload_files`

## 3. Copias de seguridad y prueba de restauración

- **Automatización:** Script `scripts/backup.sh` con comprobación de contenedores activos, volcado transaccional (`mariadb-dump`), empaquetado de `wp-content`, validación con `gzip -t` y rotación de 7 copias.
- **Prueba de desastre controlado:** Se realizó la copia `20261117-160626` (`./scripts/backup.sh`), se eliminó de forma permanente la entrada `1` (`./wp post delete 1 --force`) y se desinstaló el plugin `flamingo` (`./wp plugin delete flamingo`). Posteriormente se ejecutó `./scripts/restore.sh 20261117-160626` confirmando con `SI`.
- **Resultado:** Tras restaurar y recargar con `Ctrl+F5`, se recuperaron íntegramente tanto la entrada `¡Hola, mundo!` (ID 1) como el plugin `flamingo` con sus mensajes almacenados.

## 4. Importación y exportación de contenidos (WXR, CSV, JSON y SQL)

| Formato | Uso principal | Prueba realizada |
|---|---|---|
| **WXR (XML)** | Migrar entradas, páginas, categorías, etiquetas y autores entre sitios WordPress | Exportación completa (`./wp export`), importación de `contenidos_asir.xml` (6 entradas y 2 páginas) e intercambio cooperativo de una entrada de la categoría *Prácticas* con mi pareja |
| **CSV** | Importación masiva de usuarios o exportación de listados tabulares | Importación de usuarios desde `datos/usuarios.csv` (`./wp user import-csv`) y exportación del listado de entradas a `exportaciones/entradas.csv` |
| **JSON** | Integración con aplicaciones externas y consultas a la API REST | Exportación de usuarios con `--format=json` y consulta directa mediante `curl` a `/wp-json/wp/v2/posts` y `/wp-json/wp/v2/users` |
| **SQL** | Copias de seguridad completas o volcados parciales de tablas | Exportación individual de `wp_users` con `mariadb-dump`, verificando el almacenamiento cifrado de contraseñas (`$wp$2y$...`) y la exclusión de `exportaciones/` en `.gitignore` |

## 5. Tema hijo y plantillas en el editor del sitio

- **Tema hijo (`iaw-hijo`):** Creado mediante `./wp scaffold child-theme` heredando de `twentytwentyfive` y personalizado mediante `temas/iaw-hijo/theme.json` (fondo `#F4F7FA`, texto `#21295C` y enlaces `#065A82`).
- **Personalización de plantillas:** Se añadieron los bloques *Autor de la entrada* y *Categorías* en `Entradas individuales`, se actualizó la parte reutilizable `Pie` y se creó la plantilla personalizada `Página informativa` (ancho amplio sin comentarios) asignada a *Horario del ciclo*.
- **Almacenamiento:** Los cambios realizados en el editor del sitio se persisten en la base de datos como registros de tipo `wp_template` y `wp_template_part` (por lo que quedan respaldados en el volcado SQL), manteniendo intactos los ficheros base en `wp-content/themes/iaw-hijo/`.

## 6. Sindicación de contenidos (RSS 2.0 y Atom 1.0)

| Característica | RSS 2.0 (`/feed/`) | Atom 1.0 (`/feed/atom/`) | Ejemplo real obtenido |
|---|---|---|---|
| **Elemento raíz** | `<rss version="2.0"><channel>` | `<feed xmlns="http://www.w3.org/2005/Atom">` | `<rss version="2.0"` / `<feed xmlns="http://www.w3.org/2005/Atom"` |
| **Cada entrada** | `<item>` | `<entry>` | `<item><title>Hackathon de ciberseguridad</title>...` |
| **Formato de fecha** | `<pubDate>` (RFC 822) | `<updated>` y `<published>` (ISO 8601) | `Tue, 03 Nov 2026 15:00:00 +0000` vs `2026-11-03T15:00:00Z` |
| **Identificador** | `<guid>` (opcional) | `<id>` (obligatorio) | `<guid isPermaLink="false">http://localhost:8080/?p=106</guid>` |
| **Estándar** | Especificación de Harvard | RFC 4287 del IETF | Validado correctamente en W3C Feed Validation Service |

- **Configuración y validación:** Se limitó el feed a 5 elementos (`posts_per_rss=5`) mostrando únicamente el extracto (`rss_use_excerpt=1`) y se validó el XML en el validador del W3C.
- **Integración:** Se publicó el icono RSS (`/feed/`) y el enlace al canal de eventos (`/category/eventos/feed/`) en el sitio, y se creó la página *Noticias del sector* consumiendo el feed oficial de WordPress.org y el canal de mi pareja mediante su IP de red local.

## 7. Actualizaciones controladas del stack

| Capa / Componente | Versión antes | Versión después | Método utilizado |
|---|---|---|---|
| **Imagen Nginx** | `nginx:stable` | `nginx:stable` | Verificado en `docker compose images` |
| **Imagen MariaDB** | `mariadb:11` | `mariadb:11` | Verificado en `docker compose images` |
| **Imagen PHP / WordPress** | `7.1-php8.3-fpm` (PHP 8.3.x) | `7.1-php8.4-fpm` (PHP 8.4.x) | Cambio de etiqueta en `docker-compose.yml` + `docker compose pull` |
| **Núcleo WordPress** | `7.1.x` | `7.1.x` (última menor) | `./wp core update --minor` + `update-db` + `verify-checksums` |
| **Plugin Contact Form 7** | `6.0` (prueba) / `6.2.5` | Última estable | `./wp plugin update --all` |
| **Tema hijo (`iaw-hijo`)** | `1.0` | `1.0` | Sin actualizaciones pendientes (`./wp theme list`) |

- **Comportamiento del volumen al actualizar la imagen:** Al actualizar la etiqueta de Docker a `wordpress:7.1-php8.4-fpm`, el contenedor actualiza el binario y las extensiones de PHP a la versión 8.4, pero mantiene intacta la versión de WordPress en `/var/www/html` porque la imagen solo copia el núcleo si el volumen `wp_data` está vacío. Por ello, el núcleo se actualiza de forma independiente con WP-CLI y se verifica su integridad con `verify-checksums`.

## 8. Informes de acceso (Nginx vs. Simple History)

- **Análisis del log HTTP (`scripts/informe-accesos.sh` + GoAccess):** Mediante `awk`, `sort` y `uniq -c` sobre `logs/access.log` y el informe HTML generado con GoAccess se identificaron las peticiones totales, las IP de origen, las URL más solicitadas, los errores `404` (`/no-existe`) y los intentos de acceso al panel (`POST /wp-login.php` con código `200` en intentos fallidos frente a `302` cuando el inicio de sesión tiene éxito).
- **Complementariedad entre registros:**
  - **Nginx (`access.log`):** Registra la capa de red y HTTP (IP cliente, fecha/hora, método, ruta solicitada, código de estado y *User-Agent*), incluso en peticiones anónimas o rutas inexistentes.
  - **Simple History:** Registra la capa de aplicación interna de WordPress, identificando qué cuenta de usuario concreta realizó cada acción (inicios de sesión fallidos o exitosos, actualización de plugins, edición de contenidos o cambios de configuración).
