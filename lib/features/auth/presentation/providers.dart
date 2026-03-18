import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final isAdminLoggedInProvider = Provider<bool>((ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  return user != null;
});
