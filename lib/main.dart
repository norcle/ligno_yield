import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ligno_yiled/data/local_data_repository.dart';
import 'package:ligno_yiled/l10n/app_localizations.dart';
import 'package:ligno_yiled/routes.dart';
import 'package:ligno_yiled/state/app_bootstrap.dart';
import 'package:ligno_yiled/state/locale_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDataRepository.instance.preload();
  runApp(
    const ProviderScope(
      child: AppBootstrap(child: LignoUrozhaiApp()),
    ),
  );
}

class LignoUrozhaiApp extends ConsumerWidget {
  const LignoUrozhaiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeState = ref.watch(localeProvider);

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      locale: localeState.locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
