part of '../widgets.dart';

class DropDownItem<T> {
  String label;
  T value;

  DropDownItem({required this.label, required this.value});
}

class CommonDropDownField<T> extends StatelessWidget {
  final List<DropDownItem<T>> items;
  final String hintText;
  final String labelText;
  final FormFieldValidator<T>? validator;
  final GlobalKey<FormFieldState>? globalKey;
  final ValueChanged<T>? fieldSubmitted;
  final FocusNode? focus;
  final ValueChanged<T?> onChanged;
  final T? value;
  final bool isExpanded;

  const CommonDropDownField({
    required this.items,
    required this.onChanged,
    this.hintText = "",
    this.globalKey,
    this.validator,
    this.fieldSubmitted,
    this.focus,
    this.value,
    this.isExpanded = true,
    this.labelText = "",
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText.isNotEmpty) ...[
          CommonText.medium(labelText, size: 15, color: AppColor.textPrimaryLight),
          const Gap(12),
        ],
        DropdownButtonFormField<T>(
          key: globalKey,
          value: value,
          validator: validator,
          focusNode: focus,
          onChanged: onChanged,
          style: const TextStyle(color: AppColor.textPrimary, fontWeight: FontWeight.w500, fontSize: 16),
          isExpanded: isExpanded,
          // icon: const SquareSvgImageFromAsset(Assets.imagesdropDownIcon, size: 6, color: AppColor.grey),
          items: items
              .map((e) => DropdownMenuItem<T>(value: e.value, child: CommonText.medium(e.label, size: 16)))
              .toList(),
          dropdownColor: AppColor.white,
          hint: CommonText.medium(hintText, size: 16, color: AppColor.textPrimaryLight, textAlign: TextAlign.center),
          decoration: InputDecoration(hintText: hintText),
        ),
      ],
    );
  }
}
