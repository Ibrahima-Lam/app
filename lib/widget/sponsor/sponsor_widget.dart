import 'package:fscore/core/constants/app/platforme.dart';
import 'package:fscore/models/sponsor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SponsorWidget extends StatelessWidget {
  final Sponsor sponsor;
  const SponsorWidget({super.key, required this.sponsor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(5.0),
        width: MediaQuery.of(context).size.width <= 600
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * .71,
        constraints: const BoxConstraints(
          minHeight: 200,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width <= 600
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width * .71,
              height: MediaQuery.of(context).size.width <= kMaxWidth
                  ? kSmallHeight
                  : MediaQuery.of(context).size.width * kPourcentHeight,
              child: sponsor.imageUrl.isEmpty
                  ? SponsorErrorWidget()
                  : CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: sponsor.imageUrl,
                      errorWidget: (context, url, error) =>
                          SponsorErrorWidget(),
                    ),
            ),
            if (sponsor.description != null)
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    sponsor.description ?? '',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ))
          ],
        ),
      ),
    );
  }
}

class SponsorErrorWidget extends StatelessWidget {
  const SponsorErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Durations.medium1,
        child: Image.asset('images/football.jpg', fit: BoxFit.cover));
  }
}
