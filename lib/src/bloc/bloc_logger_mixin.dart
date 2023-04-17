import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

typedef BlocLoggerCallback<T> = void Function(T event);

mixin BlocLoggerMixin<T, State> on BlocBase<State> {
  @visibleForTesting
  final Set<BlocLoggerCallback<T>> loggers = {};

  void addLogger(BlocLoggerCallback<T> callback) => loggers.add(callback);

  void removeLogger(BlocLoggerCallback<T> callback) => loggers.remove(callback);

  void addLoggers(List<BlocLoggerCallback<T>> callbacks) =>
      loggers.addAll(callbacks);

  void removeLoggers(List<BlocLoggerCallback<T>> callbacks) =>
      loggers.removeAll(callbacks);

  void log(T event) {
    for (final logger in loggers) {
      logger(event);
    }
  }

  @override
  Future<void> close() {
    loggers.clear();
    return super.close();
  }
}
