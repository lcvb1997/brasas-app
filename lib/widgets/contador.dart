import 'package:flutter/material.dart';

/// Ajuste de um valor com -/+ (alvos de 56 px) e passo visível (1, 5 ou 10).
class Contador extends StatelessWidget {
  const Contador({
    super.key,
    required this.icone,
    required this.rotulo,
    required this.valor,
    required this.passo,
    required this.onMudar,
    required this.onPasso,
  });

  final IconData icone;
  final String rotulo;
  final int valor, passo;
  final ValueChanged<int> onMudar; // recebe +passo ou -passo
  final ValueChanged<int> onPasso;

  Widget _botao(IconData i, String dica, VoidCallback? f) => IconButton.outlined(
        tooltip: dica,
        onPressed: f,
        icon: Icon(i),
        style: IconButton.styleFrom(
          fixedSize: const Size(56, 56),
          foregroundColor: Colors.black87,
          side: BorderSide(color: f == null ? Colors.black12 : Colors.black54),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
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
          const SizedBox(height: 10),
          Row(
            children: [
              _botao(Icons.remove, 'Diminuir $rotulo', valor > 0 ? () => onMudar(-passo) : null),
              Expanded(
                child: Text('$valor',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
              ),
              _botao(Icons.add, 'Aumentar $rotulo', () => onMudar(passo)),
            ],
          ),
          const SizedBox(height: 12),
          SegmentedButton<int>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 1, label: Text('±1')),
              ButtonSegment(value: 5, label: Text('±5')),
              ButtonSegment(value: 10, label: Text('±10')),
            ],
            selected: {passo},
            onSelectionChanged: (s) => onPasso(s.first),
          ),
        ],
      ),
    );
  }
}
