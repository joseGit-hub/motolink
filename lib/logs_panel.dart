import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class LogsPanel extends StatelessWidget {
  const LogsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // Reference to logsData in your regional Realtime Database
    final DatabaseReference logsRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          'https://motolink-14e76-default-rtdb.asia-southeast1.firebasedatabase.app',
    ).ref('MotoLink/logsData');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Logs',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: StreamBuilder<DatabaseEvent>(
            stream: logsRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("Firebase Logs Error: ${snapshot.error}");
                return Center(
                  child: Text(
                    'Error loading logs: ${snapshot.error}',
                    style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final rawData = snapshot.data?.snapshot.value;

              if (rawData == null) {
                return const Center(
                  child: Text(
                    'No logs yet',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              // Extract values from map and reverse them so newest entries appear at the top
              final Map<dynamic, dynamic> logsMap =
                  rawData as Map<dynamic, dynamic>;
              final List<String> logsList =
                  logsMap.values.map((e) => e.toString()).toList().reversed.toList();

              return ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: logsList.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.white10,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final logMessage = logsList[index];
                  final isAlert = logMessage.toUpperCase().contains('ALERT');

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isAlert ? Icons.warning_amber_rounded : Icons.info_outline,
                          size: 18,
                          color: isAlert ? Colors.redAccent : Colors.white54,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            logMessage,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isAlert ? FontWeight.w600 : FontWeight.w400,
                              color: isAlert ? Colors.redAccent : Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}