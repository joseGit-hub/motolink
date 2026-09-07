import 'package:flutter/material.dart';
import 'main.dart' show motoCard;

/// A rounded, dark surface card used for the "Live Status" and "Logs"
/// sections on the Dashboard. Swap the [child] out later for real content
/// (e.g. a live telemetry widget or a log list view).
class PlaceholderContainer extends StatelessWidget {
  final double height;
  final Widget? child;
  final String? placeholderLabel;
  final Color? accentColor;

  const PlaceholderContainer({
    super.key,
    required this.height,
    this.child,
    this.placeholderLabel,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(20);
    final double accentHeight = accentColor != null ? 5 : 0;

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: double.infinity,
        height: height,
        color: motoCard,
        child: Column(
          children: [
            if (accentColor != null)
              Container(height: accentHeight, color: accentColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: child ??
                    (placeholderLabel != null
                        ? Center(
                            child: Text(
                              placeholderLabel!,
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}