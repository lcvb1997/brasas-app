import 'package:flutter/material.dart';

import '../widgets/comuns.dart';
import 'selecao_heroi.dart';

class TelaInicio extends StatelessWidget {
  const TelaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Moldura(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Titulo('BRASAS', tamanho: 34),
              const SizedBox(height: 40),
              BotaoCinza(
                texto: 'Entrar',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TelaSelecaoHeroi()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
