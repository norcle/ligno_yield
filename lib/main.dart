import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ligno_yiled/routes.dart';
import 'package:ligno_yiled/services/app_locale_controller.dart';
import 'package:ligno_yiled/widgets/locale_scope.dart';

void main() {
  runApp(const LignoUrozhaiApp());
}

class LignoUrozhaiApp extends StatefulWidget {
  const LignoUrozhaiApp({super.key});

  @override
  State<LignoUrozhaiApp> createState() => _LignoUrozhaiAppState();
}

class _LignoUrozhaiAppState extends State<LignoUrozhaiApp> {
  late final AppLocaleController _localeController;

  @override
  void initState() {
    super.initState();
    _localeController = AppLocaleController();
    final systemLocale =
        WidgetsBinding.instance.platformDispatcher.locale;
    _localeController.setLocale(
      _localeController.resolveSystemLocale(systemLocale),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LocaleScope(
      controller: _localeController,
      child: AnimatedBuilder(
        animation: _localeController,
        builder: (context, _) {
          return MaterialApp(
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)!.appTitle,
            locale: _localeController.locale,
            supportedLocales: AppLocaleController.supportedLocales,
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
            initialRoute: AppRoutes.input,
            onGenerateRoute: onGenerateRoute,
          );
        },
      ),
    );
  }
}
