abstract class Disposable {
  bool get isDisposed;

  Future<void> dispose();
}
