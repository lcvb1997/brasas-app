import 'package:flutter/material.dart';

import '../estado_jogo.dart';
import '../widgets/comuns.dart';
import 'resultado.dart';

class TelaJogoMemoria extends StatefulWidget {
  const TelaJogoMemoria({super.key});

  @override
  State<TelaJogoMemoria> createState() => _TelaJogoMemoriaState();
}

class _Carta {
  _Carta(this.icone);
  final IconData icone;
  bool virada = false;
  bool achada = false;
}

class _TelaJogoMemoriaState extends State<TelaJogoMemoria> {
  static const _icones = [
    Icons.local_fire_department,
    Icons.key,
    Icons.door_front_door,
    Icons.explore,
    Icons.shield,
    Icons.visibility,
  ];

  final _relogio = Stopwatch()..start();
  final _vidaAntes = EstadoJogo.i.vida;
  late final List<_Carta> _cartas =
      ([..._icones, ..._icones]..shuffle()).map(_Carta.new).toList();
  final List<_Carta> _abertas = [];
  int _falhas = 0;
  bool _travado = false;

  Future<void> _tocar(_Carta c) async {
    if (_travado || c.virada || c.achada) return;
    setState(() {
      c.virada = true;
      _abertas.add(c);
    });
    if (_abertas.length < 2) return;

    _travado = true;
    final a = _abertas[0], b = _abertas[1];
    if (a.icone == b.icone) {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      setState(() => a.achada = b.achada = true);
    } else {
      setState(() => _falhas++);
      await Future<void>.delayed(const Duration(milliseconds: 850));
      setState(() => a.virada = b.virada = false);
    }
    _abertas.clear();
    _travado = false;

    if (_cartas.every((c) => c.achada) && mounted) {
      _relogio.stop();
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => TelaResultado(
          icone: Icons.search,
          vidaAntes: _vidaAntes,
          falhas: _falhas,
          tempo: _relogio.elapsed,
        ),
      ));
    }
  }

  Widget _carta(_Carta c) {
    final aberta = c.virada || c.achada;
    return GestureDetector(
      onTap: () => _tocar(c),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: c.achada
              ? Cores.roxoClaro.withValues(alpha: 0.45)
              : (aberta ? Cores.laranja : Cores.roxo),
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(4),
        ),
        child: aberta
            ? Icon(c.icone, color: c.achada ? Colors.white : Colors.black87, size: 34)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Moldura(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          children: [
            const CabecalhoMinijogo(titulo: 'Encontre a saída'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Explicacao(
                  texto: 'Encontre os pares de símbolos para achar a saída. '
                      'Cada tentativa errada custa 1 ponto de vida.'),
            ),
            VidaPerdida(vida: _vidaAntes, falhas: _falhas),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(builder: (context, c) {
                const colunas = 3, linhas = 4, espaco = 14.0;
                final larg = (c.maxWidth * 0.75 - espaco * (colunas - 1)) / colunas;
                final alt = (c.maxHeight - espaco * (linhas - 1)) / linhas;
                final w = larg.clamp(0.0, alt * 0.75);
                final h = w / 0.75;
                return Center(
                  child: SizedBox(
                    width: w * colunas + espaco * (colunas - 1),
                    child: Wrap(
                      spacing: espaco,
                      runSpacing: espaco,
                      children: [
                        for (final carta in _cartas)
                          SizedBox(width: w, height: h, child: _carta(carta)),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('tentativas falhas: $_falhas',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
