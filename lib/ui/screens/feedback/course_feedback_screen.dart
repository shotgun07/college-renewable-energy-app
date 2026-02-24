import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../presentation/providers/survey_provider.dart';
import '../../widgets/student/student_scaffold.dart';
import '../../widgets/common/glass_components.dart';

class CourseFeedbackScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String courseName;

  const CourseFeedbackScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  ConsumerState<CourseFeedbackScreen> createState() => _CourseFeedbackScreenState();
}

class _CourseFeedbackScreenState extends ConsumerState<CourseFeedbackScreen> {
  final _commentController = TextEditingController();
  int _rating = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار تقييم قبل الإرسال')),
      );
      return;
    }

    ref.read(surveyProvider.notifier).submitSurvey(
          courseId: widget.courseId,
          courseName: widget.courseName,
          rating: _rating,
          comments: _commentController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(surveyProvider, (prev, next) {
      next.when(
        data: (_) {
          if (prev is AsyncLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إرسال التقييم بنجاح، شكراً لك!')),
            );
            Navigator.of(context).pop();
          }
        },
        error: (err, st) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ: $err')),
          );
        },
        loading: () {},
      );
    });

    final isLoading = ref.watch(surveyProvider) is AsyncLoading;

    return StudentScaffold(
      title: 'تقييم المادة',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.feedback_rounded, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 20),
            Text(
              widget.courseName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'رأيك يهمنا لتحسين جودة التعليم',
              style: TextStyle(fontSize: 14, color: Colors.white60),
            ),
            const SizedBox(height: 40),
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'التقييم العام',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starValue = index + 1;
                      return IconButton(
                        iconSize: 40,
                        icon: Icon(
                          starValue <= _rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: Colors.amber,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                setState(() {
                                  _rating = starValue;
                                });
                              },
                      );
                    }),
                  ),
                  const SizedBox(height: 30),
                  GlassTextField(
                    controller: _commentController,
                    hint: 'ملاحظات إضافية (اختياري)',
                    icon: Icons.comment,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'إرسال التقييم',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
