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
    const labels = ['Track', 'Save', 'Impact'];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                  color: AppColors.dark.withValues(alpha: 0.10),
                  offset: const Offset(0, -3),
                  blurRadius: 16),
              BoxShadow(
                  color: AppColors.dark.withValues(alpha: 0.06),
                  offset: const Offset(0, 4),
                  blurRadius: 0),
            ],
          ),
          child: Row(
            children: List.generate(3, (i) {
              final active = _currentIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_currentIndex == i) {
                      _navigatorKeys[i].currentState?.popUntil((r) => r.isFirst);
                    }
                    setState(() => _currentIndex = i);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active
                              ? AppColors.teal.withValues(alpha: 0.7)
                              : AppColors.muted.withValues(alpha: 0.3),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        labels[i],
                        style: GoogleFonts.fredoka(
                          fontSize: 11,
                          fontWeight:
                              active ? FontWeight.w600 : FontWeight.w400,
                          color: active ? AppColors.teal : AppColors.muted,
                        ),
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
