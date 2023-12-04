import 'package:discord_rpc/discord_rpc.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class LifeCycle {
    static LifeCycle? _instance;

    LifeCycle() {
        _instance = this;
    }

    static LifeCycle getInstance() {
        _instance ??= LifeCycle();
        return _instance!;
    }

    Future<void> onReady() async {
        DiscordRPC.initialize();
        await YaruWindowTitleBar.ensureInitialized();
    }
}

LifeCycle lifeCycle() {
    return LifeCycle.getInstance();
}