import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'home/home_screen.dart';
import 'track/track_screen.dart';
import 'save/save_screen.dart';
import 'impact/impact_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Each tab has its own navigator key so back-stack stays per-tab
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Track (contains Home → Fridge)
    GlobalKey<NavigatorState>(), // Save
    GlobalKey<NavigatorState>(), // Impact
  ];

  Widget _buildTrackNavigator() {
    return Navigator(
      key: _navigatorKeys[0],
      onGenerateRoute: (settings) {
        if (settings.name == '/track') {
          return MaterialPageRoute(builder: (_) => const TrackScreen());
        }
        return MaterialPageRoute(builder: (_) => HomeScreen(
          onGoToFridge: () => _navigatorKeys[0].currentState!
              .pushNamed('/track'),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        final nav = _navigatorKeys[_currentIndex].currentState!;
        if (nav.canPop()) {
          nav.pop();
        } else if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildTrackNavigator(),
            Navigator(
              key: _navigatorKeys[1],
              onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => const SaveScreen()),
            ),
            Navigator(
              key: _navigatorKeys[2],
              onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => const ImpactScreen()),
            ),
          ],
        ),
        bottomNavigationBar: _buildNav(),
      ),
    );
  }

  Widget _buildNav() {
    const labels = ['Fridge', 'Recipes', 'Impact'];
    const icons = ['🧊', '🍳', '📊'];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.dark.withValues(alpha: 0.08), width: 1.5),
            boxShadow: [
              BoxShadow(color: AppColors.dark.withValues(alpha: 0.10), offset: const Offset(0, -3), blurRadius: 16),
              BoxShadow(color: AppColors.dark.withValues(alpha: 0.06), offset: const Offset(0, 4), blurRadius: 0),
            ],
          ),
          child: Row(
            children: List.generate(3, (i) {
              final active = _currentIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_currentIndex == i) {
                      // Pop to root of this tab on double-tap
                      _navigatorKeys[i].currentState?.popUntil((r) => r.isFirst);
                    }
                    setState(() => _currentIndex = i);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(fontSize: active ? 22 : 18),
                        child: Text(icons[i]),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        labels[i],
                        style: active
                            ? GoogleFonts.fredoka(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.teal)
                            : GoogleFonts.fredoka(fontSize: 11, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
