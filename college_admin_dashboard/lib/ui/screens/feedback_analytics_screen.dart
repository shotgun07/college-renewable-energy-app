import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/providers/feedback_provider.dart';

class FeedbackAnalyticsScreen extends ConsumerWidget {
  const FeedbackAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedbackAsync = ref.watch(feedbackProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تحليلات التقييمات والاستبيانات'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      backgroundColor: const Color(0xFF0F172A),
      body: feedbackAsync.when(
        data: (feedbacks) {
          if (feedbacks.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد تقييمات حتى الآن',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          final double averageRating =
              feedbacks.map((e) => e.rating).reduce((a, b) => a + b) /
                  feedbacks.length;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(averageRating, feedbacks.length),
                const SizedBox(height: 24),
                const Text(
                  'أحدث التقييمات والملاحظات:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: feedbacks.length,
                    itemBuilder: (context, index) {
                      final f = feedbacks[index];
                      return Card(
                        color: Colors.white.withValues(alpha: 0.05),
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(f.studentName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Row(
                                children: List.generate(
                                  5,
                                  (starIndex) => Icon(
                                    starIndex < f.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${f.department.displayName} - ${DateFormat('yyyy/MM/dd hh:mm a').format(f.submittedAt)}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.blueAccent),
                              ),
                              if (f.comment.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    f.comment,
                                    style: const TextStyle(
                                        color: Colors.white70),
                                  ),
                                )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('خطأ في تحميل البيانات: $err',
              style: const TextStyle(color: Colors.redAccent)),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(double avg, int total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF42A5F5)]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text('متوسط التقييم',
                  style: TextStyle(color: Colors.white70, fontSize: 16)),
              Text(
                avg.toStringAsFixed(1),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: List.generate(
                    5,
                    (index) => Icon(
                          index < avg.round() ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        )),
              )
            ],
          ),
          Container(width: 1, height: 50, color: Colors.white30),
          Column(
            children: [
              const Text('إجمالي الآراء',
                  style: TextStyle(color: Colors.white70, fontSize: 16)),
              Text(
                total.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
