import 'package:flutter/material.dart';
import '../data/data_store.dart';
import '../theme/app_theme.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen>
    with SingleTickerProviderStateMixin {
  final store = DataStore();
  late TextEditingController _nombreCtrl;
  late TextEditingController _apellidoCtrl;
  late TextEditingController _emailCtrl;
  bool _editando = false;
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _nombreCtrl   = TextEditingController(text: store.nombreUsuario);
    _apellidoCtrl = TextEditingController(text: store.apellidoUsuario);
    _emailCtrl    = TextEditingController(text: store.emailUsuario);
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    store.nombreUsuario   = _nombreCtrl.text.trim();
    store.apellidoUsuario = _apellidoCtrl.text.trim();
    store.emailUsuario    = _emailCtrl.text.trim();
    setState(() => _editando = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
        const SizedBox(width: 10),
        Text('Perfil actualizado correctamente',
            style: AppTextStyles.body(color: Colors.white)),
      ]),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final iniciales =
        '${store.nombreUsuario.isNotEmpty ? store.nombreUsuario[0] : ''}${store.apellidoUsuario.isNotEmpty ? store.apellidoUsuario[0] : ''}'.toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AnimatedBuilder(
        animation: _anim,
        builder: (_, child) => Opacity(
          opacity: _anim.value,
          child: Transform.translate(offset: Offset(0, 14 * (1 - _anim.value)), child: child),
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
                    Expanded(child: Text('Mi Perfil', style: AppTextStyles.title())),
                    TextButton.icon(
                      onPressed: () => setState(() => _editando = !_editando),
                      icon: Icon(_editando ? Icons.close_rounded : Icons.edit_outlined,
                          size: 17, color: AppColors.primaryMid),
                      label: Text(_editando ? 'Cancelar' : 'Editar',
                          style: AppTextStyles.body(color: AppColors.primaryMid)),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                  child: Column(
                    children: [
                      // Avatar card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 20, offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 80, height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                              ),
                              child: Center(
                                child: Text(iniciales,
                                    style: AppTextStyles.heading(color: Colors.white)
                                        .copyWith(fontSize: 26)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text('${store.nombreUsuario} ${store.apellidoUsuario}',
                                style: AppTextStyles.title(color: Colors.white)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('Administrador',
                                  style: AppTextStyles.caption(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Información Personal', style: AppTextStyles.title()),
                      ),
                      const SizedBox(height: 12),

                      // Campos
                      _PerfilCampo(label: 'Nombre', controller: _nombreCtrl,
                          editando: _editando, icon: Icons.person_outline_rounded),
                      const SizedBox(height: 10),
                      _PerfilCampo(label: 'Apellido', controller: _apellidoCtrl,
                          editando: _editando, icon: Icons.badge_outlined),
                      const SizedBox(height: 10),
                      _PerfilCampo(label: 'Correo electrónico', controller: _emailCtrl,
                          editando: _editando, icon: Icons.alternate_email_rounded),

                      if (_editando) ...[
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: _guardar,
                            icon: const Icon(Icons.save_outlined, size: 18),
                            label: Text('Guardar Cambios', style: AppTextStyles.title(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ],
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

class _PerfilCampo extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool editando;
  final IconData icon;
  const _PerfilCampo({required this.label, required this.controller,
      required this.editando, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryMid, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption()),
                const SizedBox(height: 4),
                editando
                    ? TextField(
                        controller: controller,
                        style: AppTextStyles.body(color: AppColors.textDark),
                        cursorColor: AppColors.primaryMid,
                        decoration: const InputDecoration(
                          isDense: true, contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                      )
                    : Text(controller.text,
                        style: AppTextStyles.body(color: AppColors.textDark)
                            .copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          if (editando)
            const Icon(Icons.edit_outlined, color: AppColors.primaryLight, size: 15),
        ],
      ),
    );
  }
}
