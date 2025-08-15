part of 'currency_selection_view.dart';

class CurrencySelectionCubit extends BaseCubit<CurrencySelectionState> {
  CurrencySelectionCubit(BuildContext context, CurrencySelectionState initialState) : super(context, initialState);

  void onSelectedChanged(int index) {
    var currency = state.list[index];
    AppPref.currencySymbol = currency.code;
    eventBus.fire("currency_updated");
    emit(state.copyWith(selected: currency.id));
    Navigator.of(context).pop();
  }
}
