class Stat {
  int num;
  String id;
  String nom;
  int pts;
  int nm;
  int nv;
  int nn;
  int nd;
  int diff;
  int bm;
  int be;
  String? date;
  String res;
  bool playing;
  Stat({
    this.num = 0,
    required this.id,
    required this.nom,
    this.pts = 0,
    this.nm = 0,
    this.nv = 0,
    this.nn = 0,
    this.nd = 0,
    this.diff = 0,
    this.bm = 0,
    this.be = 0,
    this.res = '',
    this.date,
    this.playing = false,
  });
  Map<String, dynamic> toJson() {
    return {
      "num": num,
      "id": id,
      "nom": nom,
      "pts": pts,
      "nm": nm,
      "nv": nv,
      "nn": nn,
      "nd": nd,
      "diff": diff,
      "bm": bm,
      "be": be,
    };
  }
}
