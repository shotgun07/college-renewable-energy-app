import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';

class BulkUploadScreen extends StatefulWidget {
  const BulkUploadScreen({super.key});

  @override
  State<BulkUploadScreen> createState() => _BulkUploadScreenState();
}

class _BulkUploadScreenState extends State<BulkUploadScreen> {
  bool _isLoading = false;
  String _statusMessage = '';
  List<List<dynamic>> _csvData = [];

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        final csvString = utf8.decode(bytes);
        
        // Parse CSV
        final data = const CsvToListConverter().convert(csvString);
        
        setState(() {
          _csvData = data;
          _statusMessage = 'تم تحميل الملف بنجاح. يحتوي على ${data.length} صف (بما في ذلك العنوان).';
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في اختيار الملف: $e')),
      );
    }
  }

  Future<void> _uploadData() async {
    if (_csvData.isEmpty || _csvData.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('البيانات غير كافية للرفع.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'جاري المعالجة والرفع...';
    });

    try {
      final batch = FirebaseFirestore.instance.batch();
      final collection = FirebaseFirestore.instance.collection('student_results');

      // Assuming first row is headers: e.g. ["studentId", "courseId", "grade"]
      final headers = _csvData[0].map((e) => e.toString().trim()).toList();
      
      int successCount = 0;

      for (int i = 1; i < _csvData.length; i++) {
        final row = _csvData[i];
        if (row.isEmpty || row.length != headers.length) continue;

        Map<String, dynamic> docData = {};
        for (int j = 0; j < headers.length; j++) {
          docData[headers[j]] = row[j];
        }

        // Generate unique doc ID conditionally based on content
        final String? studentId = docData["studentId"]?.toString();
        final String? courseId = docData["courseId"]?.toString();

        if (studentId == null || courseId == null) continue;

        final docRef = collection.doc('${studentId}_$courseId');
        batch.set(docRef, docData, SetOptions(merge: true));
        successCount++;
      }

      await batch.commit();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _statusMessage = 'تم رفع $successCount سجل بنجاح!';
          _csvData = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('اكتملت عملية الرفع.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _statusMessage = 'خطأ أثناء الرفع: $e';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل الرفع: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E293B),
      appBar: AppBar(
        title: const Text('الرفع الجماعي للنتائج', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withAlpha(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_upload_outlined, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 24),
              const Text(
                'ارفع ملف CSV يحتوي على درجات الطلاب',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'يجب أن يحتوي الملف على الأعمدة (studentId, courseId, grade)',
                style: TextStyle(fontSize: 14, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator(color: Colors.blueAccent)
              else ...[
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('اختيار ملف CSV'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
                const SizedBox(height: 20),
                if (_csvData.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: _uploadData,
                    icon: const Icon(Icons.upload),
                    label: const Text('بدء الرفع إلى قاعدة البيانات'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
              ],
              const SizedBox(height: 24),
              if (_statusMessage.isNotEmpty)
                Text(
                  _statusMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
