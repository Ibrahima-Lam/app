import 'package:app/models/stat.dart';
import 'package:app/pages/equipe/equipe_details.dart';
import 'package:app/widget/logos/equipe_logo_widget.dart';
import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  final List<Stat> stats;
  final bool expand;
  final List<String>? targets;
  TableWidget(
      {super.key, required this.stats, this.expand = true, this.targets});
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
          minWidth: MediaQuery.sizeOf(context).width * .90,
        ),
        child: DataTable(
          horizontalMargin: 0,
          columnSpacing: expand ? 6 : 30,
          columns: cols
              .map((e) => DataColumn(
                    label: Text(e),
                  ))
              .toList(),
          rows: stats
              .map((e) => DataRow(
                      color: targets != null && targets!.contains(e.id)
                          ? WidgetStatePropertyAll(
                              const Color.fromARGB(255, 213, 254, 254))
                          : null,
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey,
                                      )),
                                  child: Center(
                                    child: Text(
                                      e.num.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  )),
                              SizedBox(
                                child: e.playing
                                    ? const Icon(
                                        Icons.circle,
                                        color: Colors.green,
                                        size: 10,
                                      )
                                    : null,
                              )
                            ],
                          ),
                        ),
                        DataCell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EquipeDetails(id: e.id))),
                            Container(
                              constraints: const BoxConstraints(minWidth: 100),
                              child: Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      height: 35,
                                      width: 35,
                                      child: EquipeImageLogoWidget(
                                        url: e.imageUrl,
                                      )),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        e.nom,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Row(
                                        children: e.res
                                            .split('')
                                            .reversed
                                            .take(5)
                                            .toList()
                                            .reversed
                                            .map((res) => Container(
                                                  width: 10,
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 1),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 1,
                                                      horizontal: 2),
                                                  decoration: BoxDecoration(
                                                    color: res == 'v'
                                                        ? Colors.green
                                                        : res == 'n'
                                                            ? Colors.grey
                                                            : Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                  ),
                                                  child: Text(
                                                    res.toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                            )),
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
