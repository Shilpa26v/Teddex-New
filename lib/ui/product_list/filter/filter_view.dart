part of '../product_list_view.dart';

class FilterDataArguments {
  final List<Filter> filterData;
  final List<String> selectedFilter;

  const FilterDataArguments({required this.filterData, required this.selectedFilter});
}

class FilterView extends StatefulWidget {
  const FilterView({Key? key}) : super(key: key);

  static const routeName = "/filter_view";

  static Widget builder(BuildContext context) {
    assert(context.args != null && context.args is FilterDataArguments);
    Log.debug("${(context.args as FilterDataArguments).selectedFilter}");
    return BlocProvider(
      create: (ctx) => FilterCubit(
        context,
        FilterState((context.args as FilterDataArguments).filterData,
            selectedFilter: (context.args as FilterDataArguments).selectedFilter),
      ),
      child: const FilterView(),
    );
  }

  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackIcon(),
        title: Text(S.current.applyFilter),
      ),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            BlocBuilder<FilterCubit, FilterState>(
              builder: (context, state) {
                if (state.filterData.isEmpty) {
                  return SliverFillRemaining(
                    child: EmptyView(label: S.of(context).noProductsFound),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => BlocSelector<FilterCubit, FilterState, Filter>(
                        selector: (state) => state.filterData[index],
                        builder: (context, filterData) {

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: CommonDropDownField(
                              labelText: filterData.filterType ?? "",
                              hintText: filterData.filterType ?? "",
                              items: filterData.filterList!
                                  .map((e) => DropDownItem(label: e.name.toString() ?? "", value: e)).toList(),
                              value: state.filterData[index].selectedValue,
                              onChanged: (selectedValue) =>
                                  BlocProvider.of<FilterCubit>(context).onChangeFilter(selectedValue, index),
                            ),
                          );
                        },
                      ),
                      childCount: state.filterData.length,
                    ),
                  ),
                );
              },
            ),
            SliverGap(context.bottomPadding),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: IntrinsicHeight(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8 + context.bottomInset),
            child: SizedBox(
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CommonButton(
                      onPressed: () => BlocProvider.of<FilterCubit>(context).apply(),
                      label: S.of(context).apply,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CommonButton(
                      onPressed: () => BlocProvider.of<FilterCubit>(context).clear(),
                      label: S.of(context).clear,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
