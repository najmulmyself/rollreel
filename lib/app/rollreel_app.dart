import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../navigation/app_router.dart';

class RollReelApp extends StatelessWidget {
  const RollReelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RollReel',
      debugShowCheckedModeBanner: false,
      theme: RRAppTheme.dark(),
      darkTheme: RRAppTheme.dark(),
      themeMode: ThemeMode.dark,
      home: const AppRouter(),
    );
  }
}
