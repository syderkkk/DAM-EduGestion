class Alumno {
  final int id;
  String nombre;
  String apellido;
  DateTime fechaNacimiento;

  Alumno({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.fechaNacimiento,
  });

  String get nombreCompleto => '$nombre $apellido';

  String get iniciales =>
      '${nombre.isNotEmpty ? nombre[0].toUpperCase() : ''}${apellido.isNotEmpty ? apellido[0].toUpperCase() : ''}';
}
