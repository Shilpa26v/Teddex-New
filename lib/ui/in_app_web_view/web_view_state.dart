part of 'web_view.dart';

class WebViewState extends Equatable {
  final String initialUrl;
  final String title;
  final InAppWebViewController? controller;

  const WebViewState(this.initialUrl, this.title, {this.controller});

  @override
  List<Object?> get props => [controller];

  WebViewState copyWith({InAppWebViewController? controller}) {
    return WebViewState(
      initialUrl,
      title,
      controller: controller ?? this.controller,
    );
  }
}
