import 'package:equatable/equatable.dart';

/// API Response Model
class ApiResponse<T> extends Equatable {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const ApiResponse({required this.success, this.message, this.data, this.statusCode, this.errors});

  factory ApiResponse.success({T? data, String? message, int? statusCode}) {
    return ApiResponse(success: true, data: data, message: message, statusCode: statusCode ?? 200);
  }

  factory ApiResponse.error({String? message, int? statusCode, Map<String, dynamic>? errors}) {
    return ApiResponse(success: false, message: message, statusCode: statusCode, errors: errors);
  }

  bool get isSuccess => success;
  bool get isError => !success;
  bool get hasData => data != null;
  bool get hasErrors => errors != null && errors!.isNotEmpty;

  @override
  List<Object?> get props => [success, message, data, statusCode, errors];
}
