import 'package:flutter/widgets.dart';

class Nil extends Widget {
  const Nil({Key? key}) : super(key: key);

  @override
  Element createElement() => _NilElement(this);
}

class _NilElement extends Element {
  _NilElement(Nil widget) : super(widget);

  @override
  void mount(Element? parent, Object? newSlot) {
    assert(parent is! MultiChildRenderObjectElement);

    super.mount(parent, newSlot);
  }

  @override
  bool get debugDoingBuild => false;

  @override
  void performRebuild() {}
}
