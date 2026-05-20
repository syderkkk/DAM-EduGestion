import 'package:flutter/material.dart';
import '../data/data_store.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final store = DataStore();
  late final AnimationController _ctrl;
  late final List<Animation<double>> _anims;

  static const _menuItems = [
    _Item('/perfil',    Icons.account_circle_outlined,      'Mi Perfil',              'Ver y editar tu información'),
    _Item('/registrar', Icons.person_add_alt_1_outlined,    'Registrar Alumno',       'Agregar nuevo estudiante'),
    _Item('/listar',    Icons.format_list_bulleted_outlined, 'Lista de Alumnos',       'Ver todos los registros'),
    _Item('/preguntas', Icons.help_outline_rounded,          'Preguntas Frecuentes',   'Centro de ayuda'),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _anims = List.generate(
      _menuItems.length + 2,
      (i) => CurvedAnimation(
        parent: _ctrl,
        curve: Interval(
          (i * 0.1).clamp(0.0, 1.0),
          ((i * 0.1) + 0.5).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic,
        ),
      ),
    );
    Future.delayed(const Duration(milliseconds: 50), () => _ctrl.forward());
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header azul ──────────────────────────────
            SliverToBoxAdapter(
              child: _FadeUp(
                anim: _anims[0],
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  padding: const EdgeInsets.all(22),
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
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bienvenido,',
                                style: AppTextStyles.caption(
                                    color: Colors.white70)),
                            const SizedBox(height: 2),
                            Text(store.nombreUsuario,
                                style: AppTextStyles.heading(
                                    color: Colors.white)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('Administrador',
                                  style: AppTextStyles.caption(
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                      // Avatar
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/perfil')
                            .then((_) => setState(() {})),
                        child: Container(
                          width: 54, height: 54,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 2),
                          ),
                          child: Center(
                            child: Text(
                              '${store.nombreUsuario[0]}${store.apellidoUsuario[0]}'
                                  .toUpperCase(),
                              style: AppTextStyles.title(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Stats ─────────────────────────────────────
            SliverToBoxAdapter(
              child: _FadeUp(
                anim: _anims[1],
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      _StatCard(
                        value: '${store.alumnos.length}',
                        label: 'Alumnos',
                        icon: Icons.people_alt_outlined,
                        color: AppColors.primaryMid,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        value: '${store.preguntas.length}',
                        label: 'Preguntas',
                        icon: Icons.quiz_outlined,
                        color: const Color(0xFF0891B2),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Sección título ────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text('Accesos Rápidos',
                    style: AppTextStyles.title()),
              ),
            ),

            // ── Menú ──────────────────────────────────────
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: _FadeUp(
                    anim: _anims[i + 2],
                    child: _MenuCard(
                      item: _menuItems[i],
                      onTap: () => Navigator.pushNamed(
                              context, _menuItems[i].route)
                          .then((_) => setState(() {})),
                    ),
                  ),
                ),
                childCount: _menuItems.length,
              ),
            ),

            // ── Cerrar sesión ──────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: OutlinedButton.icon(
                  onPressed: () => _confirmLogout(context),
                  icon: const Icon(Icons.logout_rounded,
                      color: AppColors.error, size: 18),
                  label: Text('Cerrar Sesión',
                      style: AppTextStyles.body(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                        color: AppColors.error.withOpacity(0.4)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text('Cerrar Sesión', style: AppTextStyles.heading()),
        content: Text('¿Deseas cerrar la sesión actual?',
            style: AppTextStyles.body()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
                style: AppTextStyles.body(color: AppColors.textMid)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }
}

// ── Subwidgets ────────────────────────────────────────────────

class _FadeUp extends StatelessWidget {
  final Animation<double> anim;
  final Widget child;
  const _FadeUp({required this.anim, required this.child});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: anim,
    builder: (_, __) => Opacity(
      opacity: anim.value.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, 18 * (1 - anim.value)),
        child: child,
      ),
    ),
  );
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _StatCard({required this.value, required this.label,
      required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: AppTextStyles.heading(color: color)
                      .copyWith(fontSize: 26)),
              Text(label, style: AppTextStyles.caption()),
            ],
          ),
        ],
      ),
    ),
  );
}

class _Item {
  final String route, label, sub;
  final IconData icon;
  const _Item(this.route, this.icon, this.label, this.sub);
}

class _MenuCard extends StatefulWidget {
  final _Item item;
  final VoidCallback onTap;
  const _MenuCard({required this.item, required this.onTap});
  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: _pressed ? AppColors.primaryFaint : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _pressed
                ? AppColors.primaryLight.withOpacity(0.4)
                : AppColors.border,
          ),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryFaint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.item.icon,
                  color: AppColors.primaryMid, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item.label,
                      style: AppTextStyles.title()),
                  const SizedBox(height: 2),
                  Text(widget.item.sub,
                      style: AppTextStyles.caption()),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: _pressed
                    ? AppColors.primaryMid
                    : AppColors.textLight,
                size: 14),
          ],
        ),
      ),
    );
  }
}
