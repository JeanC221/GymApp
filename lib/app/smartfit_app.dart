import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartfit/app/bootstrap/app_bootstrap.dart';
import 'package:smartfit/app/router/app_router.dart';
import 'package:smartfit/app/theme/app_theme.dart';
import 'package:smartfit/core/constants/app_constants.dart';

class SmartFitApp extends ConsumerWidget {
  const SmartFitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(appBootstrapProvider);

    return bootstrap.when(
      data: (_) => MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: ref.watch(appRouterProvider),
      ),
      loading: () => MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const _AppStartupState(
          title: 'Preparing SmartFit',
          message: 'Opening local database and loading the active plan.',
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: _AppStartupState(
          title: 'SmartFit could not start',
          message: error.toString(),
          child: FilledButton(
            onPressed: () => ref.invalidate(appBootstrapProvider),
            child: const Text('Retry'),
          ),
        ),
      ),
    );
  }
}

class _AppStartupState extends StatelessWidget {
  const _AppStartupState({
    required this.title,
    required this.message,
    required this.child,
  });

  final String title;
  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text(message, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
