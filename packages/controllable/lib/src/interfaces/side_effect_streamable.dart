abstract class SideEffectStreamable<TEffect> {
  Stream<TEffect> get effectStream;
}
