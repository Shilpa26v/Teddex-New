import 'package:flutter/material.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;


class ImageSliderViewArgument {
  final List<String> listImages;
  final int initialIndex;

  const ImageSliderViewArgument({this.initialIndex = 0, this.listImages = const []});
}

class ImageSliderView extends StatefulWidget {
  final ImageSliderViewArgument argument;

  const ImageSliderView({Key? key, required this.argument}) : super(key: key);

  static const routeName = "/image_slider_view";

  static Widget builder(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null && args is ImageSliderViewArgument);
    var argument = args as ImageSliderViewArgument;
    return ImageSliderView(argument: argument);
  }

  @override
  _ImageSliderViewState createState() => _ImageSliderViewState();
}

class _ImageSliderViewState extends State<ImageSliderView> {
  late final PageController _pageController;

  List<String> get _listImages => widget.argument.listImages;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.argument.initialIndex);
    super.initState();
  }

  Future<Uint8List> getImageByte(String imageUrl) async {
    http.Response response = await http.get(
      Uri.parse(imageUrl),
    );
    return response.bodyBytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackIcon(),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _listImages.length,
              padEnds: true,
              itemBuilder: (context, index) => Stack(
                children: [
                  Center(
                    child: InteractiveViewer(
                      maxScale: 4.0,
                      minScale: 1.0,
                      scaleEnabled: true,
                      boundaryMargin: EdgeInsets.zero,
                      child: Hero(
                        tag: "product_image_$index",
                        child: CachedImage(_listImages[index], fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  Center(
                    child: Transform.rotate(
                      angle: -math.pi / 4,
                      child:  Container(
                        alignment: Alignment.center,
                        width: double.infinity,height: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonText.medium(
                                "www.tedeex.com",
                                textAlign: TextAlign.center,
                                size: 36,
                                color: AppColor.shadowColor.withOpacity(0.5),
                              ),
                              CommonText.regular(
                                "+918000100161",
                                textAlign: TextAlign.center,
                                size: 22,
                                color: AppColor.shadowColor.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, context.mediaQueryPadding.bottom + 8),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 24,
                  color: AppColor.white.withAlpha(150),
                  offset: const Offset(0, -4),
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: _pageController,
              builder: (context, _) {
                return Hero(
                  tag: "dots_indicator",
                  child: DotsIndicator(
                    itemCount: _listImages.length,
                    color: AppColor.black,
                    height: 8,
                    width: 8,
                    selectedWidth: 16,
                    selectedIndex: _pageController.hasClients
                        ? _pageController.page?.round() ?? widget.argument.initialIndex
                        : widget.argument.initialIndex,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
