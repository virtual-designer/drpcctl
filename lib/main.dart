import 'package:discordrpc/core/lifecycle.dart';
import 'package:discordrpc/widgets/app.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await (lifeCycle().onReady());
  runApp(App());
}