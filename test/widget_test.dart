import 'package:brasas/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('abre na tela inicial', (tester) async {
    await tester.pumpWidget(const BrasasApp());
    expect(find.text('BRASAS'), findsOneWidget);
    expect(find.text('INSIRA O CÓDIGO DE ACESSO'), findsOneWidget);
  });
}
