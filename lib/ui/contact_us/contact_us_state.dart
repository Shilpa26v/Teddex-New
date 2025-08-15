part of 'contact_us_view.dart';

class ContactUsState extends Equatable {
  final List<FAQ> list;
  final bool isLoading;

  const ContactUsState({
    this.list = const [],
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [list, isLoading];

  ContactUsState copyWith({
    List<FAQ>? list,
    bool? isLoading,
  }) {
    return ContactUsState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
