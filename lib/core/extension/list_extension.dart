extension ListExtension<T> on List {
  T? singleWhereOrNull<T>(
    bool Function(T e) f, {
    T Function()? orElse,
  }) {
    try {
      return this.singleWhere(
        (a) => f(a),
        orElse: orElse != null ? () => orElse() : null,
      );
    } catch (e) {
      return null;
    }
  }
}
