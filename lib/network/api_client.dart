import 'dart:io';

import 'package:dio/dio.dart';
import 'package:teddex/config/app_config.dart';
import 'package:teddex/database/dao/cache_dao.dart';
import 'package:teddex/network/interceptors/api_interceptor.dart';
import 'package:teddex/network/interceptors/cache_interceptor.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/ui/main/dashboard/dashboard_view.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  static const bool doWriteLog = true;
  static const bool doEncryption = false;

  factory ApiClient() {
    var headers = {
      HttpHeaders.contentTypeHeader: ContentType("application", "json", charset: "utf-8").mimeType,
      HttpHeaders.acceptHeader: ContentType("application", "json", charset: "utf-8").mimeType,
      "key_sign": "tedx_apps",
    };
    var options = BaseOptions(
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 60000),
        sendTimeout: const Duration(milliseconds: 60000),
        headers: headers);
    Dio dio = Dio(options);
    dio.interceptors.addAll([
      ApiInterceptor(doEncryption: doEncryption, doWriteLog: doWriteLog),
    ]);
    return _ApiClient(dio, baseUrl: AppConfig.baseUrl);
  }

  @POST("api_login.php")
  Future<CommonResponse<LoginResponse>> login({
    @Field("mobile") required String mobile,
  });

  @POST("api_login.php")
  Future<CommonResponse<LoginResponse>> socialLogin({
    @Field("type") required String type,
    @Field("social_id") required String socialId,
    @Field("email") String? email,
    @Field("name") String? name,
  });

  @POST("api_forgot_pass.php")
  Future<CommonResponse<dynamic>> forgotPassword(@Field("email") String email);

  @POST("api_register.php")
  Future<CommonResponse<LoginResponse>> register({
    @Field("email") required String email,
    @Field("name") required String name,
    @Field("mobile") required String mobile,
    @Field("country_code") required String countryCode,
  });

  @POST("api_otp.php")
  Future<CommonResponse<CheckOtp>> sendOtp(
      @Field("is_login") int isLogin, @Field("country_code") countryCode, @Field("email") email, @Field("mobile") String mobile);

  @POST("api_email_check.php")
  Future<CommonResponse> checkEmail(@Field("email") String email);

  @GET("api_currency.php")
  Future<CommonResponse<List<Currency>>> getCurrencies();

  @GET("api_faqs.php")
  Future<CommonResponse<List<FAQ>>> getFaqs();

  @GET("api_pages.php")
  Future<CommonResponse<CommonPage>> getCommonPages();

  @GET("api_profile.php")
  Future<CommonResponse<User>> getProfile();

  @GET("api_home.php")
  Future<CommonResponse<Dashboard>> getDashboard();

  @GET("api_plan.php")
  Future<CommonResponse<List<SubscriptionPlan>>> getSubscriptionPlans();

  @GET("api_category.php")
  Future<CommonResponse<List<Category>>> getCategory();

  @GET("api_filters.php")
  Future<CommonResponse<dynamic>> getFilterData();

  @POST("api_list_products.php")
  Future<CommonResponse<List<Product>>> getProducts({
    @Field("cid") required int categoryId,
    @Field("vendor_id") String vendorId = "",
    @Field("start_limit") int offset = 0,
    @Field("limit") int limit = AppConfig.paginationLimit,
    @Field("filters") String filters = "",
  });

  @POST("api_list_products.php")
  Future<CommonResponse<List<Product>>> searchProducts({
    @Field("search") required String search,
    @Field("vendor_id") String vendorId = "",
    @Field("start_limit") int offset = 0,
    @Field("limit") int limit = AppConfig.paginationLimit,
  });

  @POST("api_add_favourite.php")
  Future<CommonResponse<List<Product>>> addToFavourite(@Field("id") int id);

  @DELETE("api_add_favourite.php")
  Future<CommonResponse<List<Product>>> deleteFromFavourite(@Field("id") int id);

  @POST("api_list_favourite.php")
  Future<CommonResponse<List<Product>>> favouriteProducts({
    @Field("start_limit") int offset = 0,
    @Field("limit") int limit = AppConfig.paginationLimit,
  });

  @GET("api_my_cart.php")
  Future<CommonResponse<List<Cart>>> getCartItems(@Body() Map<String, dynamic> map);

  @POST("api_delete_cart.php")
  Future<CommonResponse<List<Cart>>> deleteCartItem(@Field("id") int id);

  @POST("api_add_cart.php")
  Future<CommonResponse<List<Cart>>> addToCart(@Field("id") int id);

  @POST("api_product_detail.php")
  Future<CommonResponse<ProductDetail>> getProductDetail(@Field("id") int id);

  @MultiPart()
  @POST("api_profile_image.php")
  Future<CommonResponse<ImageUploadResponse>> updateProfileImage(@Part(name: "image") File image);

  @GET("api_my_plan.php")
  Future<CommonResponse<List<MyPlan>>> getMyPlan();

  @POST("api_profile_save.php")
  Future<CommonResponse<String>> updateProfile({
    @Field("email") required String email,
    @Field("name") required String name,
    @Field("mobile") required String mobile,
    @Field("country_code") required String countryCode,
    @Field("country") required String country,
    @Field("state") required String state,
    @Field("pincode") required String pincode,
    @Field("city") required String city,
  });

  @POST("api_add_order.php")
  Future<CommonResponse<CreateOrderResponse>> createOrder({
    @Field("pay_method") required String paymentMethod,
    @Field("email") required String email,
    @Field("name") required String name,
    @Field("mobile") required String mobile,
    @Field("country_code") required String countryCode,
  });

  @POST("api_payment_callback.php")
  Future<CommonResponse<dynamic>> confirmPayment({
    @Field("razorpay_order_id") required String orderId,
    @Field("razorpay_payment_id") required String paymentId,
  });

  @POST("api_my_download.php")
  Future<CommonResponse<List<Order>>> getOrders({
    @Field("start_limit") int offset = 0,
    @Field("limit") int limit = AppConfig.paginationLimit,
  });

  @GET("api_banners.php")
  Future<CommonResponse<List<HomeBanner>>> getHomeBanner();

  @POST("api_purchase_plan.php")
  Future<CommonResponse<CreateOrderResponse>> purchasePlan({
    @Field("plan_id") required int planId,
    @Field("payment_method") required String paymentMethod,
  });

  @POST("api_plan_payment_callback.php")
  Future<CommonResponse<dynamic>> confirmPlanPayment({
    @Field("razorpay_order_id") required String orderId,
    @Field("razorpay_payment_id") required String paymentId,
  });

  @POST("api_review_add.php")
  Future<CommonResponse<dynamic>> addReview({
    @Field("product_id") required int productId,
    @Field("messages") required String message,
    @Field("star") required int star,
  });

  @POST("api_change_password.php")
  Future<CommonResponse<dynamic>> changePassword(@Field("password") String password);

  @POST("api_direct_down_order.php")
  Future<CommonResponse<dynamic>> downloadProduct(@Field("product_id") int id);

  @POST("api_check_plan.php")
  Future<CommonResponse<dynamic>> checkForDownload(@Field("product_id") int id);
}
