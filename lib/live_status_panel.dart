import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class LiveStatusPanel extends StatelessWidget {
  const LiveStatusPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // Reference to statusData targeting the regional Realtime Database instance
    final DatabaseReference statusRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          'https://motolink-14e76-default-rtdb.asia-southeast1.firebasedatabase.app',
    ).ref('MotoLink/statusData');

    return StreamBuilder<DatabaseEvent>(
      stream: statusRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Prints exact error details to Debug Console for troubleshooting
          print("Firebase Realtime Database Error: ${snapshot.error}");
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Extract data map from snapshot
        final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;

        final String wifi = data?['WiFi']?.toString() ?? 'Disconnected';
        final String battery = data?['Battery']?.toString() ?? '--';
        final String security = data?['Security']?.toString() ?? 'OFF';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatusRow(
                    icon: Icons.wifi,
                    label: 'WiFi',
                    value: wifi,
                  ),
                  _StatusRow(
                    icon: Icons.security,
                    label: 'Security',
                    value: security,
                  ),
                  _StatusRow(
                    icon: Icons.battery_full,
                    label: 'Battery',
                    value: '$battery%',
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatusRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatusRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.white60),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white38,
          ),
        ),
      ],
    );
  }
}