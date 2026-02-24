import 'dart:async';

class LoadingStateManager<T> {
  final Duration timeout;
  final int maxRetries;

  LoadingStateManager({
    this.timeout = const Duration(seconds: 30),
    this.maxRetries = 3,
  });

  Future<LoadingResult<T>> execute(
    Future<T> Function() task, {
    Duration? customTimeout,
  }) async {
    final effectiveTimeout = customTimeout ?? timeout;

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final result = await task().timeout(
          effectiveTimeout,
          onTimeout: () {
            throw TimeoutException('العملية استغرقت وقتاً طويلاً');
          },
        );

        return LoadingResult.success(result);
      } on TimeoutException catch (e) {
        if (attempt == maxRetries - 1) {
          return LoadingResult.timeout(e.message ?? 'انتهت المهلة الزمنية');
        }
        await Future.delayed(Duration(seconds: attempt + 1));
      } catch (e) {
        if (attempt == maxRetries - 1) {
          return LoadingResult.error(_parseError(e));
        }
        
        await Future.delayed(Duration(seconds: attempt + 1));
      }
    }

    return LoadingResult.error('فشلت العملية بعد $maxRetries محاولات');
  }

  String _parseError(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('network') ||
        errorStr.contains('internet') ||
        errorStr.contains('connection')) {
      return 'لا يوجد اتصال بالإنترنت';
    }

    if (errorStr.contains('permission') || errorStr.contains('denied')) {
      return 'ليس لديك صلاحية للوصول لهذه البيانات';
    }

    if (errorStr.contains('not found') || errorStr.contains('404')) {
      return 'البيانات المطلوبة غير موجودة';
    }

    return 'حدث خطأ غير متوقع';
  }
}

class LoadingResult<T> {
  final T? data;
  final String? error;
  final LoadingStatus status;

  LoadingResult._({
    this.data,
    this.error,
    required this.status,
  });

  factory LoadingResult.success(T data) {
    return LoadingResult._(
      data: data,
      status: LoadingStatus.success,
    );
  }

  factory LoadingResult.error(String message) {
    return LoadingResult._(
      error: message,
      status: LoadingStatus.error,
    );
  }

  factory LoadingResult.timeout(String message) {
    return LoadingResult._(
      error: message,
      status: LoadingStatus.timeout,
    );
  }

  bool get isSuccess => status == LoadingStatus.success;
  bool get isError => status == LoadingStatus.error;
  bool get isTimeout => status == LoadingStatus.timeout;
}

enum LoadingStatus {
  success,
  error,
  timeout,
}
