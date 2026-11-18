import 'package:flutter/material.dart';

import 'telas/inicio.dart';
import 'widgets/comuns.dart';

void main() => runApp(const BrasasApp());

class BrasasApp extends StatelessWidget {
  const BrasasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brasas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Cores.cinza,
          primary: Cores.cinza,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Colors.black87,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          indicatorColor: Cores.cinzaClaro,
        ),
      ),
      // No navegador, limita a largura para parecer um celular.
      builder: (context, child) => ColoredBox(
        color: const Color(0xFFEDEDED),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: child,
          ),
        ),
      ),
      home: const TelaInicio(),
    );
  }
}
