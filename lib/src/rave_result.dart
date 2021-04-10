import 'package:equatable/equatable.dart';

class RaveResult extends Equatable {
  /// The status of the transaction. Whether
  ///
  /// [RaveStatus.success] for when the transaction completes successfully,
  ///
  /// [RaveStatus.error] for when the transaction completes with an error,
  ///
  /// [RaveStatus.cancelled] for when the user cancelled
  final RaveStatus status;

  /// Raw response from rave. Can be null
  final Map? rawResponse;

  /// Human readable message
  final String? message;

  RaveResult({required this.status, this.rawResponse, this.message});

  @override
  String toString() {
    return 'RaveResult{status: $status, rawResponse: $rawResponse, message: $message}';
  }

  @override
  List<Object?> get props => [status, rawResponse, message];
}

enum RaveStatus { success, error, cancelled }
