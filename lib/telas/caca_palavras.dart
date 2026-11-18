import 'package:flutter/material.dart';

import '../estado_jogo.dart';
import '../widgets/comuns.dart';
import 'resultado.dart';

class TelaCacaPalavras extends StatefulWidget {
  const TelaCacaPalavras({super.key});

  @override
  State<TelaCacaPalavras> createState() => _TelaCacaPalavrasState();
}

typedef _Cel = (int, int);

class _Achada {
  _Achada(this.inicio, this.fim, this.cor);
  final _Cel inicio, fim;
  final Color cor;
}

class _TelaCacaPalavrasState extends State<TelaCacaPalavras> {
  // ORIGENS e VALORES nas linhas, LAÇOS e FILHO nas colunas,
  // LAR na coluna 3 e MÃE na diagonal subindo.
  static const _grade = [
    'SOETUFL',
    'VÃNLBIA',
    'MUTACLÇ',
    'PISREHO',
    'GUTDNOS',
    'ORIGENS',
    'VALORES',
  ];
  static const _palavras = ['ORIGENS', 'VALORES', 'LAÇOS', 'FILHO', 'MÃE', 'LAR'];
  static const _coresFaixa = [
    Color(0xFFE040FB),
    Color(0xFFFF4081),
    Color(0xFF40C4FF),
    Color(0xFFFFAB00),
    Color(0xFF7C4DFF),
    Color(0xFF69F0AE),
  ];

  static int get _n => _grade.length;

  final _relogio = Stopwatch()..start();
  final _vidaAntes = EstadoJogo.i.vida;
  final Map<String, _Achada> _achadas = {};
  _Cel? _inicio, _fim;
  int _falhas = 0;

  String _letra(_Cel c) => _grade[c.$1][c.$2];

  _Cel _celEm(Offset p, double lado) {
    final t = lado / _n;
    return ((p.dy / t).floor().clamp(0, _n - 1), (p.dx / t).floor().clamp(0, _n - 1));
  }

  /// Células entre início e fim, se estiverem em linha (horizontal, vertical ou diagonal).
  List<_Cel>? _linha(_Cel a, _Cel b) {
    final dr = b.$1 - a.$1, dc = b.$2 - a.$2;
    if (!(dr == 0 || dc == 0 || dr.abs() == dc.abs())) return null;
    final passos = dr.abs() > dc.abs() ? dr.abs() : dc.abs();
    final sr = dr.sign, sc = dc.sign;
    return [for (var k = 0; k <= passos; k++) (a.$1 + sr * k, a.$2 + sc * k)];
  }

  void _arrastar(Offset p, double lado) {
    final c = _celEm(p, lado);
    if (_inicio != null && _linha(_inicio!, c) != null) setState(() => _fim = c);
  }

  Future<void> _soltar() async {
    final a = _inicio, b = _fim;
    setState(() => _inicio = _fim = null);
    if (a == null || b == null || a == b) return;
    final cels = _linha(a, b)!;
    final texto = cels.map(_letra).join();
    final inverso = texto.split('').reversed.join();
    final palavra = _palavras.where((w) => w == texto || w == inverso).firstOrNull;

    if (palavra != null && !_achadas.containsKey(palavra)) {
      setState(() => _achadas[palavra] =
          _Achada(a, b, _coresFaixa[_achadas.length % _coresFaixa.length]));
      if (_achadas.length == _palavras.length) {
        _relogio.stop();
        await Future<void>.delayed(const Duration(milliseconds: 700));
        if (!mounted) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => TelaResultado(
            icone: Icons.auto_stories,
            vidaAntes: _vidaAntes,
            falhas: _falhas,
            tempo: _relogio.elapsed,
          ),
        ));
      }
    } else if (palavra == null) {
      setState(() => _falhas++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Moldura(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          children: [
            const CabecalhoMinijogo(titulo: 'Desvende as escrituras'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Explicacao(
                  texto: 'Arraste sobre as letras para encontrar as palavras da '
                      'família. Cada tentativa errada custa 1 ponto de vida.'),
            ),
            VidaPerdida(vida: _vidaAntes, falhas: _falhas),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(builder: (context, c) {
                final lado = c.maxWidth < c.maxHeight ? c.maxWidth : c.maxHeight;
                return Center(
                  child: SizedBox.square(
                    dimension: lado,
                    child: GestureDetector(
                      onPanStart: (d) => setState(() {
                        _inicio = _fim = _celEm(d.localPosition, lado);
                      }),
                      onPanUpdate: (d) => _arrastar(d.localPosition, lado),
                      onPanEnd: (_) => _soltar(),
                      onPanCancel: () => setState(() => _inicio = _fim = null),
                      child: CustomPaint(
                        painter: _GradePainter(
                          grade: _grade,
                          achadas: _achadas.values.toList(),
                          selecao: _inicio == null ? null : (_inicio!, _fim!),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('tentativas falhas: $_falhas',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            _CartaoPalavras(palavras: _palavras, achadas: _achadas.keys.toSet()),
          ],
        ),
      ),
    );
  }
}

class _CartaoPalavras extends StatelessWidget {
  const _CartaoPalavras({required this.palavras, required this.achadas});
  final List<String> palavras;
  final Set<String> achadas;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE8486A)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFFE8486A),
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: const Text('FAMÍLIA',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 18,
              runSpacing: 6,
              children: [
                for (final p in palavras)
                  Text(
                    p,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: achadas.contains(p) ? Colors.black38 : Colors.black87,
                      decoration: achadas.contains(p) ? TextDecoration.lineThrough : null,
                      decorationThickness: 2,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradePainter extends CustomPainter {
  _GradePainter({required this.grade, required this.achadas, required this.selecao});

  final List<String> grade;
  final List<_Achada> achadas;
  final (_Cel, _Cel)? selecao;

  @override
  void paint(Canvas canvas, Size size) {
    final n = grade.length;
    final t = size.width / n;
    Offset centro(_Cel c) => Offset((c.$2 + 0.5) * t, (c.$1 + 0.5) * t);

    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFF3EEF8));
    canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.black26);

    void faixa(_Cel a, _Cel b, Color cor) => canvas.drawLine(
          centro(a),
          centro(b),
          Paint()
            ..color = cor
            ..strokeWidth = t * 0.78
            ..strokeCap = StrokeCap.round,
        );

    for (final a in achadas) {
      faixa(a.inicio, a.fim, a.cor.withValues(alpha: 0.75));
    }
    if (selecao != null) {
      faixa(selecao!.$1, selecao!.$2, Colors.grey.withValues(alpha: 0.45));
    }

    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        final tp = TextPainter(
          text: TextSpan(
            text: grade[r][c],
            style: TextStyle(
                fontSize: t * 0.48, fontWeight: FontWeight.w800, color: Colors.black87),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, centro((r, c)) - Offset(tp.width / 2, tp.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GradePainter old) => true;
}
