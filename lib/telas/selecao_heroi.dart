import 'package:flutter/material.dart';

import '../estado_jogo.dart';
import '../widgets/comuns.dart';
import 'editar_vida_dano.dart';
import '../widgets/cartao_habilidade.dart';

class TelaSelecaoHeroi extends StatefulWidget {
  const TelaSelecaoHeroi({super.key});

  @override
  State<TelaSelecaoHeroi> createState() => _TelaSelecaoHeroiState();
}

class _TelaSelecaoHeroiState extends State<TelaSelecaoHeroi> {
  final _jogo = EstadoJogo.i;
  late final PageController _pagina;
  int _atual = 1;

  @override
  void initState() {
    super.initState();
    _pagina = PageController(viewportFraction: 0.58, initialPage: _atual);
  }

  @override
  void dispose() {
    _pagina.dispose();
    super.dispose();
  }

  void _mover(int delta) {
    final alvo = (_atual + delta).clamp(0, _jogo.herois.length - 1);
    _pagina.animateToPage(alvo,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _selecionar() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => TelaEditarVidaDano(heroi: _jogo.herois[_atual])),
    );
  }

  Widget _seta(IconData icone, int delta) {
    final habilitada = (_atual + delta) >= 0 && (_atual + delta) < _jogo.herois.length;
    return Material(
      color: Cores.cinzaClaro,
      child: InkWell(
        onTap: habilitada ? () => _mover(delta) : null,
        child: SizedBox(
          width: 38,
          height: 190,
          child: Icon(icone, color: habilitada ? Colors.black87 : Colors.black26),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final heroi = _jogo.herois[_atual];
    return Moldura(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const Expanded(child: Titulo('BRASAS', tamanho: 30)),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(36, 14, 36, 22),
              child: Text(
                'Identificamos o seu jogo, agora escolha o seu herói para ter '
                'acesso ao perfil do personagem e as armadilhas pelo acesso digital',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 230,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: _pagina,
                    itemCount: _jogo.herois.length,
                    onPageChanged: (p) => setState(() => _atual = p),
                    itemBuilder: (_, i) {
                      final h = _jogo.herois[i];
                      final foco = i == _atual;
                      return AnimatedPadding(
                        duration: const Duration(milliseconds: 250),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: foco ? 0 : 36),
                        child: GestureDetector(
                          onTap: () => _mover(i - _atual),
                          child: Container(
                            decoration: BoxDecoration(
                              color: h.emUso ? h.cor.withValues(alpha: 0.3) : h.cor,
                              border: Border.all(color: Colors.black26),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(h.icone,
                                    size: 80,
                                    color: Colors.white
                                        .withValues(alpha: h.emUso ? 0.5 : 0.9)),
                                const SizedBox(height: 8),
                                Text(h.nome,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white
                                            .withValues(alpha: h.emUso ? 0.6 : 1),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15)),
                                Text(h.regiao,
                                    style: TextStyle(
                                        color: Colors.white
                                            .withValues(alpha: h.emUso ? 0.5 : 0.85),
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Align(alignment: Alignment.centerLeft, child: _seta(Icons.chevron_left, -1)),
                  Align(alignment: Alignment.centerRight, child: _seta(Icons.chevron_right, 1)),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text('herói selecionado:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(radius: 8, backgroundColor: heroi.cor),
                const SizedBox(width: 8),
                Text('${heroi.nome} (${heroi.regiao})',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 14, 36, 0),
              child: Column(
                children: [
                  CartaoHabilidade(heroi: heroi),
                  const SizedBox(height: 14),
                  if (heroi.emUso)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(10),
                      color: Cores.cinzaClaro,
                      child: const Text(
                        'O herói selecionado já está em uso, escolha outro',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  BotaoCinza(
                    texto: 'Selecionar',
                    onPressed: heroi.emUso ? null : _selecionar,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
