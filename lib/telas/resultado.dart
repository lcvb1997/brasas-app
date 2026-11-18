import 'package:flutter/material.dart';

import '../estado_jogo.dart';
import '../widgets/comuns.dart';
import 'principal.dart';

class TelaResultado extends StatelessWidget {
  const TelaResultado({
    super.key,
    required this.icone,
    required this.vidaAntes,
    required this.falhas,
    required this.tempo,
  });

  final IconData icone;
  final int vidaAntes;
  final int falhas;
  final Duration tempo;

  int get vidaDepois => (vidaAntes - falhas).clamp(0, vidaAntes);

  void _voltar(BuildContext context) {
    EstadoJogo.i.setVida(vidaDepois);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const TelaPrincipal()),
      (rota) => rota.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mm = tempo.inMinutes.toString().padLeft(2, '0');
    final ss = (tempo.inSeconds % 60).toString().padLeft(2, '0');
    const negrito = TextStyle(fontWeight: FontWeight.w800, fontSize: 15);

    return Moldura(
        fundo: Cores.laranja,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
            child: Column(
              children: [
                const Text('VOCÊ ENCONTROU\nA SAÍDA EM',
                    textAlign: TextAlign.center, style: negrito),
                const SizedBox(height: 10),
                Text('$mm : $ss',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 36),
                Transform.rotate(
                  angle: -0.35,
                  child: Container(
                    width: 130,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Cores.roxo,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Transform.rotate(
                      angle: 0.35,
                      child: Icon(icone, color: Colors.white, size: 96),
                    ),
                  ),
                ),
                const SizedBox(height: 44),
                const Text('RESULTADO DA PROVAÇÃO', style: negrito),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _vida(vidaAntes),
                    const Icon(Icons.east, size: 40),
                    _vida(vidaDepois),
                  ],
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Tentativas falhas: $falhas',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 22),
                BotaoCinza(texto: 'Ver meu estado', onPressed: () => _voltar(context)),
              ],
            ),
          ),
        ),
    );
  }

  Widget _vida(int v) => Row(
        children: [
          const Icon(Icons.favorite, size: 16),
          const SizedBox(width: 4),
          Text('$v', style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      );
}
