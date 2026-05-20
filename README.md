# EduGestión — Sistema de Gestión Escolar

Aplicación móvil desarrollada en **Flutter** para la gestión de alumnos en un entorno escolar.

---

## 📱 Pantallas

| Pantalla | Descripción |
|---|---|
| **Login** | Inicio de sesión con validación de credenciales |
| **Home** | Panel principal con acceso rápido a todas las funciones |
| **Perfil** | Ver y editar información del usuario administrador |
| **Registrar Alumno** | Formulario para agregar nuevos estudiantes |
| **Listar Alumnos** | Directorio con búsqueda y opción de eliminar |
| **Preguntas Frecuentes** | Centro de ayuda con acordeón expandible |

---

## 🚀 Cómo ejecutar

### Requisitos
- Flutter SDK `^3.11.4`
- Dart SDK compatible
- Android emulator, dispositivo físico o Windows desktop

### Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/syderkkk/DAM-EduGestion
cd DAM-EduGestion

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar la app
flutter run
```

### Credenciales de prueba
```
Usuario:    admin
Contraseña: 1234
```

---

## 🗂️ Estructura del proyecto

```
lib/
├── main.dart                        # Punto de entrada y rutas
├── theme/
│   └── app_theme.dart               # Sistema de diseño (colores, tipografía)
├── data/
│   └── data_store.dart              # Almacenamiento en memoria (Singleton)
├── models/
│   ├── alumno.dart                  # Modelo de alumno
│   └── pregunta_frecuente.dart      # Modelo de FAQ
└── screens/
    ├── login_screen.dart
    ├── home_screen.dart
    ├── perfil_screen.dart
    ├── registrar_alumno_screen.dart
    ├── listar_alumnos_screen.dart
    └── preguntas_screen.dart
```

---

## 🎨 Diseño

- **Paleta**: Azul marino `#1E3A8A` · Azul vivo `#2563EB` · Blanco `#FFFFFF`
- **Fondo**: Blanco con tono azul muy suave `#F0F5FF`
- **Tarjetas**: Blancas con borde gris claro y sombra azul suave
- **Transiciones**: Estilo iOS en todas las plataformas

---

## 💾 Datos en memoria

La aplicación **no utiliza base de datos**. Toda la información se almacena en un `Singleton` (`DataStore`) que persiste durante la sesión:

- **Alumnos**: lista con 3 registros de ejemplo precargados
- **Preguntas frecuentes**: 5 preguntas predefinidas
- **Usuario**: datos editables desde la pantalla de Perfil

> Los datos se reinician al cerrar la aplicación.

---

## 🛠️ Tecnologías

- [Flutter](https://flutter.dev/) — Framework UI multiplataforma
- [Dart](https://dart.dev/) — Lenguaje de programación
- Material Design 3 — Sistema de componentes UI

---

## 📄 Licencia

Proyecto educativo — uso libre.
