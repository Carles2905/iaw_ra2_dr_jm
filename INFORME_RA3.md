# Informe RA3 - Pr燾tica 1: Usuarios, perfiles y mulos

## 1. Roles y capacidades

| Usuario | Rol | Puede | No puede |
|---|---|---|---|
| `admin` | Administrador | Control total del sistema, ajustes, plugins, temas y usuarios | - |
| `coord.web` | Editor | Publicar/editar entradas y p爂inas propias y ajenas, moderar comentarios | Modificar ajustes generales, gestionar plugins, temas o cuentas |
| `profe.redes` | Autor | Crear, editar, publicar y borrar sus propias entradas; subir im爂enes | Editar contenido de otros usuarios ni crear p爂inas |
| `alumna.fct` | Colaborador | Redactar sus entradas y enviarlas a revisi | Publicar entradas directamente ni subir archivos multimedia |
| `familia.garcia` | Suscriptor | Acceder al panel y modificar los datos de su perfil personal | Redactar contenido, subir archivos o ver administraci |

* **Capacidad que permite publicar entradas:** `publish_posts`
* **Capacidad que permite subir ficheros multimedia:** `upload_files`

## 3. Copias de seguridad y prueba de restauraci贸n

- **Automatizaci贸n:** Script `scripts/backup.sh` con comprobaci贸n de contenedores activos, volcado transaccional (`mariadb-dump`), empaquetado de `wp-content`, validaci贸n con `gzip -t` y rotaci贸n de 7 copias.
- **Prueba de desastre controlado:** Se realiz贸 la copia `20261117-160626` (`./scripts/backup.sh`), se elimin贸 de forma permanente la entrada `1` (`./wp post delete 1 --force`) y se desinstal贸 el plugin `flamingo` (`./wp plugin delete flamingo`). Posteriormente se ejecut贸 `./scripts/restore.sh 20261117-160626` confirmando con `SI`.
- **Resultado:** Tras restaurar y recargar con `Ctrl+F5`, se recuperaron 铆ntegramente tanto la entrada `隆Hola, mundo!` (ID 1) como el plugin `flamingo` con sus mensajes almacenados.

## 4. Importaci贸n y exportaci贸n de contenidos (WXR, CSV, JSON y SQL)

| Formato | Uso principal | Prueba realizada |
|---|---|---|
| **WXR (XML)** | Migrar entradas, p谩ginas, categor铆as, etiquetas y autores entre sitios WordPress | Exportaci贸n completa (`./wp export`), importaci贸n de `contenidos_asir.xml` (6 entradas y 2 p谩ginas) e intercambio cooperativo de una entrada de la categor铆a *Pr谩cticas* con mi pareja |
| **CSV** | Importaci贸n masiva de usuarios o exportaci贸n de listados tabulares | Importaci贸n de usuarios desde `datos/usuarios.csv` (`./wp user import-csv`) y exportaci贸n del listado de entradas a `exportaciones/entradas.csv` |
| **JSON** | Integraci贸n con aplicaciones externas y consultas a la API REST | Exportaci贸n de usuarios con `--format=json` y consulta directa mediante `curl` a `/wp-json/wp/v2/posts` y `/wp-json/wp/v2/users` |
| **SQL** | Copias de seguridad completas o volcados parciales de tablas | Exportaci贸n individual de `wp_users` con `mariadb-dump`, verificando el almacenamiento cifrado de contrase帽as (`$wp$2y$...`) y la exclusi贸n de `exportaciones/` en `.gitignore` |

## 5. Tema hijo y plantillas en el editor del sitio

- **Tema hijo (`iaw-hijo`):** Creado mediante `./wp scaffold child-theme` heredando de `twentytwentyfive` y personalizado mediante `temas/iaw-hijo/theme.json` (fondo `#F4F7FA`, texto `#21295C` y enlaces `#065A82`).
- **Personalizaci贸n de plantillas:** Se a帽adieron los bloques *Autor de la entrada* y *Categor铆as* en `Entradas individuales`, se actualiz贸 la parte reutilizable `Pie` y se cre贸 la plantilla personalizada `P谩gina informativa` (ancho amplio sin comentarios) asignada a *Horario del ciclo*.
- **Almacenamiento:** Los cambios realizados en el editor del sitio se persisten en la base de datos como registros de tipo `wp_template` y `wp_template_part` (por lo que quedan respaldados en el volcado SQL), manteniendo intactos los ficheros base en `wp-content/themes/iaw-hijo/`.

## 6. Sindicaci贸n de contenidos (RSS 2.0 y Atom 1.0)

| Caracter铆stica | RSS 2.0 (`/feed/`) | Atom 1.0 (`/feed/atom/`) | Ejemplo real obtenido |
|---|---|---|---|
| **Elemento ra铆z** | `<rss version="2.0"><channel>` | `<feed xmlns="http://www.w3.org/2005/Atom">` | `<rss version="2.0"` / `<feed xmlns="http://www.w3.org/2005/Atom"` |
| **Cada entrada** | `<item>` | `<entry>` | `<item><title>Hackathon de ciberseguridad</title>...` |
| **Formato de fecha** | `<pubDate>` (RFC 822) | `<updated>` y `<published>` (ISO 8601) | `Tue, 03 Nov 2026 15:00:00 +0000` vs `2026-11-03T15:00:00Z` |
| **Identificador** | `<guid>` (opcional) | `<id>` (obligatorio) | `<guid isPermaLink="false">http://localhost:8080/?p=106</guid>` |
| **Est谩ndar** | Especificaci贸n de Harvard | RFC 4287 del IETF | Validado correctamente en W3C Feed Validation Service |

- **Configuraci贸n y validaci贸n:** Se limit贸 el feed a 5 elementos (`posts_per_rss=5`) mostrando 煤nicamente el extracto (`rss_use_excerpt=1`) y se valid贸 el XML en el validador del W3C.
- **Integraci贸n:** Se public贸 el icono RSS (`/feed/`) y el enlace al canal de eventos (`/category/eventos/feed/`) en el sitio, y se cre贸 la p谩gina *Noticias del sector* consumiendo el feed oficial de WordPress.org y el canal de mi pareja mediante su IP de red local.
