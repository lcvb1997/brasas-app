import 'package:flutter/material.dart';

import '../estado_jogo.dart';
import '../widgets/comuns.dart';
import '../widgets/contador.dart';
import 'principal.dart';

/// Define vida e dano.
/// - Início da partida (`heroi` informado): parte dos valores padrão; o herói só é
///   reservado ao tocar em "Começar", então voltar não deixa herói preso.
/// - Edição pelo menu: parte dos valores atuais do jogador.
class TelaEditarVidaDano extends StatefulWidget {
  const TelaEditarVidaDano({super.key, this.heroi});

  final Heroi? heroi;

  @override
  State<TelaEditarVidaDano> createState() => _TelaEditarVidaDanoState();
}

class _TelaEditarVidaDanoState extends State<TelaEditarVidaDano> {
  final _jogo = EstadoJogo.i;
  late int _vida = widget.heroi != null ? EstadoJogo.vidaPadrao : _jogo.vida;
  late int _dano = widget.heroi != null ? EstadoJogo.danoPadrao : _jogo.dano;
  int _passoVida = 1, _passoDano = 1;

  bool get _inicial => widget.heroi != null;

  void _confirmar() {
    if (_inicial) {
      _jogo.escolherHeroi(widget.heroi!);
      _jogo.definirVidaEDano(_vida, _dano);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const TelaPrincipal()),
        (rota) => rota.isFirst,
      );
    } else {
      _jogo.definirVidaEDano(_vida, _dano);
      final aviso = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      aviso
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Vida e dano atualizados')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_inicial ? 'Vida e dano iniciais' : 'Editar vida e dano',
            style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Column(
                  children: [
                    Text(
                      _inicial
                          ? 'Defina a vida e o dano de ${widget.heroi!.nome}. Durante a '
                              'partida, o app calcula a vida perdida.'
                          : 'Ajuste a vida e o dano a partir dos valores atuais.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    Contador(
                      icone: Icons.favorite,
                      rotulo: 'Vida',
                      valor: _vida,
                      passo: _passoVida,
                      onMudar: (d) => setState(() => _vida = (_vida + d).clamp(0, 99999)),
                      onPasso: (p) => setState(() => _passoVida = p),
                    ),
                    const SizedBox(height: 16),
                    Contador(
                      icone: Icons.colorize,
                      rotulo: 'Dano',
                      valor: _dano,
                      passo: _passoDano,
                      onMudar: (d) => setState(() => _dano = (_dano + d).clamp(0, 99999)),
                      onPasso: (p) => setState(() => _passoDano = p),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: BotaoCinza(texto: _inicial ? 'Começar' : 'Salvar', onPressed: _confirmar),
            ),
          ],
        ),
      ),
    );
  }
}
