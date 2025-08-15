import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CountryPickerView extends StatefulWidget {
  const CountryPickerView({Key? key}) : super(key: key);

  @override
  _CountryPickerViewState createState() => _CountryPickerViewState();
}

class _CountryPickerViewState extends State<CountryPickerView> {
  late PublishSubject<String> _searchTextSubject;
  late PublishSubject<Iterable<Country>> _countryListSubject;
  late TextEditingController _searchController;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => setState(() => _countryListSubject.add(countryList)));
    _searchTextSubject = PublishSubject<String>()
      ..stream.distinct().debounceTime(const Duration(milliseconds: 300)).listen(onSearch);
    _countryListSubject = PublishSubject<Iterable<Country>>()..add([]);
    _searchController = TextEditingController()..addListener(_searchListener);
    super.initState();
  }

  void _searchListener() {
    _searchTextSubject.add(_searchController.text.toLowerCase().trim().replaceAll("+", ""));
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchListener);
    _searchTextSubject.close();
    _countryListSubject.close();
    super.dispose();
  }

  void onSearch(String searchText) {
    if (searchText.isEmpty) {
      _countryListSubject.add(countryList);
    } else {
      _countryListSubject.add(
        countryList.where((element) =>
            element.name.toLowerCase().contains(searchText) || element.phoneCode.toLowerCase().contains(searchText)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: MaterialLocalizations.of(context).searchFieldLabel,
              prefixIcon: IconButton(
                splashRadius: 24,
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<Iterable<Country>>(
            stream: _countryListSubject,
            builder: (context, snapshot) {
              return Scrollbar(
                child: ListView.builder(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                  itemBuilder: (context, index) => CountryPickerItemView(
                    country: snapshot.data!.elementAt(index),
                    onPressed: (country) => Navigator.of(context).pop(country),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
