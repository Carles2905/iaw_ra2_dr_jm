# Informe RA3 - Pr ctica 1: Usuarios, perfiles y m¢dulos

## 1. Roles y capacidades

| Usuario | Rol | Puede | No puede |
|---|---|---|---|
| `admin` | Administrador | Control total del sistema, ajustes, plugins, temas y usuarios | - |
| `coord.web` | Editor | Publicar/editar entradas y p ginas propias y ajenas, moderar comentarios | Modificar ajustes generales, gestionar plugins, temas o cuentas |
| `profe.redes` | Autor | Crear, editar, publicar y borrar sus propias entradas; subir im genes | Editar contenido de otros usuarios ni crear p ginas |
| `alumna.fct` | Colaborador | Redactar sus entradas y enviarlas a revisi¢n | Publicar entradas directamente ni subir archivos multimedia |
| `familia.garcia` | Suscriptor | Acceder al panel y modificar los datos de su perfil personal | Redactar contenido, subir archivos o ver administraci¢n |

* **Capacidad que permite publicar entradas:** `publish_posts`
* **Capacidad que permite subir ficheros multimedia:** `upload_files`
