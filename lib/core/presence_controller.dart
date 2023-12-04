import 'package:discord_rpc/discord_rpc.dart';

class PresenceController {
    DiscordRPC? discord;
    String? clientId;

    void initialize() {
        discord = DiscordRPC(applicationId: clientId!);
    }

    void updateClientId(String id) {
        print("PresenceController: Client ID updated");
        clientId = id;
        discord?.shutDown();
        discord = DiscordRPC(applicationId: id);
    }

    void start() {
        print("PresenceController: Started");
        discord?.start(autoRegister: true);
    }

    void shutDown() {
        print("PresenceController: Shutting down");
        discord?.shutDown();
    }

    void updatePresence(DiscordPresence presence) {
        print("PresenceController: Presence Updated");
        discord?.updatePresence(presence);
    }

    void clearPresence() {
        discord?.clearPresence();
    }
}