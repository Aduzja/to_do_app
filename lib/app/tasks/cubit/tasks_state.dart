part of 'tasks_cubit.dart';

@immutable
class TasksState {
  final List<QueryDocumentSnapshot<Object?>> documents;
  final String errorMessage;

  const TasksState({
    required this.documents,
    required this.errorMessage,
  });
}
