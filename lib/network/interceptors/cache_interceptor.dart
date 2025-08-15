import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:teddex/database/dao/dao.dart';
import 'package:teddex/database/entity/entity.dart';
import 'package:teddex/helpers/helpers.dart';

class CacheInterceptor extends InterceptorsWrapper {
  final _uuid = const Uuid();
  final CacheDao _cacheDao;
  final ConnectivityHelper _connectivityHelper = GetIt.I.get<ConnectivityHelper>();

  CacheInterceptor(this._cacheDao);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!_connectivityHelper.hasInternet) {
      if (options.method.toUpperCase() == "GET") {
        var response = await getCachedResponse(options);
        if (response != null) {
          handler.resolve(response);
          return;
        }
      }
      handler.reject(DioError(requestOptions: options, type: DioErrorType.cancel, error: "No Internet"));
      return;
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.type == DioErrorType.unknown && err.error is SocketException) {
      if (err.requestOptions.method.toUpperCase() == "GET") {
        var response = await getCachedResponse(err.requestOptions);
        if (response != null) {
          handler.resolve(response);
          return;
        }
      }
    }
    super.onError(err, handler);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.data is ResponseBody) {
      handler.next(response);
      return;
    }
    if (response.statusCode == HttpStatus.ok && response.requestOptions.method.toUpperCase() == "GET") {
      final cacheResp = await _buildCacheResponse(response.requestOptions.uri.toString(), jsonEncode(response.data));
      await _cacheDao.addCache(cacheResp);
    }
    super.onResponse(response, handler);
  }

  Future<CacheEntity> _buildCacheResponse(String url, String response) async {
    final date = DateTime.now().microsecondsSinceEpoch;
    return CacheEntity(
      key: _defaultCacheKeyBuilder(url),
      url: url.toString(),
      content: response,
      date: date,
    );
  }

  String _defaultCacheKeyBuilder(String url) {
    return _uuid.v5(Uuid.NAMESPACE_URL, url);
  }

  Future<dynamic> getCachedResponseData(String url, [bool encrypted = false]) async {
    var key = _defaultCacheKeyBuilder(url);
    var resp = await _cacheDao.getCacheResponse(key);
    if (resp != null) {
      return jsonDecode(resp.content);
    }
  }

  Future<Response?> getCachedResponse(RequestOptions options) async {
    var data = await getCachedResponseData(options.uri.toString());
    if (data != null) {
      return Response(requestOptions: options, data: data, statusCode: 200);
    }
    return null;
  }
}
