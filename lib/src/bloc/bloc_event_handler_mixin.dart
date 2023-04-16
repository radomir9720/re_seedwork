import 'package:bloc/bloc.dart';
import 'package:re_seedwork/re_seedwork.dart';

typedef StateBuilder<State> = State Function();

mixin BlocEventHandlerMixin<Event extends EffectEvent, State>
    on Bloc<Event, State> {
  Future<void> handle<ActionResult>({
    required Event event,
    required Emitter<State> emit,
    required StateBuilder<State> inLoading,
    required StateBuilder<State> inFailure,
    required Future<ActionResult> Function() action,
    required Future<State> Function(ActionResult actionResult) onActionResult,
  }) async {
    emit(inLoading());

    try {
      final res = await action();

      emit(await onActionResult(res));
    } on Object catch (_) {
      emit(inFailure());

      rethrow;
    }
  }
}
