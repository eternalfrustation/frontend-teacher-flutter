import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go("/login");
      // TODO: Add checks for auth and stuff
      // TODO: Make this pretty
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Text("Loading");
  }
}
