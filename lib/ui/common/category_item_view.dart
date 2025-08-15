import 'package:flutter/material.dart';
import 'package:teddex/widgets/widgets.dart';

import '../../resources/resources.dart';

class CategoryItemView extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const CategoryItemView({
    Key? key,
    required this.title,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AspectRatio(
        aspectRatio: 2.0,
        child: InkWell(
          highlightColor: AppColor.greyLight.withAlpha(150),
          splashColor: AppColor.greyLight,
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedImage(image, fit: BoxFit.cover),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: AppColor.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonText.medium(title, size: 16),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColor.primary, width: 2),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: AppColor.primary,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
