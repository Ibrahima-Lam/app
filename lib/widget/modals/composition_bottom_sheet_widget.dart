import 'package:fscore/models/composition.dart';
import 'package:flutter/material.dart';

class CompositionBottomSheetWidget extends StatelessWidget {
  final List<JoueurComposition> compositions;
  const CompositionBottomSheetWidget({super.key, required this.compositions});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      builder: (context, scrollController) {
        return compositions.isEmpty
            ? const Center(
                child: Text('Pas de remplaçant disponible pour cette équipe!'))
            : ListView.builder(
                itemCount: compositions.length,
                itemBuilder: (context, index) {
                  JoueurComposition compos = compositions[index];
                  return ListTile(
                    onTap: () {
                      Navigator.pop(context, compos);
                    },
                    title: Text(compos.nom),
                  );
                },
              );
      },
    );
  }
}
