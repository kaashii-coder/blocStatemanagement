part of 'todo_bloc.dart';

class TodoState {}

final class TodoInitial extends TodoState {}

final class TodoLoading extends TodoState {}

final class TodoLoded extends TodoState {
  final List todoList;

  TodoLoded({required this.todoList});
}

final class TodoError extends TodoState {
  final String error;

  TodoError({required this.error});

}
