class RateLimiter {
  final Map<String, List<DateTime>> _attempts = {};
  final int maxAttempts;
  final Duration window;

  RateLimiter({
    this.maxAttempts = 5,
    this.window = const Duration(minutes: 15),
  });

  bool canAttempt(String key) {
    final now = DateTime.now();
    final attempts = _attempts[key] ?? [];

    final validAttempts = attempts.where((attempt) {
      return now.difference(attempt) <= window;
    }).toList();

    _attempts[key] = validAttempts;

    return validAttempts.length < maxAttempts;
  }

  void recordAttempt(String key) {
    final now = DateTime.now();
    if (_attempts[key] == null) {
      _attempts[key] = [];
    }
    _attempts[key]!.add(now);
  }

  Duration? getRemainingTime(String key) {
    final attempts = _attempts[key];
    if (attempts == null || attempts.isEmpty) return null;

    final now = DateTime.now();
    final oldestAttempt = attempts.first;
    final timePassed = now.difference(oldestAttempt);

    if (timePassed >= window) return null;

    return window - timePassed;
  }
}