import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ModularState', (tester) async {
    final modularApp =
        ModularApp(module: CustomModule(), child: const AppWidget());
    await tester.pumpWidget(modularApp);

    await tester.pump();
    final finder = find.byKey(key);
    expect(finder, findsOneWidget);
  });
}

final key = UniqueKey();

class CustomModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory<String>((i) => 'test'),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => HomeExample(key: key)),
      ];
}

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: Modular.routerConfig,
    );
  }
}

class HomeExample extends StatefulWidget {
  const HomeExample({Key? key}) : super(key: key);

  @override
  State<HomeExample> createState() => _HomeExampleState();
}

// ignore: deprecated_member_use_from_same_package
class _HomeExampleState extends ModularState<HomeExample, String> {
  @override
  Widget build(BuildContext context) {
    debugPrint(cubit);
    debugPrint(bloc);
    debugPrint(store);
    debugPrint(controller);
    return Container();
  }
}
