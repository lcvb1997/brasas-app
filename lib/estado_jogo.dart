import 'package:flutter/material.dart';

class Heroi {
  Heroi(this.nome, this.regiao, this.cor, this.icone, this.habilidade, {this.emUso = false});

  final String nome;
  final String regiao;
  final Color cor;
  final IconData icone;

  /// Habilidade especial da classe (regras do tabuleiro).
  final String habilidade;
  bool emUso;
}

/// Estado em memória da partida (sem backend).
/// Regra geral das casas especiais.
const regraCasaEspecial = 'Se um herói de outra classe cair numa casa especial que não é '
    'dele, nada acontece com ele; depende do atributo/passiva da classe da casa.';

class EstadoJogo extends ChangeNotifier {
  EstadoJogo._();
  static final EstadoJogo i = EstadoJogo._();

  static const vidaPadrao = 100;
  static const danoPadrao = 3;

  /// Classes fictícias inspiradas nas regiões do Brasil.
  final List<Heroi> herois = [
    Heroi('Piratas', 'Nordeste', const Color(0xFF2E5AAC), Icons.sailing,
        'Pode trocar de posição com outro jogador. Ao trocar, ativa o efeito da casa '
        'em que o oponente estava (menos com alguém que caiu na armadilha).'),
    Heroi('Gigantes Guarás', 'Norte', const Color(0xFFC0161B), Icons.forest,
        'Pode chamar um jogador para a mesma casa e duelar com ele (menos com alguém '
        'que caiu na armadilha).'),
    Heroi('Fadas da Neblina', 'Centro-Oeste', const Color(0xFFB39DDB), Icons.cloud,
        'Pode encantar o solo: o herói que passar por lá toma 2 de dano '
        '(não acumulativo).'),
    Heroi('Androides', 'Sudeste', const Color(0xFF00A88F), Icons.smart_toy,
        'Pode se curar em 1 de vida (não acumulativo).'),
    Heroi('Povo Cinza', 'Sul', const Color(0xFF8E8E93), Icons.landscape,
        'Pode escolher uma das habilidades especiais dos outros heróis para a sua '
        'casa. Só pode escolher uma única vez, não pode trocar durante as rodadas.'),
  ];

  Heroi? heroi;

  int vida = vidaPadrao;
  int dano = danoPadrao;

  void escolherHeroi(Heroi h) {
    heroi = h..emUso = true;
    vida = vidaPadrao;
    dano = danoPadrao;
    notifyListeners();
  }

  /// Define vida e dano de uma vez (início da partida ou edição pelo menu).
  void definirVidaEDano(int novaVida, int novoDano) {
    vida = novaVida < 0 ? 0 : novaVida;
    dano = novoDano < 0 ? 0 : novoDano;
    notifyListeners();
  }

  /// Trocar herói: perde o progresso e o herói antigo volta a ficar livre.
  void trocarHeroi() {
    heroi?.emUso = false;
    heroi = null;
    vida = vidaPadrao;
    dano = danoPadrao;
    notifyListeners();
  }

  /// Sair do jogo encerra a sessão (o herói também fica livre).
  void sair() => trocarHeroi();

  void setVida(int v) {
    vida = v < 0 ? 0 : v;
    notifyListeners();
  }

  void setDano(int v) {
    dano = v < 0 ? 0 : v;
    notifyListeners();
  }
}
