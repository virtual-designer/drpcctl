import 'package:discordrpc/widgets/presence.dart';
import 'package:discordrpc/widgets/tab_bar.dart';
import 'package:discordrpc/widgets/title_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titlebar(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppTabBar(
                  onChange: (index) => setState(() {
                    this.index = index;
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          [
            const Presence(),
            const Text("About"),
          ][index]
        ],
      )
    );
  }
}
