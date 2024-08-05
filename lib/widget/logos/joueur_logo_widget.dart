import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class JoueurImageLogoWidget extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  const JoueurImageLogoWidget({
    super.key,
    this.url,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: (url ?? '').isEmpty
            ? JoueurLogoWidget()
            : CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: url ?? '',
                errorWidget: (context, url, error) => JoueurLogoWidget()),
      ),
    );
  }
}

class JoueurLogoWidget extends StatelessWidget {
  const JoueurLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 80, maxWidth: 80),
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage('images/player.png'), fit: BoxFit.cover)),
    );
  }
}
