import 'failure.dart';

enum BaseStatus {
  initial,
  inProgress,
  success,
  failure,
}

class BaseState<T> {
  final BaseStatus status;
  final T? item;
  final Failure? failure;

  BaseState<T> setInitialState() => BaseState<T>(
        status: BaseStatus.initial,
      );

  BaseState<T> setInProgressState() => BaseState<T>(
        status: BaseStatus.inProgress,
      );
  BaseState<T> setSuccessState(T item) =>
      BaseState<T>(status: BaseStatus.success, item: item);

  BaseState<T> setFailureState(Failure failure) =>
      BaseState<T>(status: BaseStatus.failure, failure: failure);

  bool get isInProgress => status == BaseStatus.inProgress;

  bool get isFailure => status == BaseStatus.failure;

  bool get isSuccess => status == BaseStatus.success;

  const BaseState({
    this.status = BaseStatus.initial,
    this.item,
    this.failure,
  });

  BaseState<T> copyWith({
    BaseStatus? status,
    T? item,
    Failure? failure,
  }) {
    return BaseState<T>(
      status: status ?? this.status,
      item: item ?? this.item,
      failure: failure ?? this.failure,
    );
  }
}
