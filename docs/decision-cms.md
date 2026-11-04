# Sesi¢n 9: Licencias, requisitos y elecci¢n de imagen

## 1. Requisitos oficiales de WordPress
Consultados en la documentaci¢n oficial de WordPress:
* **Versi¢n m°nima recomendada de PHP:** PHP 8.3 o superior.
* **Versi¢n de Base de Datos recomendada:** MariaDB 10.11 o superior, o MySQL 8.0 o superior.
* **Compatibilidad con HTTPS:** Requerida oficialmente para garantizar comunicaciones seguras y cifrado en tr†nsito, aunque permite operar en HTTP en pruebas locales.

## 2. An†lisis de etiquetas en Docker Hub
* **Diferencia entre `-apache` y `-fpm`:**
  * Las variantes con etiqueta `-apache` incluyen el servidor web Apache junto con el m¢dulo de PHP integrados en el mismo contenedor.
  * Las variantes con etiqueta `-fpm` contienen £nicamente el gestor de procesos FastCGI (PHP-FPM); no integran servidor web y requieren un servicio frontal (como Nginx o Apache) para servir tr†fico est†tico y delegar peticiones PHP. Presentan menor tama§o y una superficie de vulnerabilidades m†s reducida.
* **Significado de `php8.3`:** Indica que la imagen tiene instalada la rama 8.3 del intÇrprete de PHP, satisfaciendo el est†ndar recomendado oficial de WordPress.
* **Por quÇ no conviene usar `latest`:** No garantiza inmutabilidad ni entornos reproducibles. Una actualizaci¢n autom†tica mayor de WordPress o PHP puede provocar incompatibilidades imprevistas o ca°das de servicio.

## 3. Elecci¢n y comprobaci¢n de la imagen
* **Imagen seleccionada:** `wordpress:7.1-fpm` (variante FPM con PHP 8.3).
* **Comprobaci¢n de PHP (`php -v`):**
  * Confirma la ejecuci¢n de PHP 8.3.x en el contenedor.
* **Comprobaci¢n de m¢dulos (`php -m`):**
  * `mysqli`: Controlador nativo para la conexi¢n con el motor MariaDB/MySQL.
  * `gd` e `imagick`: Extensiones necesarias para el procesamiento, escalado y recorte din†mico de contenido multimedia.
  * `zip`: Necesario para la extracci¢n e instalaci¢n de temas y plugins desde el panel de administraci¢n.
  * `intl`: Soporte para internacionalizaci¢n y localizaci¢n multilingÅe.
* **Registro local de la imagen (`docker image ls`):**
  * Verificada la presencia local de la imagen `wordpress:7.1-fpm`.
