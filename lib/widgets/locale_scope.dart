import 'package:flutter/material.dart';
import 'package:ligno_yiled/services/app_locale_controller.dart';

class LocaleScope extends InheritedNotifier<AppLocaleController> {
  const LocaleScope({
    super.key,
    required AppLocaleController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static AppLocaleController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'LocaleScope not found in widget tree.');
    return scope!.notifier!;
  }
}
