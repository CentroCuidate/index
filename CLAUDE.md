# Centro Cuídate — notas para trabajar en este repo

App de gestión de un centro de bienestar (un único `index.html`) y web pública de reservas (`booking.html`). Se publica sola con GitHub Pages al hacer push a `main`: **cada push va directo a producción**.

## Antes de cada commit a `main`
1. Ejecuta `tools/stamp-version.sh` (sella `APP_BUILD` en `index.html` y `version.json`; la app abierta lo usa para avisar de "nueva versión").
2. Comprueba la sintaxis de todos los bloques `<script>` en línea con `node --check`.
3. Idioma de la interfaz, comentarios y mensajes de commit: español.

## Cómo editar `index.html`
- Pesa más de 4 MB por las imágenes en base64 incrustadas. No lo leas entero: busca con grep y edita con sustituciones exactas (comprobando que el texto a sustituir aparece una sola vez).
- La interfaz se pinta concatenando HTML. Todo dato que venga de un cliente, de una reserva o de un archivo debe pasar por `esc()`. Los identificadores que se insertan en `onclick` deben validarse con `_safeKey()`.
- No pases texto libre dentro de atributos `onclick`.

## Datos y seguridad
- Backend: Firebase Realtime Database (proyecto `centrocuidatecoin`) y Firebase Auth. El registro de cuentas está cerrado en la consola.
- Las reglas se publican a mano en la consola; `database.rules.json` es la copia de referencia. Si cambias la estructura de datos de reservas, cambia código y reglas a la vez y da las reglas nuevas al usuario.
- `booking/{sede}/workshops` es de lectura pública: ahí **nunca** se guardan nombre, teléfono ni notas. Los datos personales de inscritas van en `booking/{sede}/attendeesPrivate`.
- Datos de salud (peso, altura, pesajes, fotos de progreso) están desactivados con `HEALTH_FIELDS_ENABLED=false`. No los reactives sin que lo pida el usuario.
- Nunca subas al repo exportaciones de la base de datos, claves ni el script de Google Calendar con su `SECRET_KEY`. El repo es público.
- Google Calendar se integra con un Apps Script propio que exige clave secreta; la app la guarda en la configuración privada de la usuaria.
- El generador de dietas llama a la API de Anthropic desde el navegador con la clave de la usuaria. No envíes nombre ni teléfono de clientes en el prompt.

## Pruebas
- No hay entorno de pruebas ni tests automáticos. Lo que no puedas verificar (todo lo que requiere sesión iniciada o la base de datos real), dilo claramente al usuario y pídele que lo pruebe.
- Se puede probar HTML/JS aislado en Chrome sin interfaz con la misma política CSP de la app.
