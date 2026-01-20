import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ligno_yiled/data/local_data_repository.dart';
import 'package:ligno_yiled/state/app_providers.dart';
import 'package:ligno_yiled/widgets/ligno_app.dart';

class AppBootstrap extends ConsumerStatefulWidget {
  const AppBootstrap({super.key});

  @override
  ConsumerState<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends ConsumerState<AppBootstrap> {
  late final Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeApp();
  }

  Future<void> _initializeApp() async {
    await LocalDataRepository.instance.preload();
    final prefs = await SharedPreferences.getInstance();
    ref.read(localeProvider.notifier)
      ..attachPreferences(prefs)
      ..hydrate(
        systemLocale: WidgetsBinding.instance.platformDispatcher.locale,
      );
    ref.read(calculatorDraftProvider.notifier)
      ..attachPreferences(prefs)
      ..hydrate();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        return const LignoUrozhaiApp();
      },
    );
  }
}
