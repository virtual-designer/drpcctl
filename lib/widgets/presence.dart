import 'package:discord_rpc/discord_rpc.dart';
import 'package:discordrpc/core/presence_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class Presence extends StatefulWidget {
  const Presence({super.key});

  @override
  State<Presence> createState() => _PresenceState();
}

class _PresenceState extends State<Presence> {
  bool enabled = false;
  bool showElapsedTime = false;
  TimeOfDay? time;
  DateTime? date;

  final clientIdController = TextEditingController();
  final stateController = TextEditingController();
  final detailsController = TextEditingController();
  final largeAssetController = TextEditingController();
  final smallAssetController = TextEditingController();
  final largeAssetTextController = TextEditingController();
  final smallAssetTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _snowflakeRegex = RegExp(r'^\d+$');
  final _urlRegex = RegExp(r'^http(s?)://([A-Za-z0-9-\.]*)([A-Za-z0-9-]+)');

  final presenceController = PresenceController();

  String? _snowflakeValidator(String? input) {
    return input != null && _snowflakeRegex.hasMatch(input) ? null : "Invalid Snowflake ID";
  }

  String? _urlAndAssetKeyValidator(String? input) {
    if (input != null && (input.startsWith('http:') || input.startsWith('https:')) && !_urlRegex.hasMatch(input)) {
      return "Invalid URL provided";
    }

    return input != null && input.contains(' ') ? 'Asset key cannot contain spaces' : null;
  }

  void _updatePresence() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    bool noInit = presenceController.clientId == null;
    final clientId = clientIdController.text;

    if (clientId != presenceController.clientId) {
      presenceController.clientId = clientId;
    }

    if (noInit) {
      presenceController.initialize();
      presenceController.start();
    }

    final timestamp = date == null && time == null ? null : ((date?.millisecondsSinceEpoch ?? 0) + ((time?.hour ?? 0) * 60 * 60 * 1000) + ((time?.minute ?? 0) * 60 * 1000));

    presenceController.updatePresence(
      DiscordPresence(
        details: detailsController.text,
        startTimeStamp: timestamp,
        largeImageKey: largeAssetController.text,
        largeImageText: largeAssetTextController.text,
        smallImageKey: smallAssetController.text,
        smallImageText: smallAssetTextController.text,
        state: stateController.text
      )
    );
  }

  void _clearPresence() {
    presenceController.clearPresence();
  }

  @override
  void dispose() {
    clientIdController.dispose();
    stateController.dispose();
    detailsController.dispose();
    largeAssetController.dispose();
    smallAssetController.dispose();
    largeAssetTextController.dispose();
    smallAssetTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: YaruSwitchButton(
                  value: enabled, 
                  title: const Text("Enable Presence"), 
                  onChanged: (state) {
                    setState(() {
                      if (state) {
                        _updatePresence();
                      }
                      else {
                        _clearPresence();
                      }

                      enabled = state;
                    });
                  },
                )
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Application Client ID'),
                    ),
                    validator: _snowflakeValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: clientIdController,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(
            indent: 10, 
            endIndent: 10
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10), 
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Activity Name (State)'),
                  ),
                  validator: (value) => value == null || value == "" ? "Activity name must not be empty!" : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: stateController,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Activity Description (details)'),
                  ),
                  minLines: 2,
                  maxLines: 4,
                  controller: detailsController,
                ),
                const SizedBox(height: 10), 
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Large Image URL or Asset Key'),
                        ),
                        validator: _urlAndAssetKeyValidator,
                        autovalidateMode: AutovalidateMode.always,
                        controller: largeAssetController,
                      )
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Large Image Text'),
                        ),
                        controller: largeAssetTextController,
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 10), 
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Small Image URL or Asset Key'),
                        ),
                        validator: _urlAndAssetKeyValidator,
                        autovalidateMode: AutovalidateMode.always,
                        controller: smallAssetController,
                      )
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Small Image Text'),
                        ),
                        controller: smallAssetTextController,
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 10), 
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          YaruSwitchButton(
                            value: showElapsedTime, 
                            title: const Text("Show Elapsed Time"), 
                            onChanged: (state) {
                              setState(() {
                                if (state) {
                                  date ??= DateTime.now();
                                  time ??= TimeOfDay.now();
                                }
                                else {
                                  date = null;
                                  time = null;
                                }

                                showElapsedTime = state;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        YaruIconButton(
                          icon: Icon(Icons.date_range, color: showElapsedTime ? null : const Color(0xFF777777)),
                          onPressed: () async {
                            if (!showElapsedTime) {
                              return;
                            }

                            final date = await showDatePicker(
                              context: context, 
                              lastDate: DateTime.now(),
                              firstDate: DateTime.fromMillisecondsSinceEpoch(0)
                            );

                            setState(() {
                              this.date = date;
                            });
                          }
                        ),
                        Text(
                          DateFormat.yMMMd().format(date ?? DateTime.now()),
                          style: TextStyle(
                            color: showElapsedTime ? null : const Color(0xFF777777)
                          ),
                        ),
                        YaruIconButton(
                          icon: Icon(Icons.timelapse, color: showElapsedTime ? null : const Color(0xFF777777)),
                          onPressed: () async {
                            if (!showElapsedTime) {
                              return;
                            }

                            final time = await showTimePicker(
                              context: context, 
                              initialTime: TimeOfDay.now(),
                            );

                            setState(() {
                              this.time = time;
                            });
                          }
                        ),
                        Text(
                          (time ?? TimeOfDay.now()).format(context),
                          style: TextStyle(
                            color: showElapsedTime ? null : const Color(0xFF777777)
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
                  return;
                }

                print("Submitted: ${clientIdController.text}");
                setState(() {
                  enabled = true;
                });
                _updatePresence();
              }, 
              child: const Text("Apply Changes")
            ),
          )
        ],
      ),
    );
  }
}