# Pruebas de funcionamiento y rendimiento

| Prueba | Resultado | ¨Correcto? |
|---|---|---|
| Servicios en marcha | 3 servicios activos (nginx, wordpress, db) | S¡ |
| Sitio y panel | Portada y panel cargan con tema activo | S¡ |
| Subida de ficheros | Imagen >2 MB subida sin error (l¡mite 64M) | S¡ |
| Enlaces permanentes | Entrada carga por URL amigable sin 404 | S¡ |
| Persistencia (down/up) | Contenido intacto tras recrear contenedores | S¡ |
| Seguridad (403) | /xmlrpc.php devuelve HTTP 403 Forbidden | S¡ |

## Rendimiento

- **Tiempos de respuesta en el aula (5 medidas):** (Apunta aqu¡ tus 5 tiempos, ej: 0.185s, 0.042s, 0.040s, 0.039s, 0.041s)
- **Memoria por contenedor (docker stats):**
  - `nginx`: (Apunta el consumo, ej: ~12 MB)
  - `wordpress`: (Apunta el consumo, ej: ~68 MB)
  - `db`: (Apunta el consumo, ej: ~95 MB)
- **Interpretaci¢n:** La primera petici¢n requiere mayor tiempo debido al arranque del proceso FastCGI y a la carga inicial de datos en cach‚. Las peticiones consecutivas se reducen dr sticamente. El contenedor de base de datos MariaDB y el proceso PHP-FPM concentran la mayor parte de la memoria RAM del stack.

## Publicaci¢n

- **Direcci¢n desde la que accedi¢ mi compa¤ero/a:** http://(Tu_IP_del_aula):8080
- **Direcci¢n p£blica en Codespaces (paso 4, si lo hice):** (Completar si se realiza el paso 4)
- **Tiempos desde Codespaces y comparaci¢n con el aula:** (Completar si se realiza el paso 4)
