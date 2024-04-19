abstract class FutureUseCase<T, R> {
  Future<R> invoke(T? parameter);
}

abstract class FutureUseCase0<R> {
  Future<R> invoke();
}

abstract class StreamUseCase<T, R> {
  Stream<R> invoke(T parameter);
}

abstract class StreamUseCase0<R> {
  Stream<R> invoke();
}
