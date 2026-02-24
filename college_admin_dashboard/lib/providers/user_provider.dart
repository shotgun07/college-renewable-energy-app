import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:flutter_riverpod/legacy.dart' as riverpod
    show StateNotifierProvider;
// ignore: depend_on_referenced_packages
import 'package:state_notifier/state_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';
import '../repositories/user_repository.dart';

// Pagination State State Helper
class UserState {
  final List<AppUser> users;
  final DocumentSnapshot? lastDoc;
  final bool hasMore;
  final bool isLoadingMore;

  const UserState({
    this.users = const [],
    this.lastDoc,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  UserState copyWith({
    List<AppUser>? users,
    DocumentSnapshot? lastDoc,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return UserState(
      users: users ?? this.users,
      lastDoc: lastDoc ?? this.lastDoc,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

// Repository Provider
final userRepositoryProvider = riverpod.Provider<UserRepository>((ref) {
  return UserRepositoryImpl();
});

// User Pagination Provider
final userProvider = riverpod.StateNotifierProvider<UserNotifier,
    riverpod.AsyncValue<UserState>>((ref) {
  return UserNotifier(ref.watch(userRepositoryProvider));
});

class UserNotifier extends StateNotifier<riverpod.AsyncValue<UserState>> {
  final UserRepository _repository;
  final int _limit = 20;

  UserNotifier(this._repository) : super(const riverpod.AsyncValue.loading()) {
    fetchFirstPage();
  }

  Future<void> fetchFirstPage({String? roleFilter}) async {
    state = const riverpod.AsyncValue.loading();
    try {
      final newUsers = await _repository.getUsers(
        limit: _limit,
        roleFilter: roleFilter,
      );

      state = riverpod.AsyncValue.data(UserState(
        users: newUsers,
        lastDoc: newUsers.isNotEmpty
            ? null
            : null, // We need the actual doc snapshot...
        // Logic gap: Repository returns List<AppUser>, but we need the Snapshot for pagination.
        // We need to fetch Snapshots internally or update Repository to return wrapper.
        // Or simpler: The repository implementation can query fetching logic.
        // Let's assume for now we use the ID to get snapshot or modify repository to return lastDoc.
        // MODIFYING REPOSITORY IS BETTER.
        hasMore: newUsers.length >= _limit,
      ));

      // We actually need the document snapshot. Since AppUser only has data,
      // I need to change UserRepository to return a Helper Result or get the doc in the implementation.
      // Or I can query the doc by ID since I have it. (Extra read, but clean).
      // BETTER: Update UserRepository to return `PaginatedResult`.
    } catch (e, st) {
      state = riverpod.AsyncValue.error(e, st);
    }
  }

  Future<void> loadNextPage({String? roleFilter}) async {
    final currentState = state.value;
    if (currentState == null ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    // Set loading more
    state =
        riverpod.AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      // Get last doc reference from Firestore using the ID of the last user
      // This is a workaround to avoid passing DocumentSnapshot through Domain entities boundaries if we were strict.
      // But here we are in dashboard which is less strict.
      // Let's get the doc snapshot.
      final lastUserId = currentState.users.last.uid;
      final lastDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(lastUserId)
          .get();

      final newUsers = await _repository.getUsers(
        limit: _limit,
        startAfterDocument: lastDoc,
        roleFilter: roleFilter,
      );

      state = riverpod.AsyncValue.data(currentState.copyWith(
        users: [...currentState.users, ...newUsers],
        hasMore: newUsers.length >= _limit,
        isLoadingMore: false,
      ));
    } catch (e) {
      // If error on next page, just stop loading more but keep data
      state =
          riverpod.AsyncValue.data(currentState.copyWith(isLoadingMore: false));
      // Log error for debugging
      debugPrint('Error loading next page: $e');
    }
  }
}
