import 'package:flutter/material.dart';

class Cores {
  static const cinza = Color(0xFF4A4A4A);
  static const cinzaClaro = Color(0xFFE6E6E6);
  static const laranja = Color(0xFFFF9F45);
  static const roxo = Color(0xFF7B5CE0);
  static const roxoClaro = Color(0xFF9B87F0);
  static const vermelho = Color(0xFFC0161B);
}

/// Moldura simples respeitando as áreas seguras do aparelho.
class Moldura extends StatelessWidget {
  const Moldura({super.key, required this.child, this.fundo = Colors.white});

  final Widget child;
  final Color fundo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: fundo, body: SafeArea(child: child));
  }
}

class BotaoCinza extends StatelessWidget {
  const BotaoCinza({super.key, required this.texto, this.onPressed});

  final String texto;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Cores.cinza,
          disabledBackgroundColor: Cores.cinzaClaro,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onPressed: onPressed,
        child: Text(texto),
      ),
    );
  }
}

class BotaoContorno extends StatelessWidget {
  const BotaoContorno({super.key, required this.texto, this.onPressed});

  final String texto;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87,
          side: const BorderSide(color: Colors.black54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        onPressed: onPressed,
        child: Text(texto),
      ),
    );
  }
}

class Titulo extends StatelessWidget {
  const Titulo(this.texto, {super.key, this.tamanho = 26});

  final String texto;
  final double tamanho;

  @override
  Widget build(BuildContext context) => Text(
        texto,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: tamanho, fontWeight: FontWeight.w800),
      );
}

class Explicacao extends StatelessWidget {
  const Explicacao({super.key, required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) => Text(
        texto,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      );
}

class CabecalhoMinijogo extends StatelessWidget {
  const CabecalhoMinijogo({super.key, required this.titulo});
  final String titulo;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 4),
          Text(titulo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        ],
      );
}

/// "♦ 100 (-3)" dos minijogos.
class VidaPerdida extends StatelessWidget {
  const VidaPerdida({super.key, required this.vida, required this.falhas});
  final int vida, falhas;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite, size: 18),
          const SizedBox(width: 4),
          Text('$vida (-$falhas)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        ],
      );
}
