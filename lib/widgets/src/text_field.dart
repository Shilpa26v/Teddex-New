part of '../widgets.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscure;
  final TextInputAction inputAction;
  final FormFieldValidator<String>? validator;
  final GlobalKey<FormFieldState>? _fieldKey;
  final ValueChanged<String>? fieldSubmitted;
  final FocusNode? focus;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;
  final int minLines;
  final List<TextInputFormatter> inputFormatters;
  final bool isReadOnly;
  final TextAlign textAlign;
  final VoidCallback? onTap;
  final BoxConstraints iconConstraints;
  final String obscuringCharacter;
  final Iterable<String>? autofillHints;

  const CommonTextField({
    required this.controller,
    this.labelText = "",
    GlobalKey<FormFieldState>? globalKey,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.inputAction = TextInputAction.next,
    this.validator,
    this.fieldSubmitted,
    this.focus,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters = const [],
    this.maxLines = 1,
    this.maxLength,
    this.minLines = 1,
    this.isReadOnly = false,
    this.hintText = "",
    this.textAlign = TextAlign.start,
    this.onTap,
    this.iconConstraints = const BoxConstraints(maxWidth: 160),
    Key? key,
    this.obscuringCharacter = '●',
    this.autofillHints,
  })  : _fieldKey = globalKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty) ...[
          CommonText.medium(labelText, size: 14, color: AppColor.textPrimaryLight),
          const Gap(12),
        ],
        TextFormField(
          onTap: onTap,
          key: _fieldKey,
          validator: validator,
          obscuringCharacter: obscuringCharacter,
          textInputAction: inputAction,
          onFieldSubmitted: fieldSubmitted,
          controller: controller,
          focusNode: focus,
          maxLength: maxLength,
          obscureText: obscure,
          onChanged: onChanged,
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(
            color: AppColor.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            fontFamily: kFontFamily,
          ),
          textAlign: textAlign,
          maxLines: maxLines,
          minLines: minLines,
          readOnly: isReadOnly,
          inputFormatters: inputFormatters,
          autofillHints: autofillHints,
          decoration: InputDecoration(
            hintText: hintText,
            prefix: prefix,
            suffix: suffix,
            errorMaxLines: 4,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            prefixIconConstraints: iconConstraints,
            suffixIconConstraints: iconConstraints,
            counter: const SizedBox.shrink()
          ),
        ),
      ],
    );
  }
}
