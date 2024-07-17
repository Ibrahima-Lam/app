class ClassementParams {
  int success;
  int primary;
  int infos;
  int warnning;
  int orange;
  int defaults;
  int danger;

  ClassementParams({
    this.danger = 0,
    this.defaults = 0,
    this.primary = 0,
    this.success = 0,
    this.warnning = 0,
    this.infos = 0,
    this.orange = 0,
  });

  int get total => success + primary + defaults + warnning + danger;
}
