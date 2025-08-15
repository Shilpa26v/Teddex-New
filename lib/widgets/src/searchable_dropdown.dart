part of '../widgets.dart';

class SearchableCommonDropDownField<T> extends StatelessWidget {
  final List<T> items;
  final String hintText;
  final String labelText;
  final FormFieldValidator<T>? validator;
  final GlobalKey<FormFieldState>? globalKey;
  final ValueChanged<T>? fieldSubmitted;
  final FocusNode? focus;
  final ValueChanged<T?> onChanged;
  final DropdownSearchItemAsString<T>? itemAsString;
  final T? value;
  final bool isExpanded;

  const SearchableCommonDropDownField({
    required this.items,
    required this.onChanged,
    this.hintText = "",
    this.globalKey,
    this.validator,
    this.fieldSubmitted,
    this.focus,
    this.value,
    this.itemAsString,
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
        DropdownSearch<T>(
          popupProps: const PopupProps.dialog(showSearchBox: true,searchFieldProps:TextFieldProps()),
          items: items,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
            ),

          ),
          itemAsString: itemAsString ,
          onChanged: onChanged,
          selectedItem: value,
        )
      ],
    );
  }
}
