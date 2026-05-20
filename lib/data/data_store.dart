import '../models/alumno.dart';
import '../models/pregunta_frecuente.dart';

class DataStore {
  // Singleton
  static final DataStore _instance = DataStore._internal();
  factory DataStore() => _instance;
  DataStore._internal();

  // ── Usuario logueado ──────────────────────────────────────
  String nombreUsuario = 'Administrador';
  String apellidoUsuario = 'Sistema';
  String emailUsuario = 'admin@escuela.com';

  // ── Alumnos en memoria ────────────────────────────────────
  int _nextId = 4;
  final List<Alumno> _alumnos = [
    Alumno(
      id: 1,
      nombre: 'Ana',
      apellido: 'García',
      fechaNacimiento: DateTime(2005, 3, 15),
    ),
    Alumno(
      id: 2,
      nombre: 'Carlos',
      apellido: 'López',
      fechaNacimiento: DateTime(2004, 7, 22),
    ),
    Alumno(
      id: 3,
      nombre: 'Sofía',
      apellido: 'Martínez',
      fechaNacimiento: DateTime(2006, 1, 8),
    ),
  ];

  List<Alumno> get alumnos => List.unmodifiable(_alumnos);

  void agregarAlumno(Alumno alumno) {
    _alumnos.add(alumno);
  }

  int get nextId => _nextId++;

  void eliminarAlumno(int id) {
    _alumnos.removeWhere((a) => a.id == id);
  }

  // ── Preguntas frecuentes ──────────────────────────────────
  final List<PreguntaFrecuente> preguntas = const [
    PreguntaFrecuente(
      id: 1,
      pregunta: '¿Cómo registro un nuevo alumno?',
      respuesta:
          'Ve al menú principal y selecciona "Registrar Alumno". Completa el formulario con el nombre, apellido y fecha de nacimiento del alumno y presiona "Guardar".',
    ),
    PreguntaFrecuente(
      id: 2,
      pregunta: '¿Cómo consulto la lista de alumnos?',
      respuesta:
          'Desde el menú principal selecciona "Listar Alumnos". Verás todos los alumnos registrados con su información básica.',
    ),
    PreguntaFrecuente(
      id: 3,
      pregunta: '¿Puedo eliminar un alumno?',
      respuesta:
          'Sí. En la pantalla de lista de alumnos, desliza el registro hacia la izquierda o presiona el ícono de eliminar para quitar al alumno del sistema.',
    ),
    PreguntaFrecuente(
      id: 4,
      pregunta: '¿Cómo cierro sesión?',
      respuesta:
          'En el menú principal encontrarás la opción "Cerrar Sesión" al final de la lista. Al presionarla regresarás a la pantalla de inicio de sesión.',
    ),
    PreguntaFrecuente(
      id: 5,
      pregunta: '¿Dónde veo mi perfil?',
      respuesta:
          'Selecciona "Perfil" en el menú principal para ver y editar tu información personal.',
    ),
  ];
}
