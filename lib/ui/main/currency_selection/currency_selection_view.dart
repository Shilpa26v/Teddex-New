import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teddex/app/app.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/pref/app_pref.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/widgets/widgets.dart';

part 'currency_selection_cubit.dart';
part 'currency_selection_state.dart';

class CurrencySelectionArguments {
  final List<Currency> listCurrency;

  const CurrencySelectionArguments({
    required this.listCurrency,
  });
}

class CurrencySelectionView extends StatefulWidget {
  const CurrencySelectionView({Key? key}) : super(key: key);

  static const routeName = "/currency_selection_view";

  static Widget builder(BuildContext context) {
    var appState = BlocProvider.of<AppCubit>(context).state;
    final state = CurrencySelectionState(list: appState.listCurrency, selected: appState.selectedCurrency);
    return BlocProvider(
      create: (context) => CurrencySelectionCubit(context, state),
      child: const CurrencySelectionView(),
    );
  }

  @override
  _CurrencySelectionViewState createState() => _CurrencySelectionViewState();
}

class _CurrencySelectionViewState extends State<CurrencySelectionView> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      child: BlocBuilder<CurrencySelectionCubit, CurrencySelectionState>(
        builder: (context, state) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: state.list.length,
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              var currency = state.list[index];
              return ListTile(
                horizontalTitleGap: 0,
                selected: state.selected == currency.id,
                selectedTileColor: AppColor.greyLight,
                onTap: () => BlocProvider.of<CurrencySelectionCubit>(context).onSelectedChanged(index),
                leading: SizedBox.square(
                  dimension: 48,
                  child: MediaQuery(
                    data: context.mediaQuery.copyWith(textScaleFactor: 1.0),
                    child: Center(
                      child: CommonText.semiBold(currency.currencyText, size: 20),
                    ),
                  ),
                ),
                title: CommonText.medium(currency.code, size: 16),
              );
            },
          );
        },
      ),
    );
  }
}
