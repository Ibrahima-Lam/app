import 'package:app/models/sponsor.dart';
import 'package:app/widget/sponsor_widget.dart';
import 'package:flutter/material.dart';

class SponsorListWidget extends StatelessWidget {
  SponsorListWidget({super.key});
  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 0);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      radius: Radius.circular(10),
      controller: scrollController,
      child: Container(
        constraints: BoxConstraints(maxHeight: 360),
        padding: EdgeInsets.symmetric(vertical: 5),
        width: MediaQuery.sizeOf(context).width,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                    3,
                    (index) => Sponsor(
                        idSponsor: '',
                        imageUrl: '',
                        description:
                            'Hello flutter i am right now coding on flutter framework i found it more special so good,'
                            ' i try to use for  the best project in my life '))
                .map(
                  (e) => SponsorWidget(sponsor: e),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
