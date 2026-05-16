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

  // Each tab has its own navigator key so back-stack stays per-tab.
  // Order: Home / Track (Fridge) / Save (Recipes) / Impact (Stats)
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  Widget _buildHomeNavigator() {
    return Navigator(
      key: _navigatorKeys[0],
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => HomeScreen(
          // "View all →" on Home now switches to the Track tab directly.
          onGoToFridge: () => setState(() => _currentIndex = 1),
        ),
      ),
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
            _buildHomeNavigator(),
            Navigator(
              key: _navigatorKeys[1],
              onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => const TrackScreen()),
            ),
            Navigator(
              key: _navigatorKeys[2],
              onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => const SaveScreen()),
            ),
            Navigator(
              key: _navigatorKeys[3],
              onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => const ImpactScreen()),
            ),
          ],
        ),
        bottomNavigationBar: _buildNav(),
      ),
    );
  }

  Widget _buildNav() {
    const labels = ['Home', 'Track', 'Save', 'Impact'];
    const activeIcons = [
      Icons.home_rounded,
      Icons.kitchen_rounded,
      Icons.menu_book_rounded,
      Icons.insights_rounded,
    ];
    const inactiveIcons = [
      Icons.home_outlined,
      Icons.kitchen_outlined,
      Icons.menu_book_outlined,
      Icons.insights_outlined,
    ];

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
            children: List.generate(4, (i) {
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
                      Icon(
                        active ? activeIcons[i] : inactiveIcons[i],
                        size: 22,
                        color: active ? AppColors.teal : AppColors.muted,
                      ),
                      const SizedBox(height: 4),
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
