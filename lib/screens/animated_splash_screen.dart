import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ligno_yiled/routes.dart';
import 'package:ligno_yiled/screens/input_screen.dart';
import 'package:lottie/lottie.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  static const _splashBackground = Color(0xFFEAF5E7);
  static const _splashDuration = Duration(milliseconds: 1900);

  late final AnimationController _lottieController;
  bool _isVisible = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isVisible = true;
      });
      HapticFeedback.lightImpact();
      _scheduleNavigation();
    });
  }

  Future<void> _scheduleNavigation() async {
    if (_isNavigating) {
      return;
    }
    _isNavigating = true;
    await Future.delayed(_splashDuration);
    if (!mounted) {
      return;
    }
    await Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        settings: const RouteSettings(name: AppRoutes.input),
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: const InputScreen(),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _splashBackground,
      body: SafeArea(
        child: Center(
          child: AnimatedOpacity(
            opacity: _isVisible ? 1 : 0,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOut,
            child: AnimatedScale(
              scale: _isVisible ? 1 : 0.96,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOut,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 220,
                    width: 220,
                    child: Lottie.asset(
                      // Source: https://github.com/muhammadhariszafar1994/plant-lottie-animation
                      // License: Not specified in the repository. Verify with the author before commercial use.
                      'assets/animations/plant.json',
                      controller: _lottieController,
                      onLoaded: (composition) {
                        _lottieController
                          ..duration = composition.duration
                          ..forward();
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'LignoUrozhai',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Growing every harvest',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
