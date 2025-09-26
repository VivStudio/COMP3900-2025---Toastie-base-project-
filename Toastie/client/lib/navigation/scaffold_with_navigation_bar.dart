import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:toastie/navigation/app_navigation_utils.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/responsive_utils.dart';

enum NavigationBarTab {
  Home,
  Calendar,
  Insights,
}

class ScaffoldWithNavigationBar extends StatefulWidget {
  ScaffoldWithNavigationBar({
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNavigationBar> createState() =>
      _ScaffoldWithNavigationBarState();
}

class _ScaffoldWithNavigationBarState extends State<ScaffoldWithNavigationBar> {
  int _selectedIndex = 0;
  GoRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newRouter = GoRouter.of(context);

    // Only add the listener once
    if (_router != newRouter) {
      _router?.routerDelegate.removeListener(_updateSelectedIndex);
      _router = newRouter;
      _router!.routerDelegate.addListener(_updateSelectedIndex);
    }
  }

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_updateSelectedIndex);
    super.dispose();
  }

  void _updateSelectedIndex() {
    setState(() {
      String currentPath = GoRouter.of(context).state.matchedLocation;
      setState(() {
        if (currentPath == calendarPath) {
          _selectedIndex = NavigationBarTab.Calendar.index;
        } else if (currentPath == insightsPath) {
          _selectedIndex = NavigationBarTab.Insights.index;
        } else {
          // Default to Home
          _selectedIndex = NavigationBarTab.Home.index;
        }
      });
    });
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  List<GButton> GButtonsWithText() {
    return [
      GButton(icon: Icons.home, text: 'Home'),
      GButton(icon: Icons.calendar_today, text: 'Calendar'),
      GButton(icon: Icons.insights, text: 'Insights'),
    ];
  }

  // TODO: if we need to add a new tab, we need to reimplement GNav so that it wraps the buttons if they can't fit on one line (will get pixel overflow error otherwise).
  List<GButton> GButtonWithScaledIcons() {
    double iconSize = scaleBySystemFont(context: context, size: 20);
    return [
      GButton(icon: Icons.home, iconSize: iconSize),
      GButton(icon: Icons.calendar_today, iconSize: iconSize),
      GButton(icon: Icons.insights, iconSize: iconSize),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Container(
        color: primary[100],
        child: SafeArea(
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: gridbaseline,
              ),
              child: GNav(
                selectedIndex: _selectedIndex,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                tabMargin: EdgeInsets.symmetric(horizontal: gridbaseline),
                backgroundColor: primary[100]!,
                color: primary[300],
                activeColor: primary,
                padding: EdgeInsets.symmetric(
                  vertical: gridbaseline,
                  horizontal: gridbaseline * 2,
                ),
                gap: gridbaseline,
                tabBackgroundColor: primary[200]!,
                tabs: [
                  ...(shouldAdaptForAccessibility(context: context)
                      ? GButtonWithScaledIcons()
                      : GButtonsWithText()),
                ],
                tabBorderRadius: gridbaseline * 2,
                onTabChange: _onTap,
                textStyle: labelLargeTextWithColor(context, primary).copyWith(
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
