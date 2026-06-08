# Guía de Configuración de Firebase para Borrado Remoto

Para que la función de borrado remoto funcione en tu celular, debes completar estos pasos en la consola de Firebase:

## 1. Crear el Proyecto en Firebase
1. Ve a [Firebase Console](https://console.firebase.google.com/).
2. Haz clic en "Agregar proyecto" y nómbralo (ej. `BloquePantalla`).
3. Desactiva Google Analytics si no lo necesitas.

## 2. Registrar la Aplicación Android
1. Haz clic en el icono de Android.
2. **IMPORTANTE**: En "Nombre del paquete de Android", ingresa exactamente: `com.roque.bloquepantalla`.
3. Descarga el archivo `google-services.json`.
4. Coloca ese archivo en la carpeta de tu proyecto: `android/app/google-services.json`.

## 3. Cómo enviar la notificación de borrado
Para borrar los datos de tu celular remotamente:
1. En la consola de Firebase, ve a **Messaging**.
2. Haz clic en "Crear tu primera campaña" -> "Mensajes de Firebase Notification".
3. En el paso "Destinatario", elige tu app.
4. **PASO CRUCIAL (Datos adicionales)**:
   - Ve a la sección **"Opciones avanzadas"** o **"Datos personalizados"**.
   - Agrega una clave llamada `action` con el valor `wipe_data`.
5. Envía la notificación.

## 4. Campos Sensibles Protegidos
La aplicación ahora guarda automáticamente estos 4 campos en un almacenamiento cifrado por hardware:
- `api_token`: Token de acceso simulado.
- `master_key`: Clave maestra de cifrado.
- `user_pin`: PIN de seguridad.
- `session_data`: Datos de sesión en formato JSON.

Al recibir la notificación con `wipe_data`, estos 4 campos se eliminarán permanentemente del dispositivo.
