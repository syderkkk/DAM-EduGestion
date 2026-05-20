import 'package:flutter/material.dart';
import '../data/data_store.dart';
import '../models/alumno.dart';
import '../theme/app_theme.dart';

class RegistrarAlumnoScreen extends StatefulWidget {
  const RegistrarAlumnoScreen({super.key});
  @override
  State<RegistrarAlumnoScreen> createState() => _RegistrarAlumnoScreenState();
}

class _RegistrarAlumnoScreenState extends State<RegistrarAlumnoScreen>
    with SingleTickerProviderStateMixin {
  final _formKey      = GlobalKey<FormState>();
  final _nombreCtrl   = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  DateTime? _fecha;
  bool _guardando = false;
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2006),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryMid,
            onPrimary: Colors.white,
            surface: AppColors.white,
            onSurface: AppColors.textDark,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _fecha = picked);
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fecha == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Selecciona la fecha de nacimiento',
            style: AppTextStyles.body(color: Colors.white)),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      return;
    }
    setState(() => _guardando = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    final store = DataStore();
    store.agregarAlumno(Alumno(
      id: store.nextId,
      nombre: _nombreCtrl.text.trim(),
      apellido: _apellidoCtrl.text.trim(),
      fechaNacimiento: _fecha!,
    ));
    setState(() => _guardando = false);
    if (!mounted) return;
    Navigator.pop(context);
  }

  String get _fechaTexto => _fecha == null
      ? 'Seleccionar fecha'
      : '${_fecha!.day.toString().padLeft(2, '0')} / '
        '${_fecha!.month.toString().padLeft(2, '0')} / '
        '${_fecha!.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AnimatedBuilder(
        animation: _anim,
        builder: (_, child) => Opacity(
          opacity: _anim.value,
          child: Transform.translate(
              offset: Offset(0, 14 * (1 - _anim.value)), child: child),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          color: AppColors.primary, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text('Registrar Alumno', style: AppTextStyles.title()),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Banner superior
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48, height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.person_add_alt_1_rounded,
                                    color: Colors.white, size: 26),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nuevo Estudiante',
                                      style: AppTextStyles.title(color: Colors.white)),
                                  Text('Completa los datos del alumno',
                                      style: AppTextStyles.caption(color: Colors.white70)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        Text('Datos Personales', style: AppTextStyles.title()),
                        const SizedBox(height: 14),

                        // Formulario en tarjeta
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: cardDecoration(),
                          child: Column(
                            children: [
                              _LightField(
                                controller: _nombreCtrl,
                                label: 'Nombre',
                                icon: Icons.person_outline_rounded,
                                validator: (v) => (v == null || v.trim().isEmpty)
                                    ? 'El nombre es requerido' : null,
                              ),
                              const SizedBox(height: 16),
                              _LightField(
                                controller: _apellidoCtrl,
                                label: 'Apellido',
                                icon: Icons.badge_outlined,
                                validator: (v) => (v == null || v.trim().isEmpty)
                                    ? 'El apellido es requerido' : null,
                              ),
                              const SizedBox(height: 16),

                              // Fecha
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Fecha de Nacimiento',
                                      style: AppTextStyles.caption()),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: _pickDate,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 16),
                                      decoration: BoxDecoration(
                                        color: _fecha != null
                                            ? AppColors.primaryFaint
                                            : AppColors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: _fecha != null
                                              ? AppColors.primaryLight
                                              : AppColors.border,
                                          width: _fecha != null ? 1.5 : 1,
                                        ),
                                      ),
                                      child: Row(children: [
                                        Icon(Icons.calendar_today_outlined,
                                            color: _fecha != null
                                                ? AppColors.primaryMid
                                                : AppColors.textLight,
                                            size: 18),
                                        const SizedBox(width: 10),
                                        Text(_fechaTexto,
                                            style: AppTextStyles.body(
                                              color: _fecha != null
                                                  ? AppColors.textDark
                                                  : AppColors.textLight,
                                            )),
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _guardando ? null : _guardar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  AppColors.primary.withOpacity(0.5),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _guardando
                                ? const SizedBox(
                                    width: 22, height: 22,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2.5))
                                : Text('Guardar Alumno',
                                    style: AppTextStyles.title(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LightField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  const _LightField({required this.controller, required this.label,
      required this.icon, this.validator});
  @override
  State<_LightField> createState() => _LightFieldState();
}

class _LightFieldState extends State<_LightField> {
  final _focus = FocusNode();
  bool _focused = false;
  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }
  @override
  void dispose() { _focus.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focus,
      style: AppTextStyles.body(color: AppColors.textDark),
      cursorColor: AppColors.primaryMid,
      textCapitalization: TextCapitalization.words,
      validator: widget.validator,
      decoration: appInputDecoration(
          label: widget.label, icon: widget.icon, focused: _focused),
    );
  }
}
