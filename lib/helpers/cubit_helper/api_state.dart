part of 'api_cubit.dart';

sealed class ApiState {}

final class ApiInitial extends ApiState {}
final class LoadingState extends ApiState {}
final class SuccessState extends ApiState {}
final class ErrorState extends ApiState {
  final String error ;
  ErrorState( this.error);
}
