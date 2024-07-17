import 'package:app/core/enums/enums.dart';
import 'package:app/models/stat.dart';
import 'package:app/pages/equipe/equipe_details.dart';
import 'package:app/widget/logos/equipe_logo_widget.dart';
import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  final List<Stat> stats;
  final bool expand;
  final List<String>? targets;
  final int success;
  final int primary;
  final int warning;
  final int danger;
  TableWidget(
      {super.key,
      required this.stats,
      this.expand = true,
      this.targets,
      this.success = 0,
      this.danger = 0,
      this.primary = 0,
      this.warning = 0});
  List<String> get cols => [
        'N.',
        'Equipe',
        'J',
        'Pts',
        '+/-',
        if (expand) 'BM',
        if (expand) 'BE',
        if (expand) 'V',
        if (expand) 'N',
        if (expand) 'D',
      ];

  DataCell dataCellWidget(BuildContext context,
      {required String text, required String id}) {
    return DataCell(
        Text(
          text,
        ),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EquipeDetails(id: id))));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.sizeOf(context).width * .95,
        ),
        child: DataTable(
          dataRowMaxHeight: 55,
          horizontalMargin: 0,
          columnSpacing: expand ? 6 : 6,
          columns: cols
              .map((e) => DataColumn(
                    label: Text(e),
                  ))
              .toList(),
          rows: stats
              .map((e) => DataRow(
                      color: targets != null && targets!.contains(e.id)
                          ? WidgetStatePropertyAll(
                              Color.fromARGB(255, 240, 249, 241))
                          : null,
                      cells: [
                        DataCell(NumeroWdget(
                            stat: e,
                            length: stats.length,
                            success: success,
                            danger: danger,
                            primary: primary,
                            warning: warning)),
                        DataCell(
                          NomWidget(stat: e),
                        ),
                        DataCell(Text(e.nm.toString())),
                        DataCell(
                          Text(e.pts.toString()),
                        ),
                        DataCell(Text(
                            e.diff >= 0 ? '+${e.diff}' : e.diff.toString())),
                        if (expand) DataCell(Text(e.bm.toString())),
                        if (expand) DataCell(Text(e.be.toString())),
                        if (expand) DataCell(Text(e.nv.toString())),
                        if (expand) DataCell(Text(e.nn.toString())),
                        if (expand) DataCell(Text(e.nd.toString())),
                      ]))
              .toList(),
        ),
      ),
    );
  }
}

class NomWidget extends StatelessWidget {
  final Stat stat;
  const NomWidget({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EquipeDetails(id: stat.id))),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.symmetric(vertical: 3),
                height: 35,
                width: 35,
                child: EquipeImageLogoWidget(
                  url: stat.imageUrl,
                )),
            const SizedBox(width: 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  stat.nom,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: stat.res
                      .split('')
                      .reversed
                      .take(5)
                      .toList()
                      .reversed
                      .map((res) => Container(
                            width: 10,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            padding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 2),
                            decoration: BoxDecoration(
                              color: res == 'v'
                                  ? Colors.green
                                  : res == 'n'
                                      ? Colors.grey
                                      : Colors.red,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              res.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NumeroWdget extends StatelessWidget {
  final Stat stat;
  final int length;
  final int success;
  final int danger;
  final int primary;
  final int warning;
  const NumeroWdget(
      {super.key,
      required this.stat,
      required this.length,
      required this.success,
      required this.danger,
      required this.primary,
      required this.warning});
  Color? indexColor(Stat stat) {
    if (stat.level == ClassementType.success) return Colors.green;
    if (stat.level == ClassementType.primary) return Colors.blue;
    if (stat.level == ClassementType.infos)
      return Color.fromARGB(255, 118, 205, 234);
    if (stat.level == ClassementType.warnning) return Colors.yellow;
    if (stat.level == ClassementType.orange) return Colors.orange;
    if (stat.level == ClassementType.danger) return Colors.red;

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
          height: 30,
          width: 40,
          child: Center(
            child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    color: indexColor(stat),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                    )),
                child: Center(
                  child: Text(
                    stat.num.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        color: indexColor(stat) == null
                            ? Colors.black
                            : Colors.white),
                  ),
                )),
          ),
        ),
        SizedBox(
          child: stat.playing
              ? const Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 10,
                )
              : null,
        )
      ],
    );
  }
}
