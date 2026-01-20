import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ligno_yiled/routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _navigate(BuildContext context, String routeName) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    Navigator.of(context).pop();
    if (currentRoute == routeName) {
      return;
    }
    if (routeName == AppRoutes.input) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.input,
        (route) => false,
      );
      return;
    }
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                l10n.appTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calculate_outlined),
              title: Text(l10n.menuCalculator),
              onTap: () => _navigate(context, AppRoutes.input),
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: Text(l10n.menuProducts),
              onTap: () => _navigate(context, AppRoutes.products),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.menuAbout),
              onTap: () => _navigate(context, AppRoutes.about),
            ),
            ListTile(
              leading: const Icon(Icons.support_agent_outlined),
              title: Text(l10n.menuContacts),
              onTap: () => _navigate(context, AppRoutes.contacts),
            ),
          ],
        ),
      ),
    );
  }
}
