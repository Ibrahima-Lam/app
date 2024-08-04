import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CompetitionImageLogoWidget extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  const CompetitionImageLogoWidget({
    super.key,
    this.url,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 50,
      height: height ?? 50,
      child: (url ?? '').isEmpty
          ? CompetitionLogoWidget()
          : CachedNetworkImage(
              fit: BoxFit.cover,
              errorListener: (value) {},
              imageUrl: url ?? '',
              errorWidget: (context, url, error) => CompetitionLogoWidget(),
            ),
    );
  }
}

class CompetitionLogoWidget extends StatelessWidget {
  const CompetitionLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage('images/competition.png'), fit: BoxFit.cover)),
    );
  }
}
