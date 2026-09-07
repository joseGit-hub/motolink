import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Added for Firebase
import 'firebase_options.dart'; // Added for Firebase options
import 'dashboard_page.dart';
import 'map_page.dart';

/// Brand colors for the dark MotoLink theme.
const Color motoAccent = Color(0xFF0F8BF2);
const Color motoBackground = Color(0xFF141411);
const Color motoCard = Color(0xFF262824);

void main() async {
  // Required to initialize native bindings before using Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using options generated from flutterfire configure
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MotoLinkApp());
}

class MotoLinkApp extends StatelessWidget {
  const MotoLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotoLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: motoAccent,
        scaffoldBackgroundColor: motoBackground,
      ),
      home: const HomeContainer(),
    );
  }
}

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    MapPage(),
  ];

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _MotoLinkBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class _MotoLinkBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _MotoLinkBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: motoCard,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Expanded(
                child: _NavBarItem(
                  icon: Icons.person,
                  label: 'Dashboard',
                  isActive: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
              ),
              Expanded(
                child: _NavBarItem(
                  icon: Icons.navigation,
                  label: 'Maps',
                  isActive: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isActive ? motoAccent : Colors.white38;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}