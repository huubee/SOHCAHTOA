import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/features/calculator/presentation/calculator_screen.dart';
import 'package:myapp/src/features/calculator/presentation/history_screen.dart';
import 'package:myapp/src/features/trigonometry/presentation/trigonometry_screen.dart';
import 'package:myapp/src/screens/settings_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const TrigonometryScreen();
      },
    ),
    GoRoute(
      path: '/calculator',
      builder: (BuildContext context, GoRouterState state) {
        return const CalculatorScreen();
      },
      routes: [
        GoRoute(
          path: 'history',
          builder: (BuildContext context, GoRouterState state) {
            return const HistoryScreen();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsScreen();
      },
    ),
  ],
);
