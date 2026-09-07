import 'package:flutter/material.dart';
import 'main.dart' show motoAccent, motoCard;

class ActionSwitchCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const ActionSwitchCard({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: motoCard,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Adapts dynamically instead of forcing 120px
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (isActive ? motoAccent : Colors.white24)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      size: 18,
                      color: isActive ? motoAccent : Colors.white54,
                    ),
                  ),
                  const Spacer(),
                  IgnorePointer(
                    child: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: isActive,
                        onChanged: (_) {},
                        activeThumbColor: motoAccent,
                        inactiveThumbColor: Colors.white54,
                        inactiveTrackColor: Colors.white12,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isActive ? 'On' : 'Off',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isActive ? motoAccent : Colors.white38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}