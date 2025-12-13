import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure({
    required this.message,
    this.statusCode,
    this.data,
  });

  final String? statusCode;
  final String message;
  final dynamic data;

  @override
  List<Object?> get props => <Object?>[statusCode, message, data];
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required super.statusCode,
    required super.message,
    super.data,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.statusCode,
    required super.message,
    super.data,
  });
}

class BadRequestFailure extends Failure {
  const BadRequestFailure({
    required super.statusCode,
    required super.message,
    super.data,
  });
}

class PlatformFailure extends Failure {
  const PlatformFailure({
    required super.statusCode,
    required super.message,
    super.data,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.statusCode,
    required super.message,
    super.data,
  });
}

class UnhandledFailure extends Failure {
  const UnhandledFailure({
    required super.statusCode,
    required super.message,
    super.data,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.statusCode = 'EX-005',
    super.message = 'Connection Timeout!',
    super.data,
  });
}

class FormattingFailure extends Failure {
  const FormattingFailure({
    super.statusCode = 'EX-001',
    super.message = 'Unexpected Data Format!',
    super.data,
  });
}

class UnimplementedFailure extends Failure {
  const UnimplementedFailure({
    super.data,
  }) : super(
          message: 'Feature Not Implemented Yet!',
          statusCode: '000',
        );
}
