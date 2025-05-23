import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ModularApp', (tester) async {
    final modularKey = UniqueKey();
    final modularApp = ModularApp(
      key: modularKey,
      module: CustomModule(),
      child: const AppWidget(),
    );
    await tester.pumpWidget(modularApp);

    await tester.pump();
    expect(find.byKey(key), findsOneWidget);

    //final state = tester.state<ModularAppState>(find.byKey(modularKey));
    final result = Modular.get<String>();
    expect(result, 'test');

    await tester.pump();
    final notifier = Modular.get<ValueNotifier<int>>();
    notifier.value++;

    await tester.pump();

    expect(find.text('1'), findsOneWidget);

    final store = Modular.get<MyStore>();
    store.update(1);

    await tester.pump();

    expect(find.text('1'), findsWidgets);
  });
}

final key = UniqueKey();

class CustomModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance<String>('test');
    i.addSingleton<ValueNotifier<int>>(() => ValueNotifier<int>(0));
    i.addSingleton<Stream<int>>(
      () => Stream<int>.value(0).asBroadcastStream(),
    );
    i.addSingleton<MyStore>(MyStore.new);

    i.args;
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const Home());
  }
}

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<String>();

    return MaterialApp.router(
      routerConfig: Modular.routerConfig,
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ValueNotifier<int>>();
    final stream = context.watch<Stream<int>>();
    final store = context.watch<MyStore>();

    return Container(
      key: key,
      child: Column(
        children: [
          Text('${notifier.value}'),
          StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              return Text('${snapshot.data}');
            },
          ),
          Text('${store.state}')
        ],
      ),
    );
  }
}

class MyStore extends ValueNotifier<int> {
  MyStore() : super(0);

  int get state => value;

  late final void Function(int state)? fnState;
  late final void Function(bool state)? fnLoading;
  late final void Function(Exception state)? fnError;

  void update(int newState, {bool force = false}) {
    value = newState;
  }
}
