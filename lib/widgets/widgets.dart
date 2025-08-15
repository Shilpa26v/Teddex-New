import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:layout/layout.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/widgets/src/dropdwon/dropdown_search.dart';


export 'app_dialog.dart';
export 'app_loader.dart';
export 'dots_indicator.dart';
export 'empty_data_view.dart';
export 'image_picker.dart';
export 'load_more_list.dart';
export 'permission_dialog.dart';

part 'src/button.dart';
part 'src/drop_down.dart';
part 'src/image.dart';
part 'src/text.dart';
part 'src/text_field.dart';
part 'src/searchable_dropdown.dart';
part 'src/searchble_drop_down.dart';

class BackIcon extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackIcon({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: onPressed ?? () => Navigator.of(context).pop(false),
        icon: ClipRRect(
            borderRadius:  const BorderRadius.all(Radius.circular(20)),
            child: Container(
              padding: const EdgeInsets.all(8),
                color: AppColor.primary,
                child: SquareSvgImageFromAsset(AppImages.imagesBack,color: AppColor.white,))),
      ),
    );
  }
}

class ActionIcon extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final String? tooltip;

  const ActionIcon({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 24,
      tooltip: tooltip,
      onPressed: onPressed,
      icon: icon,
    );
  }
}

class LikeIcon extends StatelessWidget {
  final bool value;
  final ValueSetter<bool> onChanged;

  const LikeIcon({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 24,
      visualDensity: VisualDensity.compact,
      splashColor: AppColor.white,
      highlightColor: AppColor.white.withAlpha(150),
      padding: const EdgeInsets.all(4),
      tooltip: S.of(context).tooltipFavourite,
      onPressed: () => onChanged(!value),
      icon: AnimatedCrossFade(
        crossFadeState: value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        firstChild: SquareSvgImageFromAsset(AppImages.imagesLikeUnselected),
        secondChild: SquareSvgImageFromAsset(AppImages.imagesLikeSelected),
        sizeCurve: Curves.bounceIn,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}

class UserProfileImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double radius;

  const UserProfileImage({
    Key? key,
    required this.imageUrl,
    this.size = 56,
    this.radius = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Log.debug("profile..$imageUrl");
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.hardEdge,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: imageUrl,
        height: size,
        width: size,
        placeholder: (context, url) => SquareImageFromAsset(AppImages.imagesUserPlaceholder),
        errorWidget: (context, url, _) => SquareImageFromAsset(AppImages.imagesUserPlaceholder),
      ),
    );
  }
}

class CountryCodePicker extends StatelessWidget {
  final Country selectedCountry;
  final void Function(Country country)? onSelectedCountryChanged;
  final bool _hasIcon;

  const CountryCodePicker({required this.selectedCountry, this.onSelectedCountryChanged, Key? key})
      : _hasIcon = false,
        super(key: key);

  const CountryCodePicker.icon({required this.selectedCountry, this.onSelectedCountryChanged, Key? key})
      : _hasIcon = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        onSelectedCountryChanged?.let((it) async {
          var country = await showCountryPickerSheet(context);
          country?.let((country) => onSelectedCountryChanged?.call(country));
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_hasIcon) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  CountryPickerUtils.getFlagImageAssetPath(selectedCountry.isoCode),
                  height: 20,
                  width: 28,
                  fit: BoxFit.cover,
                ),
              ),
              const Gap(4),
            ],
            Flexible(child: CommonText.medium("+${selectedCountry.phoneCode}", size: 16)),
            const Icon(Icons.arrow_drop_down_rounded, color: AppColor.grey),
          ],
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  final String label;

  const EmptyView({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child:Scrollable(viewportBuilder: (BuildContext context,viewBuilder){
          return  Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Image.asset(AppImages.imagesEmptyView, width: 240),
              ),
              const Gap(8),
              CommonText.semiBold(
                label,
                size: 16,
                color: AppColor.textPrimaryLight,
                textAlign: TextAlign.center,
              ),
            ],
          );
        }),
      ),
    );
  }
}
