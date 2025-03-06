import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/store.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Dashboard Page'),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                // Navigate back to first screen when tapped.
                Store.logout();
                context.replace("/login");
              },
            ),
          ],
        ),
      ),
    );
  }
}
