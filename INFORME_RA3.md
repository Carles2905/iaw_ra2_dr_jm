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
