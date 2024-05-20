import 'package:app/models/composition.dart';
import 'package:flutter/material.dart';

class CompositionBottomSheetWidget extends StatelessWidget {
  final List<JoueurComposition> compositions;
  const CompositionBottomSheetWidget({super.key, required this.compositions});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      builder: (context, scrollController) {
        return ListView.builder(
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
