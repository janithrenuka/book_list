import 'package:flutter/material.dart';
import '../screens/settings_screen.dart';

class GreetingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GreetingAppBar({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ⛅';
    if (hour < 17) return 'Good Afternoon 🌞';
    return 'Good Evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    final bool isSettings =
        ModalRoute.of(context)?.settings.name == '/settings';

    return AppBar(
      title: Text(
        _getGreeting(),
        style: TextStyle(
          color: Colors.blue[900],
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      actions: [
        if (!isSettings)
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                  settings: const RouteSettings(name: '/settings'),
                ),
              );
            },
            icon: Icon(Icons.settings_outlined, color: Colors.blue[900]),
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
