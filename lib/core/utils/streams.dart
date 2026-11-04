import 'dart:async';

/// Emits [combiner] of the latest values once all three streams have emitted
/// (tiny replacement for rxdart's `CombineLatestStream.combine3`).
Stream<R> combineLatest3<A, B, C, R>(
  Stream<A> a,
  Stream<B> b,
  Stream<C> c,
  R Function(A a, B b, C c) combiner,
) {
  late StreamController<R> controller;
  final subs = <StreamSubscription<Object?>>[];
  A? va;
  B? vb;
  C? vc;
  var ha = false, hb = false, hc = false;

  void emit() {
    if (ha && hb && hc) controller.add(combiner(va as A, vb as B, vc as C));
  }

  controller = StreamController<R>(
    onListen: () {
      subs
        ..add(a.listen((v) {
          va = v;
          ha = true;
          emit();
        }, onError: controller.addError))
        ..add(b.listen((v) {
          vb = v;
          hb = true;
          emit();
        }, onError: controller.addError))
        ..add(c.listen((v) {
          vc = v;
          hc = true;
          emit();
        }, onError: controller.addError));
    },
    onPause: () {
      for (final s in subs) {
        s.pause();
      }
    },
    onResume: () {
      for (final s in subs) {
        s.resume();
      }
    },
    onCancel: () async {
      for (final s in subs) {
        await s.cancel();
      }
    },
  );
  return controller.stream;
}
