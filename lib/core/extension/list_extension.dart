extension ListExtension on List {
  List unique<T>(T Function(dynamic) f, bool Function(dynamic) g) {
    return this.where(g).toList();
  }
}
