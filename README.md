# Brasas

App **companion** do jogo de tabuleiro Brasas. Cada jogador usa o app no próprio
aparelho para acompanhar a vida e o dano do seu herói, consultar a habilidade da
classe e sortear as provações (armadilhas) durante a partida.

**Jogar agora:** https://lcvb1997.github.io/brasas-app/

## O que o app faz

- **Escolha do herói:** Piratas, Gigantes Guarás, Fadas da Neblina, Androides e Povo
  Cinza, cada um com a sua habilidade especial e a regra geral das casas especiais.
- **Vida e dano:** definidos no início da partida (padrão: 100 de vida e 3 de dano) e
  editáveis a qualquer momento pelo menu ⋮ → *Editar vida e dano*, a partir dos valores
  atuais.
- **Armadilhas:** uma roleta sorteia a provação (*Desvendar as escrituras* ou
  *Encontre a saída*). Cada tentativa errada nos minijogos custa 1 ponto de vida, que o
  app desconta sozinho.
- **Menu ⋮:** editar vida e dano, trocar de herói e sair do jogo (com confirmação).
  Trocar de herói e sair liberam o herói anterior.
- **Partida salva:** herói, vida e dano ficam guardados no navegador/aparelho, então a
  partida continua ao recarregar a página ou voltar de outro app. Só é apagada ao sair
  do jogo ou trocar de herói.

> Cada aparelho guarda a sua própria partida. Não há servidor: os jogadores não se
> comunicam entre si, então dois jogadores podem escolher o mesmo herói.

## Instalar

### Web / iPhone / Android / PC (PWA)

Abra o link acima no navegador.

- **iPhone:** use o **Safari** → Compartilhar → *Adicionar à Tela de Início*.
- **Android:** Chrome → *Instalar app*.

### Android (APK)

O APK de teste está em [`dist/Brasas-1.0.0.apk`](dist/Brasas-1.0.0.apk). Ele é
assinado com a chave de debug (serve para instalar direto, não para a Play Store) e o
Android pede para liberar a instalação de fontes desconhecidas.

### iOS (app nativo)

Gerar o `.ipa` exige um Mac com Xcode e uma conta Apple Developer. A pasta `ios/` já
está pronta; em um Mac:

```bash
flutter build ipa
```

## Desenvolvimento

Requer o [Flutter](https://docs.flutter.dev/get-started/install) (stable).

```bash
flutter pub get
flutter run -d chrome        # ou: flutter run -d web-server --web-port 8088
flutter analyze
```

Gerar as versões de distribuição:

```bash
flutter build apk --release                                # Android
flutter build web --release --base-href "/brasas-app/"     # Web (PWA)
```

> No Windows, caminhos com acentos (como `Área de Trabalho`) quebram o analisador do
> Dart. Se acontecer, monte a pasta em uma letra de unidade com
> `subst Y: "caminho\do\projeto"` e rode os comandos por lá.

### Publicação

Todo push na branch `main` dispara o fluxo
[`.github/workflows/pages.yml`](.github/workflows/pages.yml), que gera a versão web e
publica no GitHub Pages (leva alguns minutos).

## Estrutura

```
lib/
  main.dart                 tema e rotas iniciais (abre direto no jogo se houver partida salva)
  estado_jogo.dart          heróis, vida/dano e persistência (shared_preferences)
  telas/
    inicio.dart             tela "Entrar"
    selecao_heroi.dart      escolha do herói e da habilidade
    editar_vida_dano.dart   vida e dano iniciais / edição pelo menu
    principal.dart          casca do jogo: abas Estado e Armadilhas, menu ⋮, voltar
    estado.dart             aba Estado
    armadilhas.dart         aba Armadilhas (roleta)
    caca_palavras.dart      minijogo "Desvendar as escrituras"
    jogo_memoria.dart       minijogo "Encontre a saída"
    resultado.dart          resultado da provação
  widgets/                  componentes compartilhados
```

## Pendências

- Entrada por código de acesso / QR code (hoje o app só tem o botão *Entrar*).
- Sincronizar o estado entre jogadores (exigiria um backend).
- Assinatura de release para a Play Store e publicação na App Store.
