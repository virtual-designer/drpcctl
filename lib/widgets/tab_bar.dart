import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class AppTabBar extends StatefulWidget {
  final void Function(int)? onChange;

  const AppTabBar({super.key, this.onChange});

  @override
  State<AppTabBar> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        widget.onChange?.call(tabController.index);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YaruTabBar(
      tabController: tabController,
      tabs: const [
        YaruTab(
          label: 'Presence',
          icon: Icon(YaruIcons.settings),
        ),
        YaruTab(
          label: 'About',
          icon: Icon(YaruIcons.information),
        ),
      ],
    );
  }
}
