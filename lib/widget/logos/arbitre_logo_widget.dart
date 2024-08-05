import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArbitreImageLogoWidget extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;

  const ArbitreImageLogoWidget({
    super.key,
    this.url,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: width,
        height: height,
        child: (url ?? '').isEmpty
            ? ArbitreLogoWidget()
            : CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: url ?? '',
                errorWidget: (context, url, error) => ArbitreLogoWidget(),
              ),
      ),
    );
  }
}

class ArbitreLogoWidget extends StatelessWidget {
  const ArbitreLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage('images/arbitre.jpg'), fit: BoxFit.cover)),
    );
  }
}
