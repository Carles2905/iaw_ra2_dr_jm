# Seguridad del gestor

| Comprobaci¢n | Antes | Despu‚s |
|---|---|---|
| Cabecera Server | Muestra versi¢n (`nginx/1.26.x`) | Oculta versi¢n (`Server: nginx`) |
| /xmlrpc.php | Accesible (c¢digo 200 / 405) | Bloqueado (`403 Forbidden`) |
| /wp-config.php | Accesible directamente | Bloqueado (`403 Forbidden`) |
| PHP en uploads | Ejecuta c¢digo (devolvi¢ `2`) | Bloqueado (`403 Forbidden`) |
| Edici¢n de ficheros desde el panel | Habilitada en Apariencia y Plugins | Deshabilitada (`DISALLOW_FILE_EDIT`) |
| L¡mite de intentos de login | Sin l¡mite (vulnerable a fuerza bruta) | Bloqueo temporal activo con plugin |

## Medidas aplicadas y por qu‚

1. **Ocultaci¢n de cabeceras (`server_tokens off`):** Dificulta el escaneo automatizado al no revelar la versi¢n exacta de Nginx.
2. **Bloqueo de `xmlrpc.php` y `wp-config.php`:** Mitiga ataques distribuidos de amplificaci¢n (DDoS), intentos de fuerza bruta masiva y protege la fuga accidental de credenciales de base de datos.
3. **Denegaci¢n de ejecuci¢n PHP en `uploads`:** Anula ataques de subida de archivos maliciosos (webshells) aislando el directorio a solo lectura est tica.
4. **`DISALLOW_FILE_EDIT` en WordPress:** Evita que un atacante con acceso al panel administrativo pueda inyectar c¢digo PHP arbitrario en los archivos del tema o plugins.
5. **Gesti¢n de cuentas y m¡nimo privilegio:** Creaci¢n de cuenta con rol Editor para operativa diaria y configuraci¢n de alias p£blico para mitigar la enumeraci¢n de usuarios v¡a REST API.
6. **Plugin Limit Login Attempts Reloaded:** Previene ataques automatizados de fuerza bruta mediante bloqueo temporal por IP tras superar el umbral de intentos fallidos.
