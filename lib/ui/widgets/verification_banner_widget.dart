import 'package:app/presentation/pages/auth/verification_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/verification_reminder_service.dart';
import '../../presentation/providers/auth_provider.dart';

/// Banner widget to remind unverified users to verify their email
class VerificationBannerWidget extends ConsumerStatefulWidget {
  final String userId;

  const VerificationBannerWidget({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<VerificationBannerWidget> createState() =>
      _VerificationBannerWidgetState();
}

class _VerificationBannerWidgetState
    extends ConsumerState<VerificationBannerWidget> {
  final _reminderService = VerificationReminderService();
  bool _showBanner = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkShouldShow();
  }

  Future<void> _checkShouldShow() async {
    // Check if reminder should be shown based on dismissal history
    final shouldShow = await _reminderService.shouldShowReminder(widget.userId);

    if (mounted) {
      setState(() {
        _showBanner = shouldShow;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleDismiss() async {
    await _reminderService.dismissReminder(widget.userId);
    if (!mounted) return;
    setState(() {
      _showBanner = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم تذكيرك لاحقاً للتحقق من حسابك'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToCodeVerification() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const VerificationCodeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVerified = ref.watch(isUserVerifiedProvider);

    if (isVerified) return const SizedBox.shrink();

    // If loading or decided not to show (via dismissal logic)
    if (_isLoading || !_showBanner) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange,
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'الحساب غير موثق',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: _handleDismiss,
                tooltip: 'إخفاء',
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'يرجى إدخال رمز التحقق الذي حصلت عليه من الإدارة لتفعيل حسابك بالكامل.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _handleDismiss,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: const Text('تذكير لاحقاً'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _navigateToCodeVerification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFFF6B35),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                icon: const Icon(Icons.verified_user),
                label: const Text(
                  'إدخال الرمز',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
