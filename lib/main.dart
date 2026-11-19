import 'package:flutter/material.dart';

import 'estado_jogo.dart';
import 'telas/inicio.dart';
import 'telas/principal.dart';
import 'widgets/comuns.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EstadoJogo.i.carregar();
  runApp(const BrasasApp());
}

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
      // Sem `home` (ou routes/onGenerateRoute) o MaterialApp não cria o
      // Navigator e a tela fica vazia. O `home` também atende a rota '/'.
      home: const TelaInicio(),
      // Com partida salva, abre direto no jogo; a tela inicial fica por baixo.
      onGenerateInitialRoutes: (_) => [
        MaterialPageRoute(builder: (_) => const TelaInicio()),
        if (EstadoJogo.i.heroi != null)
          MaterialPageRoute(builder: (_) => const TelaPrincipal()),
      ],
    );
  }
}
