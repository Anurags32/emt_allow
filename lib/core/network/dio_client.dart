import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../storage/secure_storage_service.dart';

final dioClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectionTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add logging interceptor for debugging (only in debug mode)
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint('[DIO] $obj'),
      ),
    );
  }

  // Add interceptor for auth token
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final storage = ref.read(secureStorageServiceProvider);
        final token = await storage.getToken();
        if (token != null && token.isNotEmpty) {
          // API expects Bearer token in Authorization header
          options.headers['Authorization'] = 'Bearer $token';
          if (kDebugMode) {
            debugPrint('[DIO] Adding Bearer token to request');
          }
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        // Handle errors globally
        if (kDebugMode) {
          debugPrint('[DIO ERROR] ${error.message}');
          if (error.response != null) {
            debugPrint('[DIO ERROR RESPONSE] ${error.response?.data}');
          }
        }
        return handler.next(error);
      },
    ),
  );

  return dio;
});
