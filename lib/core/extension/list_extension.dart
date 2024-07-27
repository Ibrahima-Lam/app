extension ListExtension<T> on List {
  T? singleWhereOrNull<T>(
    bool Function(T element) text, {
    T Function()? orElse,
    T Function()? orElseOrElse,
  }) {
    try {
      return this.singleWhere(
        (a) => text(a),
        orElse: orElse != null ? () => orElse() : null,
      );
    } catch (e) {
      return orElseOrElse != null ? orElseOrElse() : null;
    }
  }
}

extension ListStringExtension on List<String> {
  bool get hasOneEmpty {
    for (var element in this) {
      if (element.isEmpty) return true;
    }
    return false;
  }
}
