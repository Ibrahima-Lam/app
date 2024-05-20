import 'package:app/models/stat.dart';
import 'package:app/pages/equipe/equipe_details.dart';
import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  final List<Stat> stats;
  final bool expand;
  TableWidget({super.key, required this.stats, this.expand = true});
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
      child: DataTable(
        horizontalMargin: 0,
        columnSpacing: expand ? 10 : 40,
        columns: cols
            .map((e) => DataColumn(
                  label: Text(e),
                ))
            .toList(),
        rows: stats
            .map((e) => DataRow(cells: [
                  DataCell(
                    Row(
                      children: [
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text(e.num.toString())),
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
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EquipeDetails(id: e.id))),
                      Container(
                        constraints: const BoxConstraints(minWidth: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              e.nom,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: e.res
                                  .split('')
                                  .map((res) => Container(
                                        width: 10,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 1),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1, horizontal: 2),
                                        decoration: BoxDecoration(
                                          color: res == 'v'
                                              ? Colors.green
                                              : res == 'n'
                                                  ? Colors.grey
                                                  : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(2),
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
                      )),
                  DataCell(Text(e.nm.toString())),
                  DataCell(
                    Text(e.pts.toString()),
                  ),
                  DataCell(
                      Text(e.diff >= 0 ? '+${e.diff}' : e.diff.toString())),
                  if (expand) DataCell(Text(e.bm.toString())),
                  if (expand) DataCell(Text(e.be.toString())),
                  if (expand) DataCell(Text(e.nv.toString())),
                  if (expand) DataCell(Text(e.nn.toString())),
                  if (expand) DataCell(Text(e.nd.toString())),
                ]))
            .toList(),
      ),
    );
  }
}
