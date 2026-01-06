import 'package:equatable/equatable.dart';

import '../../models/user_model.dart';


abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;

  const LoginSuccess(this.user);
  @override
  List<Object> get props => [user];
}

class LoginFailure extends LoginState {
  final String error;
  const LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}
