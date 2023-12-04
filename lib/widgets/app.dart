import 'package:discordrpc/core/lifecycle.dart';
import 'package:discordrpc/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class App extends StatelessWidget {
  static late App app;

  App({super.key}) {
    app = this;
  }

  static const title = 'Discord RPC Control';
  final LifeCycle lifeCycle = LifeCycle.getInstance();

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      data: const YaruThemeData(
        themeMode: ThemeMode.dark,
        useMaterial3: true,
        variant: YaruVariant.ubuntuStudioBlue,
      ),
      builder: (context, yaru, child) => MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        theme: yaru.theme,
        darkTheme: yaru.darkTheme,
        home: const HomePage(title: title)
      ),
    );
  }
}
