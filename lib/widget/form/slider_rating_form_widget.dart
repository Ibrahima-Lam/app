import 'package:flutter/material.dart';

class SliderRatingFormWidget extends StatefulWidget {
  final TextEditingController controller;
  const SliderRatingFormWidget({super.key, required this.controller});

  @override
  State<SliderRatingFormWidget> createState() => _SliderRatingFormWidgetState();
}

class _SliderRatingFormWidgetState extends State<SliderRatingFormWidget> {
  @override
  Widget build(BuildContext context) {
    double value = double.parse(widget.controller.text) / 5;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rating ${widget.controller.text}',
              textAlign: TextAlign.center,
            ),
            Slider(
                activeColor: Colors.blue,
                label: widget.controller.text,
                value: value,
                onChanged: (val) {
                  setState(() {
                    widget.controller.text =
                        ((val * 50).roundToDouble() / 10).toString();
                  });
                }),
          ],
        ),
      ),
    );
  }
}
