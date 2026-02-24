import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/utils/rate_limiter.dart';

void main() {
  group('RateLimiter', () {
    late RateLimiter rateLimiter;

    setUp(() {
      rateLimiter = RateLimiter(maxAttempts: 3, window: const Duration(minutes: 1));
    });

    test('allows attempts within limit', () {
      const key = 'test@example.com';

      expect(rateLimiter.canAttempt(key), true);
      rateLimiter.recordAttempt(key);
      expect(rateLimiter.canAttempt(key), true);
      rateLimiter.recordAttempt(key);
      expect(rateLimiter.canAttempt(key), true);
    });

    test('blocks attempts after exceeding limit', () {
      const key = 'test@example.com';

      rateLimiter.recordAttempt(key);
      rateLimiter.recordAttempt(key);
      rateLimiter.recordAttempt(key);
      expect(rateLimiter.canAttempt(key), false);
    });

    test('resets after window expires', () async {
      const key = 'test@example.com';

      rateLimiter.recordAttempt(key);
      rateLimiter.recordAttempt(key);
      rateLimiter.recordAttempt(key);
      expect(rateLimiter.canAttempt(key), false);

      // Wait for window to expire (simulate)
      await Future.delayed(const Duration(minutes: 1, seconds: 1));

      expect(rateLimiter.canAttempt(key), true);
    });

    test('calculates remaining time correctly', () {
      const key = 'test@example.com';

      rateLimiter.recordAttempt(key);
      rateLimiter.recordAttempt(key);
      rateLimiter.recordAttempt(key);

      final remainingTime = rateLimiter.getRemainingTime(key);
      expect(remainingTime, isNotNull);
      expect(remainingTime!.inMinutes, lessThanOrEqualTo(1));
    });
  });
}