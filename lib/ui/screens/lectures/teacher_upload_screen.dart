import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../presentation/providers/course_provider.dart';
import '../../widgets/teacher/teacher_scaffold.dart';
import '../../widgets/common/glass_components.dart';
import '../../../models/course.dart';

class TeacherUploadScreen extends ConsumerStatefulWidget {
  const TeacherUploadScreen({super.key});

  @override
  ConsumerState<TeacherUploadScreen> createState() => _TeacherUploadScreenState();
}

class _TeacherUploadScreenState extends ConsumerState<TeacherUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();

  String? _selectedCourseId;
  PlatformFile? _pickedFile;
  bool _isUploading = false;
  ResourceType _selectedType = ResourceType.pdf;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'ppt', 'pptx', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
        _urlController.clear();
      });
    }
  }

  Future<void> _upload() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCourseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار المادة')),
      );
      return;
    }

    if (_selectedType == ResourceType.pdf && _pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار ملف')),
      );
      return;
    }
    if ((_selectedType == ResourceType.video ||
            _selectedType == ResourceType.link) &&
        _urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال الرابط')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      String resourceUrl = '';

      if (_selectedType == ResourceType.pdf && _pickedFile != null) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${_pickedFile!.name}';
        final storageRef =
            FirebaseStorage.instance.ref().child('course_resources/$fileName');

        if (_pickedFile!.bytes != null) {
          final uploadTask = await storageRef.putData(_pickedFile!.bytes!);
          resourceUrl = await uploadTask.ref.getDownloadURL();
        } else {
          throw Exception('File data missing');
        }
      } else {
        resourceUrl = _urlController.text.trim();
      }

      final resource = CourseResource(
        id: '',
        title: _titleController.text.trim(),
        type: _selectedType,
        url: resourceUrl,
        date: DateTime.now(),
      );

      // Use courseRepository to add to subcollection
      await ref
          .read(courseRepositoryProvider)
          .addCourseResource(_selectedCourseId!, resource.toMap());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('تم نشر المحتوى بنجاح ✅'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      // Reset form for next upload
      _formKey.currentState?.reset();
      setState(() {
        _selectedCourseId = null;
        _pickedFile = null;
        _urlController.clear();
        _titleController.clear();
        _selectedType = ResourceType.pdf;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(coursesStreamProvider);

    return TeacherScaffold(
      title: 'إضافة محتوى تعليمي',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              coursesAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, st) => Text('خطأ: $e', style: const TextStyle(color: Colors.white)),
                data: (courses) {
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedCourseId,
                    dropdownColor: const Color(0xFF1E293B),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'اختر المادة',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    items: courses
                        .map((c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(
                                '${c.name} (${c.department}) - فصل ${c.semester}')))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCourseId = v),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: _buildRadio(ResourceType.pdf, 'ملف PDF/PPT',
                          Icons.picture_as_pdf)),
                  Expanded(
                      child: _buildRadio(
                          ResourceType.video, 'فيديو', Icons.video_library)),
                  Expanded(
                      child:
                          _buildRadio(ResourceType.link, 'رابط', Icons.link)),
                ],
              ),
              const SizedBox(height: 20),
              GlassTextField(
                controller: _titleController,
                hint: 'عنوان المحتوى',
                icon: Icons.title,
              ),
              const SizedBox(height: 20),
              if (_selectedType == ResourceType.pdf)
                InkWell(
                onTap: _pickFile,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: _pickedFile != null
                            ? Colors.greenAccent.withValues(alpha: 0.5)
                            : Colors.white30,
                        style: BorderStyle.solid,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(15),
                    color: _pickedFile != null
                        ? Colors.greenAccent.withValues(alpha: 0.05)
                        : Colors.white.withValues(alpha: 0.04)),
                  child: Column(
                    children: [
                      Icon(
                        _pickedFile != null
                            ? Icons.check_circle_outline
                            : Icons.cloud_upload_outlined,
                        size: 40,
                        color: _pickedFile != null
                            ? Colors.greenAccent
                            : Colors.white54),
                      const SizedBox(height: 10),
                      Text(
                        _pickedFile?.name ?? 'اضغط لاختيار ملف PDF/PPT/DOC',
                        style: TextStyle(
                            color: _pickedFile != null
                                ? Colors.greenAccent
                                : Colors.white70,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      if (_pickedFile != null && _pickedFile!.size > 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          'حجم الملف: ${(_pickedFile!.size / 1024 / 1024).toStringAsFixed(2)} MB',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 11),
                        ),
                      ],
                    ],
                  ),
                ),
              )
              else
                GlassTextField(
                  controller: _urlController,
                  hint: _selectedType == ResourceType.video
                      ? 'رابط الفيديو (YouTube)'
                      : 'الرابط الخارجي',
                  icon: Icons.link,
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isUploading ? null : _upload,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('نشر المحتوى',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadio(ResourceType type, String label, IconData icon) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: isSelected
                ? Colors.blueAccent.withValues(alpha: 0.3)
                : Colors.transparent,
            border: Border.all(
                color: isSelected ? Colors.blueAccent : Colors.white24),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.blueAccent : Colors.white54),
            const SizedBox(height: 5),
            Text(label,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white54,
                    fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
