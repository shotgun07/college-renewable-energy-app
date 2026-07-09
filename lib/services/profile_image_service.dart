import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ProfileImageService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Picks an image from the gallery.
  Future<XFile?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 60,
        maxWidth: 300,
      );
      return image;
    } catch (e) {
      if (kDebugMode) debugPrint('Error picking image: $e');
      return null;
    }
  }

  /// Uploads a profile image to Firebase Storage and updates Firestore.
  Future<String?> uploadProfileImage(String uid, File file) async {
    try {
      // Try Firebase Storage first
      String downloadUrl;
      try {
        final Reference ref = _storage.ref().child('profile_images').child('$uid.jpg');
        final UploadTask uploadTask = ref.putFile(file);
        final TaskSnapshot snapshot = await uploadTask;
        downloadUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        // Fallback: If Firebase Storage fails (e.g. not setup, missing rules), encode to base64
        if (kDebugMode) debugPrint('Firebase Storage upload failed, falling back to base64: $e');
        final bytes = await file.readAsBytes();
        final base64String = base64Encode(bytes);
        downloadUrl = 'data:image/jpeg;base64,$base64String';
      }

      // Update the user document in Firestore
      await _firestore.collection('users').doc(uid).update({
        'profileImageUrl': downloadUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return downloadUrl;
    } catch (e) {
      if (kDebugMode) debugPrint('Error uploading profile image: $e');
      throw Exception('فشل رفع الصورة: $e');
    }
  }
}
