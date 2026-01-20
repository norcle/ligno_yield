import 'package:flutter/material.dart';
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
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text(
                'LignoUrozhai',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calculate_outlined),
              title: const Text('Calculator'),
              onTap: () => _navigate(context, AppRoutes.input),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About the App'),
              onTap: () => _navigate(context, AppRoutes.about),
            ),
            ListTile(
              leading: const Icon(Icons.support_agent_outlined),
              title: const Text('Contacts / Support'),
              onTap: () => _navigate(context, AppRoutes.contacts),
            ),
          ],
        ),
      ),
    );
  }
}
