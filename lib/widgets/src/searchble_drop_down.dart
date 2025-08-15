part of '../widgets.dart';

// class CommonSearchableDropDownField<T> extends StatelessWidget {
//   final List<String>? items;
//   final String? hintText;
//   final String? selectedItem;
//   final String? searchHint;
//   final double? maxHeight;
//   final bool showSearchBox;
//   final FormFieldValidator<String>? validator;
//   final GlobalKey<FormFieldState>? key;
//   final ValueChanged<String?>? onChanged;
//
//   const CommonSearchableDropDownField({
//     @required this.items,
//     @required this.onChanged,
//     this.selectedItem,
//     this.hintText = "",
//     this.searchHint = "",
//     this.maxHeight ,
//     this.key,
//     this.showSearchBox = true,
//     this.validator,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownSearch<String>(
//       maxHeight: maxHeight,
//       mode: Mode.DIALOG,
//       searchFieldProps: TextFieldProps(
//           decoration: InputDecoration(
//             contentPadding: const EdgeInsets.only(left: 8, right: 8),
//             hintText: searchHint,
//             enabledBorder: const OutlineInputBorder(
//               borderSide: BorderSide(
//                 color: AppColor.greyLight,
//                 width: 1,
//               ),
//               borderRadius: BorderRadius.all(Radius.circular(4.0)),
//             ),
//             focusedBorder: const OutlineInputBorder(
//               borderSide: BorderSide(
//                 color: AppColor.greyLight,
//                 width: 1,
//               ),
//               borderRadius: BorderRadius.all(Radius.circular(4.0)),
//             ),
//           )),
//       autoValidateMode: AutovalidateMode.onUserInteraction,
//       popupShape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
//       ),
//       selectedItem: selectedItem != null && selectedItem!.isNotEmpty ? selectedItem : null,
//       dropdownSearchDecoration: InputDecoration(
//         hintText: hintText,
//         isDense: true,
//         contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//         border: const OutlineInputBorder(
//             borderSide: BorderSide(
//               color: AppColor.greyLight,
//               width: 1,
//             ),
//             borderRadius: BorderRadius.all(Radius.circular(4))),
//         enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(
//               color: AppColor.greyLight,
//               width: 1,
//             ),
//             borderRadius: BorderRadius.all(Radius.circular(4))),
//         focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(
//               color: AppColor.greyLight,
//               width: 1,
//             ),
//             borderRadius: BorderRadius.all(Radius.circular(4))),
//         focusedErrorBorder: const OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.red,
//               width: 1,
//             ),
//             borderRadius: BorderRadius.all(Radius.circular(4))),
//         errorBorder: const OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.red,
//               width: 1,
//             ),
//             borderRadius: BorderRadius.all(Radius.circular(4))),
//       ),
//       items: items,
//       validator: validator,
//       onChanged: onChanged,
//       showSearchBox: showSearchBox,
//     );
//   }
// }
