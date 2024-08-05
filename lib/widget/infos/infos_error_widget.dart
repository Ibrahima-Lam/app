import 'package:flutter/material.dart';

class InfosErrorWidget extends StatelessWidget {
  const InfosErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.medium1,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              'images/infos.jpg',
            ),
            fit: BoxFit.cover),
      ),
    );
  }
}
