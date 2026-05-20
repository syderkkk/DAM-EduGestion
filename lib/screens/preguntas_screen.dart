import 'package:flutter/material.dart';
import '../data/data_store.dart';
import '../models/pregunta_frecuente.dart';
import '../theme/app_theme.dart';

class PreguntasScreen extends StatefulWidget {
  const PreguntasScreen({super.key});
  @override
  State<PreguntasScreen> createState() => _PreguntasScreenState();
}

class _PreguntasScreenState extends State<PreguntasScreen>
    with SingleTickerProviderStateMixin {
  final store   = DataStore();
  int? _abierto;
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
  void dispose() { _ctrl.dispose(); super.dispose(); }

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
                    Text('Preguntas Frecuentes', style: AppTextStyles.title()),
                  ],
                ),
              ),

              // Banner
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Container(
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
                        child: const Icon(Icons.help_outline_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Centro de Ayuda',
                              style: AppTextStyles.title(color: Colors.white)),
                          Text('${store.preguntas.length} respuestas disponibles',
                              style: AppTextStyles.caption(color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Lista accordion
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                  itemCount: store.preguntas.length,
                  itemBuilder: (ctx, i) => _AccordionCard(
                    pregunta: store.preguntas[i],
                    numero: i + 1,
                    isOpen: _abierto == i,
                    onTap: () =>
                        setState(() => _abierto = _abierto == i ? null : i),
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

// ── Accordion ─────────────────────────────────────────────────

class _AccordionCard extends StatefulWidget {
  final PreguntaFrecuente pregunta;
  final int numero;
  final bool isOpen;
  final VoidCallback onTap;
  const _AccordionCard({required this.pregunta, required this.numero,
      required this.isOpen, required this.onTap});
  @override
  State<_AccordionCard> createState() => _AccordionCardState();
}

class _AccordionCardState extends State<_AccordionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _expand;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 260));
    _expand = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    if (widget.isOpen) _ctrl.value = 1;
  }

  @override
  void didUpdateWidget(_AccordionCard old) {
    super.didUpdateWidget(old);
    if (widget.isOpen != old.isOpen) {
      widget.isOpen ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.isOpen
              ? AppColors.primaryLight.withOpacity(0.5)
              : AppColors.border,
          width: widget.isOpen ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(widget.isOpen ? 0.1 : 0.04),
            blurRadius: widget.isOpen ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            // Pregunta (header)
            InkWell(
              onTap: widget.onTap,
              splashColor: AppColors.primaryFaint,
              highlightColor: AppColors.primaryFaint.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Número badge
                    Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        color: widget.isOpen
                            ? AppColors.primaryMid
                            : AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text('${widget.numero}',
                            style: AppTextStyles.caption(
                              color: widget.isOpen
                                  ? Colors.white
                                  : AppColors.primaryMid,
                            ).copyWith(fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.pregunta.pregunta,
                        style: AppTextStyles.body(
                          color: widget.isOpen
                              ? AppColors.primary
                              : AppColors.textDark,
                        ).copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: widget.isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 260),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: widget.isOpen
                            ? AppColors.primaryMid
                            : AppColors.textLight,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Respuesta (expandible)
            SizeTransition(
              sizeFactor: _expand,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Línea lateral azul
                      Container(
                        width: 3,
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.pregunta.respuesta,
                          style: AppTextStyles.body(),
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
    );
  }
}
