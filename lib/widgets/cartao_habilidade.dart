import 'package:flutter/material.dart';

import '../estado_jogo.dart';

/// Habilidade especial do herói + regra geral das casas especiais.
class CartaoHabilidade extends StatelessWidget {
  const CartaoHabilidade({super.key, required this.heroi});

  final Heroi heroi;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: heroi.cor, width: 1.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 18, color: heroi.cor),
              const SizedBox(width: 6),
              Text('Habilidade — ${heroi.nome}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 8),
          Text(heroi.habilidade, style: const TextStyle(fontSize: 14, height: 1.35)),
          const SizedBox(height: 10),
          const Text(regraCasaEspecial,
              style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.3)),
        ],
      ),
    );
  }
}
