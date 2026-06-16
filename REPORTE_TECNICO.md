# Reporte Técnico: Sistema de Seguridad y Bloqueo por Inactividad

Este reporte detalla la implementación del nuevo flujo de seguridad en el proyecto **BloquePantalla**, enfocado en la protección selectiva de contenido y la gestión automática de sesiones por inactividad.

## 1. Arquitectura del Sistema de Seguridad

El sistema ahora opera bajo un modelo de **Seguridad Selectiva**, donde la protección contra capturas de pantalla solo se activa en áreas sensibles, permitiendo la interacción normal en el resto de la aplicación.

| Componente | Función | Estado de Captura |
| :--- | :--- | :--- |
| **LoginScreen** | Acceso inicial del usuario | **Permitido** |
| **HomeScreen** | Contenido privado/sensible | **Bloqueado** |
| **InactivityDetector** | Monitoreo de interacción global | N/A |

---

## 2. Implementación del Bloqueo por Inactividad

Se ha creado un componente de alto nivel llamado `InactivityDetector` que envuelve toda la aplicación.

### ¿Cómo funciona?
1. **Detección de Gestos**: Utiliza un widget `Listener` para capturar cualquier interacción táctil (`onPointerDown`, `onPointerMove`).
2. **Temporizador (Timer)**: Cada vez que el usuario toca la pantalla, el temporizador se reinicia.
3. **Cierre de Sesión**: Si el temporizador alcanza el límite establecido (actualmente **30 segundos**), se ejecuta un callback que redirige al usuario a la pantalla de login, eliminando todo el historial de navegación para evitar retrocesos accidentales.

---

## 3. Guía para Capturas de Pantalla (Documentación)

Si necesitas documentar este proceso o mostrar el código en una presentación, estas son las secciones clave que debes capturar:

### A. El Detector de Inactividad (`lib/inactivity_detector.dart`)
**Por qué capturarlo:** Muestra la lógica principal de cómo se reinicia el tiempo con cada toque del usuario.
> **Líneas clave:** 30-45 (donde se gestiona el `_timer` y `_handleUserInteraction`).

### B. Configuración Global (`lib/main.dart`)
**Por qué capturarlo:** Muestra cómo se integra el detector con la navegación de Flutter y el tiempo de espera configurado.
> **Líneas clave:** 18-23 (configuración del `timeout` y la acción `onTimeout`).

### C. Protección de la Pantalla Principal (`lib/home_screen.dart`)
**Por qué capturarlo:** Demuestra el uso del `SecureScreenMixin` para activar la protección de pantalla solo en esta vista.
> **Líneas clave:** 11 (la declaración de la clase con `with SecureScreenMixin`).

---

## 4. Detección de Fake GPS e Integridad del Dispositivo

Se ha añadido una capa de seguridad en el arranque de la aplicación (`IntegrityService`) que verifica:
1.  **Fake GPS**: Detecta si el usuario está usando aplicaciones de simulación de ubicación (Mock Location).
2.  **Root/Jailbreak**: Verifica si el sistema operativo ha sido vulnerado.
3.  **Emuladores**: Bloquea la ejecución en entornos virtuales (solo en modo release).

Si se detecta alguna de estas amenazas, la aplicación muestra una pantalla de bloqueo (`SecurityBlockScreen`) que impide cualquier interacción y solicita el cierre de la app.

## 5. Mejoras de Estabilidad (Fix Login)

Se ha corregido el error que causaba que la aplicación se cerrara al iniciar si no se encontraba el archivo `google-services.json`. Ahora la aplicación:
1.  Intenta inicializar Firebase de forma segura.
2.  Si falla (por falta de configuración), muestra un aviso en la consola de depuración pero **permite continuar con el login**.
3.  Los datos sensibles se inicializan correctamente en el almacenamiento seguro sin bloquear el hilo principal.

## 6. Conclusión y Recomendaciones

El sistema actual es una solución de seguridad integral que protege contra:
*   Capturas de pantalla no autorizadas.
*   Olvidos de bloqueo (Inactividad).
*   Manipulación remota de datos (Borrado por FCM).
*   Suplantación de identidad geográfica (Fake GPS).
*   Vulnerabilidades del sistema operativo (Root).

**Recomendación:** Para producción, se sugiere cambiar el `timeout` en `main.dart` a un valor entre 2 y 5 minutos (`Duration(minutes: 2)`).
