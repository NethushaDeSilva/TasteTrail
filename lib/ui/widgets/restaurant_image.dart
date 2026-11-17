import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RestaurantImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final String? heroTag;

  const RestaurantImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colours = Theme.of(context).colorScheme;

    final Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,

      placeholder: (context, url) => Container(
        height: height,
        color: colours.surfaceContainerHighest,
        child: const Center(child: CircularProgressIndicator()),
      ),

      errorWidget: (context, url, error) => Container(
        height: height,
        color: colours.surfaceContainerHighest,
        child: Icon(
          Icons.restaurant,
          size: 40,
          color: colours.onSurfaceVariant,
        ),
      ),
    );

    if (heroTag == null) {
      return image;
    }

    return Hero(tag: heroTag!, child: image);
  }
}
