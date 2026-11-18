import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/comuns.dart';
import 'caca_palavras.dart';
import 'jogo_memoria.dart';

class PaginaArmadilhas extends StatefulWidget {
  const PaginaArmadilhas({super.key});

  @override
  State<PaginaArmadilhas> createState() => _PaginaArmadilhasState();
}

class _PaginaArmadilhasState extends State<PaginaArmadilhas>
    with SingleTickerProviderStateMixin {
  late final AnimationController _giro =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2800));
  final _aleatorio = Random();
  double _anguloInicial = 0, _anguloFinal = 0;
  bool? _caiuNaDireita; // direita = "Encontre a saída", esquerda = "Desvendar as escrituras"

  double get _angulo =>
      _anguloInicial +
      (_anguloFinal - _anguloInicial) * Curves.easeOutCubic.transform(_giro.value);

  @override
  void dispose() {
    _giro.dispose();
    super.dispose();
  }

  Future<void> _girar() async {
    if (_giro.isAnimating) return;
    final atual = _angulo % (2 * pi);
    // Evita parar exatamente sobre a divisória.
    final destino = 0.15 + _aleatorio.nextDouble() * (2 * pi - 0.3);
    final ajuste = (destino - atual) % (2 * pi);
    setState(() {
      _caiuNaDireita = null;
      _anguloInicial = atual;
      _anguloFinal = atual + 4 * 2 * pi + ajuste;
    });
    await _giro.forward(from: 0);
    final final_ = _anguloFinal % (2 * pi);
    setState(() => _caiuNaDireita = final_ > 0 && final_ < pi);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) =>
          _caiuNaDireita! ? const TelaJogoMemoria() : const TelaCacaPalavras(),
    ));
    if (mounted) setState(() => _caiuNaDireita = null);
  }

  Widget _opcao(IconData icone, String texto, bool destaque) => AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: _caiuNaDireita == null || destaque ? 1 : 0.25,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 46),
            const SizedBox(height: 6),
            Text(texto,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 24),
      child: Column(
        children: [
          const Text(
            'Gire a roleta para sortear a próxima provação.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 18),
          AspectRatio(
            aspectRatio: 1,
            child: LayoutBuilder(builder: (context, c) {
              final d = c.maxWidth;
              return Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: _RoletaPainter())),
                  Positioned(
                    left: d * 0.06,
                    width: d * 0.38,
                    top: d * 0.34,
                    child: _opcao(Icons.auto_stories, 'Desvendar as escrituras',
                        _caiuNaDireita == false),
                  ),
                  Positioned(
                    right: d * 0.06,
                    width: d * 0.38,
                    top: d * 0.34,
                    child: _opcao(Icons.door_front_door_outlined, 'Encontre a saída',
                        _caiuNaDireita == true),
                  ),
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _giro,
                      builder: (_, _) => Transform.rotate(
                        angle: _angulo,
                        child: CustomPaint(painter: _PonteiroPainter()),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 22),
          BotaoCinza(
            texto: _giro.isAnimating ? 'Girando…' : 'Girar roleta',
            onPressed: _giro.isAnimating ? null : _girar,
          ),
        ],
      ),
    );
  }
}

class _RoletaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 2;
    final traco = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = Colors.black87;
    canvas.drawCircle(c, r, Paint()..color = Colors.white);
    canvas.drawCircle(c, r, traco);
    canvas.drawLine(c.translate(0, -r), c.translate(0, r), traco);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PonteiroPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    final ponta = Path()
      ..moveTo(c.dx, c.dy - r * 0.86)
      ..lineTo(c.dx + r * 0.07, c.dy)
      ..lineTo(c.dx, c.dy + r * 0.25)
      ..lineTo(c.dx - r * 0.07, c.dy)
      ..close();
    canvas.drawPath(ponta, Paint()..color = Cores.vermelho);
    canvas.drawPath(
        ponta,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = Colors.black87);
    canvas.drawCircle(c, r * 0.1, Paint()..color = Colors.white);
    canvas.drawCircle(
        c,
        r * 0.1,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = Colors.black87);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
