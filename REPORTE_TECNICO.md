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

## 4. Conclusión y Recomendaciones

El método implementado garantiza que:
*   El usuario pueda compartir su pantalla de inicio de sesión si necesita ayuda técnica.
*   Los datos sensibles en la pantalla principal estén protegidos contra capturas no autorizadas.
*   La aplicación se auto-proteja si el usuario olvida bloquear su dispositivo o deja la aplicación abierta.

**Recomendación:** Para producción, se sugiere cambiar el `timeout` en `main.dart` a un valor entre 2 y 5 minutos (`Duration(minutes: 2)`).
