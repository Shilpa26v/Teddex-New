part of 'currency_selection_view.dart';

class CurrencySelectionState extends Equatable {
  final List<Currency> list;
  final int selected;

  const CurrencySelectionState({
    this.list = const [],
    this.selected = -1,
  });

  @override
  List<Object?> get props => [list, selected];

  CurrencySelectionState copyWith({
    List<Currency>? list,
    int? selected,
  }) {
    return CurrencySelectionState(
      list: list ?? this.list,
      selected: selected ?? this.selected,
    );
  }
}
