import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{}

class NoInternetFailure extends Failure{
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure{
  @override
  List<Object?> get props => [];
}

class InvalidUserCredentialsFailure extends Failure{
  @override
  List<Object?> get props => [];
}

class UserNotFoundFailure extends Failure{
  @override
  List<Object?> get props => [];
}