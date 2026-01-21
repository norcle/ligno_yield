import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ligno_yiled/state/app_state_models.dart';
import 'package:ligno_yiled/state/calculator_draft_provider.dart';
import 'package:ligno_yiled/state/locale_provider.dart';
import 'package:ligno_yiled/state/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBootstrap extends ConsumerStatefulWidget {
  const AppBootstrap({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends ConsumerState<AppBootstrap> {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) {
      return;
    }

    ref.read(sharedPreferencesProvider.notifier).state = prefs;

    final savedLocale = prefs.getString(localeStorageKey);
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final resolvedLocale =
        localeFromCode(savedLocale) ?? resolveSystemLocale(systemLocale);
    ref.read(localeProvider.notifier).setLocale(resolvedLocale, persist: false);

    final draftJson = prefs.getString(calculatorDraftStorageKey);
    if (draftJson != null) {
      try {
        final decoded = jsonDecode(draftJson) as Map<String, Object?>;
        final draft = CalculatorDraftState.fromJson(decoded);
        ref
            .read(calculatorDraftProvider.notifier)
            .setDraft(draft, persist: false);
      } catch (_) {
        prefs.remove(calculatorDraftStorageKey);
      }
    }

    if (mounted) {
      setState(() {
        _isReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return widget.child;
  }
}
