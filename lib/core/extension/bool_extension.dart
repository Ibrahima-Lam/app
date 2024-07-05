extension ListExtension on bool {
  bool operator +(bool b) => !(this && b) && (this || b);
}
