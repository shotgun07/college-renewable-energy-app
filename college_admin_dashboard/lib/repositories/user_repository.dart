import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

abstract class UserRepository {
  Future<List<AppUser>> getUsers({
    required int limit,
    DocumentSnapshot? startAfterDocument,
    String? roleFilter,
  });
}

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<AppUser>> getUsers({
    required int limit,
    DocumentSnapshot? startAfterDocument,
    String? roleFilter,
  }) async {
    Query query =
        _firestore.collection('users').orderBy('createdAt', descending: true);

    if (roleFilter != null && roleFilter != 'الكل') {
      // Note: This requires a composite index on (role, createdAt)
      query = _firestore
          .collection('users')
          .where('role', isEqualTo: roleFilter)
          .orderBy('createdAt', descending: true);
    }

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    final snapshot = await query.limit(limit).get();

    return snapshot.docs.map((doc) {
      return AppUser.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
