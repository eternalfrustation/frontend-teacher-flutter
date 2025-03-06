import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'services/store.dart';
import 'views/dashboard_page.dart';
import 'views/loading_page.dart';
import 'views/login_page.dart';

void main() {
  Store.init();
  runApp(const Application());
}

final GoRouter _router = GoRouter(
  initialLocation: '/loading',
  routes: [
    GoRoute(
      path: "/loading",
      builder: (context, state) => const LoadingPage(),
    ),
    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: "/dashboard",
      builder: (context, state) => const DashboardPage(),
    ),
  ],
);

class Application extends StatelessWidget {
  const Application({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'schoolERP',
      builder: (context, child) => Material(child: child),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
