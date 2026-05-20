import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey  = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure   = true;
  bool _loading   = false;

  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset>  _slide;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); _userCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _loading = false);
    if (_userCtrl.text.trim() == 'admin' && _passCtrl.text == '1234') {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Text('Usuario o contraseña incorrectos',
              style: AppTextStyles.body(color: Colors.white)),
        ]),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Ola decorativa superior
          Positioned(
            top: -size.height * 0.05,
            left: -50,
            right: -50,
            child: Container(
              height: size.height * 0.42,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft:  Radius.elliptical(200, 80),
                  bottomRight: Radius.elliptical(200, 80),
                ),
              ),
            ),
          ),

          // Puntos decorativos
          Positioned(
            top: 60, right: 40,
            child: _Dot(size: 8, opacity: 0.3),
          ),
          Positioned(
            top: 110, right: 80,
            child: _Dot(size: 5, opacity: 0.2),
          ),
          Positioned(
            top: 80, left: 30,
            child: _Dot(size: 6, opacity: 0.2),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.06),

                        // Ícono app
                        Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.25),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.school_rounded,
                              color: AppColors.primary, size: 36),
                        ),
                        const SizedBox(height: 16),
                        Text('EduGestión',
                            style: AppTextStyles.heading(color: Colors.white)),
                        const SizedBox(height: 6),
                        Text('Sistema de Gestión Escolar',
                            style: AppTextStyles.caption(color: Colors.white70)),

                        SizedBox(height: size.height * 0.06),

                        // Tarjeta formulario
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: cardDecoration(),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Iniciar sesión',
                                    style: AppTextStyles.heading()),
                                const SizedBox(height: 4),
                                Text('Ingresa tus datos para continuar',
                                    style: AppTextStyles.body()),
                                const SizedBox(height: 24),

                                // Usuario
                                _FocusableField(
                                  controller: _userCtrl,
                                  label: 'Usuario',
                                  icon: Icons.person_outline_rounded,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Ingresa tu usuario' : null,
                                ),
                                const SizedBox(height: 16),

                                // Contraseña
                                _FocusableField(
                                  controller: _passCtrl,
                                  label: 'Contraseña',
                                  icon: Icons.lock_outline_rounded,
                                  obscure: _obscure,
                                  onToggle: () => setState(() => _obscure = !_obscure),
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Ingresa tu contraseña' : null,
                                  onSubmit: (_) => _login(),
                                ),
                                const SizedBox(height: 28),

                                // Botón
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: _loading ? null : _login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor:
                                          AppColors.primary.withOpacity(0.5),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: _loading
                                        ? const SizedBox(
                                            width: 22, height: 22,
                                            child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5))
                                        : Text('Ingresar',
                                            style: AppTextStyles.title(
                                                color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFaint,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppColors.primaryLight.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.info_outline_rounded,
                                  color: AppColors.primaryMid, size: 15),
                              const SizedBox(width: 8),
                              Text('Usuario: admin  ·  Contraseña: 1234',
                                  style: AppTextStyles.caption(
                                      color: AppColors.primaryMid)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────

class _Dot extends StatelessWidget {
  final double size, opacity;
  const _Dot({required this.size, required this.opacity});
  @override
  Widget build(BuildContext context) => Opacity(
    opacity: opacity,
    child: Container(
      width: size, height: size,
      decoration: const BoxDecoration(
          color: Colors.white, shape: BoxShape.circle),
    ),
  );
}

class _FocusableField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final VoidCallback? onToggle;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmit;

  const _FocusableField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.onToggle,
    this.validator,
    this.onSubmit,
  });

  @override
  State<_FocusableField> createState() => _FocusableFieldState();
}

class _FocusableFieldState extends State<_FocusableField> {
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
      obscureText: widget.obscure,
      style: AppTextStyles.body(color: AppColors.textDark),
      cursorColor: AppColors.primaryMid,
      onFieldSubmitted: widget.onSubmit,
      validator: widget.validator,
      decoration: appInputDecoration(
        label: widget.label,
        icon: widget.icon,
        focused: _focused,
        suffix: widget.onToggle != null
            ? IconButton(
                icon: Icon(
                  widget.obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textLight,
                  size: 20,
                ),
                onPressed: widget.onToggle,
              )
            : null,
      ),
    );
  }
}
