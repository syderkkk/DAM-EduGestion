import 'package:flutter/material.dart';
import '../data/data_store.dart';
import '../models/alumno.dart';
import '../theme/app_theme.dart';

class ListarAlumnosScreen extends StatefulWidget {
  const ListarAlumnosScreen({super.key});
  @override
  State<ListarAlumnosScreen> createState() => _ListarAlumnosScreenState();
}

class _ListarAlumnosScreenState extends State<ListarAlumnosScreen>
    with SingleTickerProviderStateMixin {
  final store       = DataStore();
  final _searchCtrl = TextEditingController();
  String _query     = '';
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
  void dispose() { _ctrl.dispose(); _searchCtrl.dispose(); super.dispose(); }

  List<Alumno> get _filtrados {
    final q = _query.toLowerCase();
    if (q.isEmpty) return store.alumnos.toList();
    return store.alumnos
        .where((a) => a.nombre.toLowerCase().contains(q) ||
                      a.apellido.toLowerCase().contains(q))
        .toList();
  }

  void _eliminar(Alumno a) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Eliminar Alumno', style: AppTextStyles.heading()),
        content: Text('¿Eliminar a "${a.nombreCompleto}"?\nEsta acción no se puede deshacer.',
            style: AppTextStyles.body()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: AppTextStyles.body(color: AppColors.textMid)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              store.eliminarAlumno(a.id);
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = _filtrados;
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
                    Expanded(child: Text('Lista de Alumnos', style: AppTextStyles.title())),
                    // Botón agregar
                    ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/registrar');
                        setState(() {});
                      },
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: const Text('Agregar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        textStyle: AppTextStyles.caption(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              // Buscador
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: TextField(
                  controller: _searchCtrl,
                  style: AppTextStyles.body(color: AppColors.textDark),
                  cursorColor: AppColors.primaryMid,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o apellido...',
                    hintStyle: AppTextStyles.body(color: AppColors.textLight),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppColors.textLight, size: 20),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded,
                                color: AppColors.textLight, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            })
                        : null,
                    filled: true,
                    fillColor: AppColors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: AppColors.primaryMid, width: 1.5),
                    ),
                  ),
                ),
              ),

              // Contador
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(children: [
                  Text(
                    '${lista.length} alumno${lista.length != 1 ? 's' : ''}',
                    style: AppTextStyles.caption(),
                  ),
                ]),
              ),

              // Lista
              Expanded(
                child: lista.isEmpty
                    ? _EmptyState(
                        query: _query,
                        onAgregar: () async {
                          await Navigator.pushNamed(context, '/registrar');
                          setState(() {});
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                        itemCount: lista.length,
                        itemBuilder: (ctx, i) => _AlumnoCard(
                          alumno: lista[i],
                          index: i,
                          onDelete: () => _eliminar(lista[i]),
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

// ── Subwidgets ────────────────────────────────────────────────

class _AlumnoCard extends StatefulWidget {
  final Alumno alumno;
  final int index;
  final VoidCallback onDelete;
  const _AlumnoCard({required this.alumno, required this.index, required this.onDelete});
  @override
  State<_AlumnoCard> createState() => _AlumnoCardState();
}

class _AlumnoCardState extends State<_AlumnoCard> {
  bool _pressed = false;

  // Azules en distintos tonos
  static const _colors = [
    Color(0xFF1E3A8A),
    Color(0xFF2563EB),
    Color(0xFF0891B2),
    Color(0xFF0284C7),
    Color(0xFF4F46E5),
  ];

  String get _fecha =>
      '${widget.alumno.fechaNacimiento.day.toString().padLeft(2, '0')} / '
      '${widget.alumno.fechaNacimiento.month.toString().padLeft(2, '0')} / '
      '${widget.alumno.fechaNacimiento.year}';

  @override
  Widget build(BuildContext context) {
    final color = _colors[widget.index % _colors.length];
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _pressed ? AppColors.surfaceAlt : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: _pressed ? AppColors.primaryLight.withOpacity(0.3) : AppColors.border),
          boxShadow: _pressed
              ? []
              : [BoxShadow(
                  color: AppColors.primary.withOpacity(0.05),
                  blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            // Avatar inicial
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(widget.alumno.iniciales,
                    style: AppTextStyles.title(color: color)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.alumno.nombreCompleto,
                      style: AppTextStyles.body(color: AppColors.textDark)
                          .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.cake_outlined,
                        color: AppColors.textLight, size: 13),
                    const SizedBox(width: 4),
                    Text(_fecha, style: AppTextStyles.caption()),
                  ]),
                ],
              ),
            ),
            Text('#${widget.index + 1}',
                style: AppTextStyles.caption(
                    color: AppColors.textLight.withOpacity(0.5))),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.error, size: 20),
              onPressed: widget.onDelete,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.error.withOpacity(0.08),
                minimumSize: const Size(34, 34),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  final VoidCallback onAgregar;
  const _EmptyState({required this.query, required this.onAgregar});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: AppColors.primaryFaint,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people_outline_rounded,
                color: AppColors.primaryMid, size: 34),
          ),
          const SizedBox(height: 16),
          Text(
            query.isNotEmpty ? 'Sin resultados' : 'Sin alumnos registrados',
            style: AppTextStyles.title(),
          ),
          const SizedBox(height: 6),
          Text(
            query.isNotEmpty
                ? 'No hay coincidencias para "$query"'
                : 'Agrega el primer estudiante al sistema',
            style: AppTextStyles.body(),
            textAlign: TextAlign.center,
          ),
          if (query.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAgregar,
              icon: const Icon(Icons.person_add_alt_1_outlined, size: 18),
              label: const Text('Registrar Alumno'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
