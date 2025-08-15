class Filter {
  String? filterType;
  List<FilterType>? filterList;
  FilterType? selectedValue;

  @override
  String toString() {
    return 'filterType[$filterType]';
  }

  Filter.fromJson(MapEntry<String, dynamic> json) {
    if (json == null) return;
    filterType = json.key;
    filterList = FilterType.listFromJson(json.value);
  }

  static List<Filter> listFromJson(Map<String, dynamic> json) {
    return json == null ? List<Filter>.empty() : json.entries.map((value) => Filter.fromJson(value)).toList();
  }


}

class FilterType {
  String? id ;
  dynamic name ;
  FilterType();

  FilterType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  static List<FilterType> listFromJson(List<dynamic> json) {
    return json.map((val) => FilterType.fromJson(val)).toList();
  }
}
