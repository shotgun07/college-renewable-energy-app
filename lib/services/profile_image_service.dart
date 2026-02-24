import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/utils/image_compressor.dart';

class ProfileImageService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<XFile?> pickImage() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 512,
    );
  }

  Future<String?> uploadProfileImage(String uid, File imageFile) async {
    try {
      // Compress image
      final File compressedFile = await ImageCompressor.compressFile(imageFile);

      final ref = _storage.ref().child('profile_images').child('$uid.jpg');
      await ref.putFile(compressedFile);
      final url = await ref.getDownloadURL();

      await _firestore.collection('users').doc(uid).update({
        'profileImageUrl': url,
      });

      return url;
    } catch (e) {
      return null;
    }
  }
}
