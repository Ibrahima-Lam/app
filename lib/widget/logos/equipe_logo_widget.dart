import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EquipeImageLogoWidget extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final bool isCircle;

  const EquipeImageLogoWidget({
    super.key,
    this.url,
    this.width,
    this.height,
    this.isCircle = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: height ?? 50,
        width: width ?? 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        ),
        child: (url ?? '').isEmpty
            ? EquipeLogoWidget()
            : CachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                imageUrl: url ?? '',
                errorWidget: (context, url, error) => EquipeLogoWidget()),
      ),
    );
  }
}

class EquipeLogoWidget extends StatelessWidget {
  const EquipeLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 80, maxWidth: 80),
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage('images/equipe3.jpg'), fit: BoxFit.cover)),
    );
  }
}
