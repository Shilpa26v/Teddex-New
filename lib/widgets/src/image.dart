part of '../widgets.dart';

class SquareImageFromAsset extends Image {
  SquareImageFromAsset(
    String image, {
    double size = 24,
    BoxFit fit = BoxFit.scaleDown,
    Color? color,
    bool matchTextDirection = true,
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    bool excludeFromSemantics = false,
  }) : super.asset(
          image,
          key: key,
          height: size,
          width: size,
          color: color,
          matchTextDirection: matchTextDirection,
          fit: fit,
          frameBuilder: frameBuilder,
          errorBuilder: errorBuilder,
          semanticLabel: image,
          excludeFromSemantics: excludeFromSemantics,
        );
}

class CircleImageFromAsset extends StatelessWidget {
  final String image;
  final double size;
  final BoxFit fit;
  final Color? color;
  final bool matchTextDirection;
  final ImageFrameBuilder? frameBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final String? semanticLabel;
  final bool excludeFromSemantics;

  const CircleImageFromAsset(
    this.image, {
    this.size = 24,
    this.fit = BoxFit.cover,
    this.color,
    this.matchTextDirection = true,
    this.frameBuilder,
    this.errorBuilder,
    this.excludeFromSemantics = false,
    this.semanticLabel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipBehavior: Clip.hardEdge,
      child: SquareImageFromAsset(
        image,
        size: size,
        color: color,
        matchTextDirection: matchTextDirection,
        fit: fit,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder,
        excludeFromSemantics: excludeFromSemantics,
      ),
    );
  }
}

class RoundedImageFromAsset extends StatelessWidget {
  final String image;
  final double size;
  final double radius;
  final BoxFit fit;
  final Color? color;
  final bool matchTextDirection;
  final ImageFrameBuilder? frameBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final String? semanticLabel;
  final bool excludeFromSemantics;

  const RoundedImageFromAsset(
    this.image, {
    this.size = 48,
    this.radius = 8,
    this.fit = BoxFit.cover,
    this.color,
    this.matchTextDirection = true,
    this.frameBuilder,
    this.errorBuilder,
    this.excludeFromSemantics = false,
    this.semanticLabel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(radius),
      child: SquareImageFromAsset(
        image,
        size: size,
        color: color,
        matchTextDirection: matchTextDirection,
        fit: fit,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder,
        excludeFromSemantics: excludeFromSemantics,
      ),
    );
  }
}

class SquareSvgImageFromAsset extends SvgPicture {
  SquareSvgImageFromAsset(
    String image, {
    double size = 24,
    BoxFit fit = BoxFit.scaleDown,
    Color? color,
    bool matchTextDirection = true,
    Key? key,
    WidgetBuilder? placeholderBuilder,
    bool excludeFromSemantics = false,
  }) : super.asset(
          image,
          key: key,
          height: size,
          width: size,
          color: color,
          matchTextDirection: matchTextDirection,
          fit: fit,
          semanticsLabel: image,
          excludeFromSemantics: excludeFromSemantics,
          placeholderBuilder: placeholderBuilder,
        );
}

class CircleSvgImageFromAsset extends StatelessWidget {
  final String image;
  final double size;
  final BoxFit fit;
  final Color? color;
  final bool matchTextDirection;
  final WidgetBuilder? placeholderBuilder;
  final String? semanticLabel;
  final bool excludeFromSemantics;

  const CircleSvgImageFromAsset(
    this.image, {
    this.size = 24,
    this.fit = BoxFit.cover,
    this.color,
    this.matchTextDirection = true,
    this.placeholderBuilder,
    this.excludeFromSemantics = false,
    this.semanticLabel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipBehavior: Clip.hardEdge,
      child: SquareSvgImageFromAsset(
        image,
        size: size,
        color: color,
        matchTextDirection: matchTextDirection,
        fit: fit,
        placeholderBuilder: placeholderBuilder,
        excludeFromSemantics: excludeFromSemantics,
      ),
    );
  }
}

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CachedImage(this.imageUrl, {Key? key, this.width, this.height, this.fit = BoxFit.cover}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget placeholder = Material(
      child: Image.asset(
        AppImages.imagesPlaceholder,
        fit: fit,
        width: width,
        height: height,
        color: AppColor.grey,
      ),
      color: AppColor.greyLight,
    );

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      errorWidget: (context, _, __) => placeholder,
      placeholder: (context, _) => placeholder,
    );
  }
}
