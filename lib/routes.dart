import 'package:flutter/material.dart';
import 'package:ligno_yiled/models/calculation_result.dart';
import 'package:ligno_yiled/models/crop_input.dart';
import 'package:ligno_yiled/screens/about_screen.dart';
import 'package:ligno_yiled/screens/contacts_screen.dart';
import 'package:ligno_yiled/screens/input_screen.dart';
import 'package:ligno_yiled/screens/phase_timeline_screen.dart';
import 'package:ligno_yiled/screens/result_screen.dart';

class AppRoutes {
  static const input = '/';
  static const phaseTimeline = '/phase-timeline';
  static const result = '/result';
  static const about = '/about';
  static const contacts = '/contacts';
}

class PhaseTimelineArgs {
  const PhaseTimelineArgs({required this.input});

  final CropInput input;
}

class ResultScreenArgs {
  const ResultScreenArgs({
    required this.input,
    required this.result,
  });

  final CropInput input;
  final CalculationResult result;
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.input:
      return MaterialPageRoute(
        builder: (_) => const InputScreen(),
        settings: settings,
      );
    case AppRoutes.phaseTimeline:
      final args = settings.arguments as PhaseTimelineArgs;
      return MaterialPageRoute(
        builder: (_) => PhaseTimelineScreen(input: args.input),
        settings: settings,
      );
    case AppRoutes.result:
      final args = settings.arguments as ResultScreenArgs;
      return MaterialPageRoute(
        builder: (_) => ResultScreen(input: args.input, result: args.result),
        settings: settings,
      );
    case AppRoutes.about:
      return MaterialPageRoute(
        builder: (_) => const AboutScreen(),
        settings: settings,
      );
    case AppRoutes.contacts:
      return MaterialPageRoute(
        builder: (_) => const ContactsScreen(),
        settings: settings,
      );
    default:
      return MaterialPageRoute(
        builder: (_) => const InputScreen(),
        settings: settings,
      );
  }
}
