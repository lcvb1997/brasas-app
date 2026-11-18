import 'package:flutter/material.dart';

import '../estado_jogo.dart';
import '../widgets/cartao_habilidade.dart';
import '../widgets/comuns.dart';

/// Conteúdo da aba Estado: quem é o herói e quanto de vida e dano ele tem.
class PaginaEstado extends StatelessWidget {
  const PaginaEstado({super.key});

  @override
  Widget build(BuildContext context) {
    final jogo = EstadoJogo.i;
    return ListenableBuilder(
      listenable: jogo,
      builder: (context, _) {
        final cor = jogo.heroi?.cor ?? Colors.grey;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: cor,
                child: Icon(jogo.heroi?.icone ?? Icons.person, size: 46, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(jogo.heroi?.nome ?? '',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Text(jogo.heroi?.regiao ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                      child: _Valor(icone: Icons.favorite, rotulo: 'Vida', valor: jogo.vida)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _Valor(icone: Icons.colorize, rotulo: 'Dano', valor: jogo.dano)),
                ],
              ),
              if (jogo.vida == 0) ...[
                const SizedBox(height: 16),
                const Text('Sua vida chegou a zero.',
                    style: TextStyle(fontWeight: FontWeight.w700, color: Cores.vermelho)),
              ],
              if (jogo.heroi != null) ...[
                const SizedBox(height: 20),
                CartaoHabilidade(heroi: jogo.heroi!),
              ],
              const SizedBox(height: 28),
              const Text(
                'Para corrigir a vida ou o dano, toque em ⋮ e escolha “Editar vida e dano”.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Valor extends StatelessWidget {
  const _Valor({required this.icone, required this.rotulo, required this.valor});

  final IconData icone;
  final String rotulo;
  final int valor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$rotulo: $valor',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icone, size: 18),
                const SizedBox(width: 6),
                Text(rotulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 8),
            Text('$valor', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}
