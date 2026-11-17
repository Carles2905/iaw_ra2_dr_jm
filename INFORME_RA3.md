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
