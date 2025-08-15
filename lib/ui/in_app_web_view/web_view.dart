import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/widgets/widgets.dart';

part 'web_view_cubit.dart';

part 'web_view_state.dart';

class WebViewArguments {
  final String title;
  final String url;

  const WebViewArguments({required this.title, required this.url});
}

class WebView extends StatefulWidget {
  const WebView({Key? key}) : super(key: key);

  static const routeName = "/dynamic_web_view";

  static Widget builder(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null && args is WebViewArguments);
    return BlocProvider(
      create: (context) => WebViewCubit(context, args as WebViewArguments),
      child: const WebView(),
    );
  }

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  @override
  Widget build(BuildContext context) {
    var initialState = BlocProvider.of<WebViewCubit>(context).state;
    return WillPopScope(
      onWillPop: BlocProvider.of<WebViewCubit>(context).onBackTap,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackIcon(),
          title: Text(initialState.title),
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(initialState.initialUrl))),
          onWebViewCreated: BlocProvider.of<WebViewCubit>(context).onWebViewCreated,
          onLoadStart: BlocProvider.of<WebViewCubit>(context).onLoadStart,
          onLoadError: BlocProvider.of<WebViewCubit>(context).onLoadError,
        ),
      ),
    );
  }
}
