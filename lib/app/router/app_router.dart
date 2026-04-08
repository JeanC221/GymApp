import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartfit/app/shell/presentation/pages/app_shell_page.dart';
import 'package:smartfit/features/day_detail/presentation/pages/day_detail_page.dart';
import 'package:smartfit/features/home/presentation/pages/home_page.dart';
import 'package:smartfit/features/progress/presentation/pages/progress_page.dart';
import 'package:smartfit/features/settings/presentation/pages/settings_page.dart';
import 'package:smartfit/features/week/presentation/pages/week_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: HomePage.routePath,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShellPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HomePage.routePath,
                name: HomePage.routeName,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: WeekPage.routePath,
                name: WeekPage.routeName,
                builder: (context, state) => const WeekPage(),
                routes: [
                  GoRoute(
                    path: 'day/:dayId',
                    name: DayDetailPage.routeName,
                    builder: (context, state) => DayDetailPage(
                      dayId: state.pathParameters['dayId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ProgressPage.routePath,
                name: ProgressPage.routeName,
                builder: (context, state) => const ProgressPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: SettingsPage.routePath,
                name: SettingsPage.routeName,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
