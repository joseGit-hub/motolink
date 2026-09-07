import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'action_switch_card.dart';
import 'placeholder_container.dart';
import 'live_status_panel.dart';
import 'logs_panel.dart';
import 'main.dart' show motoAccent;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // References targeting your regional Realtime Database instance
  final DatabaseReference _switchRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://motolink-14e76-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref('MotoLink/switchData');

  final DatabaseReference _statusRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://motolink-14e76-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref('MotoLink/statusData');

  StreamSubscription<DatabaseEvent>? _switchSubscription;

  bool _guardActive = false;
  bool _remoteActive = false;

  @override
  void initState() {
    super.initState();
    // Sync UI switches in real-time with database values
    _switchSubscription = _switchRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && mounted) {
        setState(() {
          _guardActive = data['GuardStatus'] == 'ON';
          _remoteActive = data['RemoteStatus'] == 'ON';
        });
      }
    }, onError: (error) {
      // ignore: avoid_print
      print("Error listening to switchData: $error");
    });
  }

  @override
  void dispose() {
    _switchSubscription?.cancel();
    super.dispose();
  }

  // Toggles GuardStatus and updates Security in statusData
  Future<void> _onGuardSwitchTap() async {
    final nextState = _guardActive ? 'OFF' : 'ON';
    try {
      await _switchRef.update({'GuardStatus': nextState});
      await _statusRef.update({'Security': nextState});
    } catch (e) {
      // ignore: avoid_print
      print("Failed to toggle Guard Switch: $e");
    }
  }

  // Toggles RemoteStatus and updates Alarm in statusData
  Future<void> _onRemoteSwitchTap() async {
    final nextState = _remoteActive ? 'OFF' : 'ON';
    try {
      await _switchRef.update({'RemoteStatus': nextState});
      await _statusRef.update({'Alarm': nextState});
    } catch (e) {
      // ignore: avoid_print
      print("Failed to toggle Remote Switch: $e");
    }
  }

  void _onInfoTap() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/motolink_logo.png',
                  height: 70,
                  fit: BoxFit.contain,
                ),
                const Spacer(),
                IconButton(
                  onPressed: _onInfoTap,
                  icon: const Icon(Icons.info_outline, color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Expanded(
              flex: 3,
              child: PlaceholderContainer(
                height: double.infinity,
                accentColor: motoAccent,
                child: LiveStatusPanel(),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ActionSwitchCard(
                    icon: Icons.home_outlined,
                    label: 'Helmet Guard',
                    isActive: _guardActive,
                    onTap: _onGuardSwitchTap,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ActionSwitchCard(
                    icon: Icons.settings_remote_outlined,
                    label: 'Remote Alarm',
                    isActive: _remoteActive,
                    onTap: _onRemoteSwitchTap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Expanded(
              flex: 2,
              child: PlaceholderContainer(
                height: double.infinity,
                accentColor: motoAccent,
                child: LogsPanel(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}