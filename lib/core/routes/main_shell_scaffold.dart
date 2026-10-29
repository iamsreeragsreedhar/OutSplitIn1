import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:out_split_in/core/shared_widgets/custom_nav_bar.dart';

class MainShellScaffold extends StatelessWidget {
  final StatefulNavigationShell navShell;
  const MainShellScaffold({super.key, required this.navShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navShell,
      bottomNavigationBar: CustombottomNavigationBar(
        currentIndex: navShell.currentIndex,
        onTap: (index) {
          navShell.goBranch(index, initialLocation: index == 0);
        },
      ),
    );
  }
}
