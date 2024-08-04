import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArbitreImageLogoWidget extends StatelessWidget {
  final String? url;
  final String? image;
  final double? radius;
  final double? size;
  final bool noColor;

  final MaterialColor? backgroundColor;
  final MaterialColor? color;
  const ArbitreImageLogoWidget({
    super.key,
    this.url,
    this.image,
    this.radius,
    this.size,
    this.backgroundColor,
    this.color,
    this.noColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url ?? '',
      errorWidget: (context, url, error) => ''.isEmpty
          ? Container(
              constraints: BoxConstraints(maxHeight: 80, maxWidth: 80),
              decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.white, Colors.grey, Colors.green],
                  ),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('images/arbitre.jpg'),
                      fit: BoxFit.cover)),
            )
          : CircleAvatar(
              backgroundColor:
                  noColor ? null : backgroundColor ?? Color(0xFFDCDCDC),
              radius: radius ?? 25,
              child: Icon(
                color: noColor ? null : color ?? Colors.white,
                Icons.person,
                size: size ?? 30,
              )),
    );
  }
}
