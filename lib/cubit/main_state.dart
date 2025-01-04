part of 'main_cubit.dart';

abstract class MainState {
  const MainState();
}

class MainInitial extends MainState {}

class MainLoading extends MainState {}

class MainError extends MainState {
  final String message;
  const MainError(this.message);
}

class MainSuccess extends MainState {}
