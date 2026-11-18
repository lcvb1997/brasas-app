import 'package:flutter/material.dart';

import '../estado_jogo.dart';
import '../widgets/comuns.dart';
import 'armadilhas.dart';
import 'editar_vida_dano.dart';
import 'estado.dart';
import 'selecao_heroi.dart';

enum _Acao { editar, trocarHeroi, sair }

/// Casca do jogo: título, menu (⋮) e navegação inferior com rótulos.
/// Estado e Armadilhas ficam vivos em abas, então nada se perde ao alternar.
class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key, this.aba = 0});

  final int aba;

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  late int _aba = widget.aba;

  Future<void> _executar(_Acao acao) async {
    switch (acao) {
      case _Acao.editar:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const TelaEditarVidaDano()));
      case _Acao.trocarHeroi:
        final ok = await confirmar(
          context,
          titulo: 'Trocar de herói?',
          mensagem: 'A vida e o dano do herói atual serão perdidos e ele ficará '
              'livre para ser escolhido de novo.',
          rotuloConfirmar: 'Trocar herói',
        );
        if (ok && mounted) {
          EstadoJogo.i.trocarHeroi();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const TelaSelecaoHeroi()),
            (rota) => rota.isFirst,
          );
        }
      case _Acao.sair:
        final ok = await confirmar(
          context,
          titulo: 'Sair do jogo?',
          mensagem: 'Você volta para a tela inicial e perde a vida e o dano atuais. '
              'Seu herói fica livre para ser escolhido de novo.',
          rotuloConfirmar: 'Sair do jogo',
          destrutivo: true,
        );
        if (ok && mounted) sairDoJogo(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Voltar nunca fecha o jogo sem avisar: na aba Armadilhas leva ao Estado;
    // no Estado pede confirmação para sair.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_aba != 0) {
          setState(() => _aba = 0);
        } else {
          _executar(_Acao.sair);
        }
      },
      child: _scaffold(context),
    );
  }

  Widget _scaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_aba == 0 ? 'Estado' : 'Armadilhas',
            style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          PopupMenuButton<_Acao>(
            tooltip: 'Mais opções',
            icon: const Icon(Icons.more_vert),
            color: Colors.white,
            onSelected: _executar,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: _Acao.editar,
                child: ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text('Editar vida e dano'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: _Acao.trocarHeroi,
                child: ListTile(
                  leading: Icon(Icons.sync),
                  title: Text('Trocar herói'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: _Acao.sair,
                child: ListTile(
                  leading: Icon(Icons.logout, color: Cores.vermelho),
                  title: Text('Sair do jogo', style: TextStyle(color: Cores.vermelho)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _aba,
        children: const [PaginaEstado(), PaginaArmadilhas()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _aba,
        onDestinationSelected: (i) => setState(() => _aba = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Estado'),
          NavigationDestination(
              icon: Icon(Icons.cyclone), selectedIcon: Icon(Icons.cyclone), label: 'Armadilhas'),
        ],
      ),
    );
  }
}

void sairDoJogo(BuildContext context) {
  EstadoJogo.i.sair();
  Navigator.of(context).popUntil((rota) => rota.isFirst);
}

/// Diálogo de confirmação padrão (ações difíceis de desfazer).
Future<bool> confirmar(
  BuildContext context, {
  required String titulo,
  required String mensagem,
  required String rotuloConfirmar,
  bool destrutivo = false,
}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: destrutivo ? Cores.vermelho : Cores.cinza),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(rotuloConfirmar),
        ),
      ],
    ),
  );
  return r ?? false;
}
