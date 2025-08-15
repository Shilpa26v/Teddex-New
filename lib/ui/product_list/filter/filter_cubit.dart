part of '../product_list_view.dart';

class FilterCubit extends BaseCubit<FilterState> {
  FilterCubit(BuildContext context, FilterState initialState) : super(context, initialState) {

    getSelectedValue();
  }

  void getSelectedValue() {
    Log.debug("datain cubit..${state.selectedFilter}");
    for (var f in state.filterData) {
      if (f.filterList != null && f.filterList!.isNotEmpty && state.selectedFilter.isNotEmpty) {
        FilterType data = f.filterList!.firstWhere((element) => state.selectedFilter.contains(element.id),orElse: ()=> FilterType());
        if (data.id != null) {
          f.selectedValue = data;
          Log.debug("datain cubit..${f.selectedValue}");

        }
      }
    }
  }

  void onChangeFilter( f, index) {
    var filter= f as FilterType;
    if (filter != null) {
      var list = state.selectedFilter;
      for (int i = 0; i < list.length; i++) {
        if (list[i].substring(0, 1) == filter.id![0]) {
          list.removeAt(i);
        }
      }
      list = [...list, filter.id!];
      var filterData=state.filterData;
      var data=filterData[index];
      data.selectedValue = f;
      Log.debug("ceelist..${list}");
      emit(state.copyWith(filterData: filterData,selectedFilter:list ));
      Log.debug("list..${state.selectedFilter}");

    }
  }

  void apply() {
    Navigator.pop(context, state.selectedFilter);
  }

  void clear() {
    var list = state.filterData;

    for (var element in list) {
      element.selectedValue=null;
    }

    emit(state.copyWith(selectedFilter:[] ,filterData: list));
    Navigator.pop(context, <String>[]);
  }
}
