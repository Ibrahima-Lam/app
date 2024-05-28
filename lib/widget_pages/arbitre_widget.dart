import 'package:app/collection/composition_collection.dart';
import 'package:app/models/composition.dart';
import 'package:flutter/material.dart';

class ArbitreWidget extends StatefulWidget {
  final CompositionSousCollection compositionSousCollection;
  final Function(ArbitreComposition)? onDoubleTap;
  const ArbitreWidget(
      {super.key, required this.compositionSousCollection, this.onDoubleTap});

  @override
  State<ArbitreWidget> createState() => _ArbitreWidgetState();
}

class _ArbitreWidgetState extends State<ArbitreWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: MediaQuery.sizeOf(context).width,
            color: Color(0xFFDCDCDC),
            child: const Text(
              'Les Arbitres',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Column(
            children: widget.compositionSousCollection.arbitres
                .map((e) => ArbitreListTileWidget(
                      composition: e,
                      onDoubleTap: widget.onDoubleTap == null
                          ? null
                          : (p) async {
                              await widget.onDoubleTap!(p);
                              setState(() {});
                            },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class ArbitreListTileWidget extends StatelessWidget {
  final ArbitreComposition composition;
  final Function(ArbitreComposition)? onDoubleTap;
  const ArbitreListTileWidget(
      {super.key, required this.composition, this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap == null ? null : () => onDoubleTap!(composition),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFDCDCDC),
          foregroundColor: Colors.white,
          child: Icon(Icons.person),
        ),
        title: Text(composition.nom),
        subtitle: Text(composition.role),
        trailing: Icon(
          Icons.flag,
          color: Colors.green,
        ),
      ),
    );
  }
}
