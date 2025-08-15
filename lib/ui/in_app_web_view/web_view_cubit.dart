part of 'web_view.dart';

class WebViewCubit extends BaseCubit<WebViewState> {
  final WebViewArguments args;

  WebViewCubit(BuildContext context, this.args) : super(context, WebViewState(args.url, args.title));

  void onWebViewCreated(InAppWebViewController controller) {
    emit(state.copyWith(controller: controller));
  }

  Future<bool> onBackTap() async {
    if (state.controller == null) {
      return true;
    } else if (await state.controller!.canGoBack()) {
      state.controller!.goBack();
      return false;
    } else {
      return true;
    }
  }

  void onLoadError(InAppWebViewController controller, Uri? url, int code, String message) {
    if (url != null) {
      "WebViewCubit.onLoadError -> url -> $url -> code -> $code -> message -> $message".error();
      url.queryParameters.forEach((key, value) {
        "$key -> $value -> ${value.runtimeType}".error();
      });
    }
  }

  void onLoadStart(InAppWebViewController controller, Uri? url) {
    "WebViewCubit.onLoadStart -> $url".debug();
  }
}
