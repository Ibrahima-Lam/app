import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CoachImageLogoWidget extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  const CoachImageLogoWidget({
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
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: (url ?? '').isEmpty
            ? CoachLogoWidget()
            : CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: url ?? '',
                errorWidget: (context, url, error) => CoachLogoWidget(),
              ),
      ),
    );
  }
}

class CoachLogoWidget extends StatelessWidget {
  const CoachLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 80, maxWidth: 80),
      decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.white, Colors.grey, Colors.lightBlueAccent],
          ),
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage('images/coach.jpg'), fit: BoxFit.cover)),
    );
  }
}
