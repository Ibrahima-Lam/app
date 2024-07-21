import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final num? rating;
  final bool centered;
  const RatingWidget({super.key, required this.rating, this.centered = true});

  @override
  Widget build(BuildContext context) {
    num value = rating ?? 0;

    return Container(
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        mainAxisAlignment:
            centered ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: List.generate(5, (index) {
          int indexVal = 1 + index;
          if (indexVal <= value)
            return Icon(
              Icons.star,
              size: 15,
              color: Colors.grey,
            );
          if (value.ceil() == indexVal && value.floor() == indexVal - 1)
            return Icon(
              Icons.star_half,
              size: 15,
              color: Colors.grey,
            );
          return Icon(
            Icons.star_border,
            size: 13,
            color: Colors.grey,
          );
        }),
      ),
    );
  }
}
