import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/admin/presentation/admin_screen.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/providers.dart';
import '../features/items/presentation/item_edit_screen.dart';
import '../features/items/presentation/item_view_screen.dart';
import '../features/items/presentation/items_list_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final authChanges = ref.watch(authRepositoryProvider).authStateChanges();
  final authNotifier = GoRouterRefreshStream(authChanges);
  final navigatorKey = ref.watch(navigatorKeyProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoggedIn = ref.read(isAdminLoggedInProvider);
      final loggingIn = state.matchedLocation == '/login';
      final adminRoute = state.matchedLocation == '/admin' ||
          state.matchedLocation.startsWith('/item/edit') ||
          state.matchedLocation == '/item/new';

      if (!isLoggedIn && adminRoute) {
        return '/login';
      }
      if (isLoggedIn && loggingIn) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ItemsListScreen(),
      ),
      GoRoute(
        path: '/item/new',
        builder: (context, state) => const ItemEditScreen(),
      ),
      GoRoute(
        path: '/item/:id',
        builder: (context, state) => ItemViewScreen(
          itemId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/item/edit/:id',
        builder: (context, state) => ItemEditScreen(
          itemId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminScreen(),
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
