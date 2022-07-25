import 'package:flutter/material.dart';
import 'package:delivery_basket/api/ApiProvider.dart';
import 'package:delivery_basket/data/remote/model/address/DistanceMatrixResponse.dart';
import 'package:delivery_basket/data/remote/model/address/address_add_response.dart';
import 'package:delivery_basket/data/remote/model/address/address_delete_response.dart';
import 'package:delivery_basket/data/remote/model/address/address_list_response.dart';
import 'package:delivery_basket/data/remote/model/address/city_list_response.dart';
import 'package:delivery_basket/data/remote/model/address/pincode_list_response.dart';
import 'package:delivery_basket/data/remote/model/address/state_list_response.dart';
import 'package:delivery_basket/data/remote/model/cart/cart_list_response.dart';
import 'package:delivery_basket/data/remote/model/cart/cart_update_response.dart';
import 'package:delivery_basket/data/remote/model/cart/delivery_charge_list_response.dart';
import 'package:delivery_basket/data/remote/model/coupon/CouponApplyResponse.dart';
import 'package:delivery_basket/data/remote/model/forgot_password/forgot_password_response.dart';
import 'package:delivery_basket/data/remote/model/forgot_password/reset_password_response.dart';
import 'package:delivery_basket/data/remote/model/login/firebase_token_push_response.dart';
import 'package:delivery_basket/data/remote/model/login/login_response.dart';
import 'package:delivery_basket/data/remote/model/login/logout_response.dart';
import 'package:delivery_basket/data/remote/model/notification/notification_list_response.dart';
import 'package:delivery_basket/data/remote/model/offers/offer_list_response.dart';
import 'package:delivery_basket/data/remote/model/order/order_cancel_response.dart';
import 'package:delivery_basket/data/remote/model/order/order_history_details_response.dart';
import 'package:delivery_basket/data/remote/model/order/order_history_list_response.dart';
import 'package:delivery_basket/data/remote/model/order/order_place_response.dart';
import 'package:delivery_basket/data/remote/model/order/time_slot_response.dart';
import 'package:delivery_basket/data/remote/model/otp/otp_response.dart';
import 'package:delivery_basket/data/remote/model/setting/application_setting_response.dart';
import 'package:delivery_basket/data/remote/model/setting/customer_support_response.dart';
import 'package:delivery_basket/data/remote/model/setting/language_change_response.dart';
import 'package:delivery_basket/data/remote/model/setting/language_list_response.dart';
import 'package:delivery_basket/data/remote/model/setting/tag_line_response.dart';
import 'package:delivery_basket/data/remote/model/setting/user_profile_response.dart';
import 'package:delivery_basket/data/remote/model/signup/signup_response.dart';
import 'package:delivery_basket/data/remote/model/subcategory/sub_category_response.dart';
import 'package:delivery_basket/data/remote/model/wallet/credit_list_response.dart';
import 'package:delivery_basket/data/remote/model/wallet/debit_list_response.dart';
import 'package:delivery_basket/data/remote/model/wallet/wallet_add_response.dart';
import 'package:delivery_basket/data/remote/model/wallet/wallet_deduct_response.dart';
import 'package:delivery_basket/data/remote/model/wishlist/WishUpdateResponse.dart';
import 'package:delivery_basket/data/remote/model/wishlist/wish_cart_add_response.dart';
import 'package:delivery_basket/data/remote/model/wishlist/wish_list_response.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/banner_response.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/category_response.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/product_response.dart';

import 'model/cart/cart_local_post_response.dart';
import 'model/notification/notification_viewed_response.dart';
import 'model/order/order_payment_response.dart';
import 'model/payment/ease_buzz_payment_init_response.dart';

class Repository{
  ApiProvider _provider = ApiProvider();

  Future<BannerResponse> fetchBannerList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"banner",map);
    return BannerResponse.fromJson(response);
  }

  Future<CategoryResponse> fetchCategoryList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"category",map);
    return CategoryResponse.fromJson(response);
  }

  Future<ProductResponse> fetchOfferProductList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"offerproduct",map);
    return ProductResponse.fromJson(response);
  }

  Future<ProductResponse> fetchProductList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"product",map);
    return ProductResponse.fromJson(response);
  }


  Future<ProductResponse> fetchProductSearchList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"product-search",map);
    return ProductResponse.fromJson(response);
  }

  Future<ProductResponse> fetchCartList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"cart-product",map);
    return ProductResponse.fromJson(response);
  }

  Future<OtpResponse> sendOtp(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"otp",map);
    return OtpResponse.fromJson(response);
  }

  Future<SignupResponse> signUpUser(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"register",map);
    return SignupResponse.fromJson(response);
  }

  Future<LoginResponse> loginUser(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"login",map);
    return LoginResponse.fromJson(response);
  }

  Future<ForgotPasswordResponse> fetchForgotPassword(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"forget-password",map);
    return ForgotPasswordResponse.fromJson(response);
  }

  Future<ResetPasswordResponse> fetchResetPassword(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"new-password",map);
    return ResetPasswordResponse.fromJson(response);
  }

  Future<CartUpdateResponse> cartUpdate(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"cart",map);
    return CartUpdateResponse.fromJson(response);
  }

  Future<CartLocalPostResponse> cartLocalPost(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"local-cart",map);
    return CartLocalPostResponse.fromJson(response);
  }

  Future<ProductResponse> fetchSimillarProductList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"similar-product",map);
    return ProductResponse.fromJson(response);
  }

  Future<AddressAddResponse> addressAdd(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"customer-address",map);
    return AddressAddResponse.fromJson(response);
  }

  Future<AddressAddResponse> addressUpdate(BuildContext context,Map<String,String>map,int id) async {
    final response = await _provider.post(context,"customer-address/$id",map);
    return AddressAddResponse.fromJson(response);
  }

  Future<AddressListResponse> fetchAddressList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"customer-address",map);
    return AddressListResponse.fromJson(response);
  }

  Future<AddressDeleteResponse> addressDelete(BuildContext context,Map<String,String>map,int id) async {
    final response = await _provider.delete(context,"customer-address/$id",map);
    return AddressDeleteResponse.fromJson(response);
  }

  Future<TimeSlotResponse> fetchTimeSlot(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"time-slot",map);
    return TimeSlotResponse.fromJson(response);
  }

  Future<ApplicationSettingResponse> fetchApplicationSetting(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"application-setting",map);
    return ApplicationSettingResponse.fromJson(response);
  }

  Future<OfferListResponse> fetchOffers(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"offer",map);
    return OfferListResponse.fromJson(response);
  }

  Future<CouponApplyResponse> applyCoupon(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"cuppon",map);
    return CouponApplyResponse.fromJson(response);
  }

  Future<WalletResponse> walletAddMoney(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"wallet",map);
    return WalletResponse.fromJson(response);
  }

  Future<WalletResponse> fetchWalletAmount(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"wallet",map);
    return WalletResponse.fromJson(response);
  }

  Future<CreditListResponse> fetchCreditList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"credit",map);
    return CreditListResponse.fromJson(response);
  }

  Future<DebitListResponse> fetchDebitList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"debit",map);
    return DebitListResponse.fromJson(response);
  }

  Future<CartListResponse> fetchCartLoginList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"cart",map);
    return CartListResponse.fromJson(response);
  }

  // Future<DeliveryChargesResponse> fetchDeliveryCharges(BuildContext context,Map<String,String>map) async {
  //   final response = await _provider.get(context,"delivery-charges",map);
  //   return DeliveryChargesResponse.fromJson(response);
  // }

  Future<OrderPlaceResponse> placeOrder(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"order",map);
    return OrderPlaceResponse.fromJson(response);
  }

  Future<WalletDeductResponse> walletDeduct(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"order-payment",map);
    return WalletDeductResponse.fromJson(response);
  }

  Future<WishUpdateResponse> wishListAdd(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"wish",map);
    return WishUpdateResponse.fromJson(response);
  }

  Future<WishListResponse> wishListGetAll(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"wish",map);
    return WishListResponse.fromJson(response);
  }

  Future<WishUpdateResponse> wishListDelete(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"wish-delete",map);
    return WishUpdateResponse.fromJson(response);
  }

  Future<WishCartAddResponse> wishListToCartAdd(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"wish-cart",map);
    return WishCartAddResponse.fromJson(response);
  }

  Future<OrderHistoryListResponse> fetchOrderHistory(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"order",map);
    return OrderHistoryListResponse.fromJson(response);
  }

  Future<OrderHistoryDetailsResponse> fetchOrderHistoryDetails(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"order-history-detail",map);
    return OrderHistoryDetailsResponse.fromJson(response);
  }

  Future<OrderPaymentResponse> fetchOrderPayment(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"payment-order",map);
    return OrderPaymentResponse.fromJson(response);
  }

  Future<UserProfileResponse> fetchUserProfile(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"user-details",map);
    return UserProfileResponse.fromJson(response);
  }

  Future<SubCategoryResponse> fetchSubCategory(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"sub-category",map);
    return SubCategoryResponse.fromJson(response);
  }

  Future<ProductResponse> fetchProductFilter(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"product_filter",map);
    return ProductResponse.fromJson(response);
  }

  Future<TagLineResponse> fetchTagLine(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"slogn",map);
    return TagLineResponse.fromJson(response);
  }

  Future<StateListResponse> fetchStateList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"state",map);
    return StateListResponse.fromJson(response);
  }

  Future<CityListResponse> fetchCityList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"state-by-city",map);
    return CityListResponse.fromJson(response);
  }

  Future<PincodeListResponse> fetchPinCodeList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"pincode",map);
    return PincodeListResponse.fromJson(response);
  }

  Future<FirebaseTokenPushResponse> apiFirebaseTokenPush(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"notification",map);
    return FirebaseTokenPushResponse.fromJson(response);
  }

  Future<DistanceMatrixResponse> apiDistanceMatrix(BuildContext context,Map<String,String>map) async {
    final response = await _provider.getMapDistance(context,"",map);
    return DistanceMatrixResponse.fromJson(response);
  }

  Future<NotificationListResponse> apiNotificationList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"notification",map);
    return NotificationListResponse.fromJson(response);
  }

  Future<NotificationViewedResponse> apiNotificationUpdate(BuildContext context,Map<String,String>map,int id) async {
    final response = await _provider.post(context,"notification/$id",map);
    return NotificationViewedResponse.fromJson(response);
  }

  Future<DeliveryChargeListResponse> apiDeliveryChargeList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"deliverycharges-list",map);
    return DeliveryChargeListResponse.fromJson(response);
  }

  Future<OrderCancelResponse> apiOrderCancel(BuildContext context,Map<String,String>map) async {
    final response = await _provider.post(context,"order-cancel",map);
    return OrderCancelResponse.fromJson(response);
  }

  Future<CustomerSupportResponse> apiCustomerSupport(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"customer-support",map);
    return CustomerSupportResponse.fromJson(response);
  }

  Future<LanguageListResponse> apiLanguageList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"language",map);
    return LanguageListResponse.fromJson(response);
  }

  Future<LanguageChangeResponse> apiLanguageChangeList(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"lang/change",map);
    return LanguageChangeResponse.fromJson(response);
  }

  Future<LogoutResponse> apiLogout(BuildContext context,Map<String,String>map) async {
    final response = await _provider.get(context,"logout",map);
    return LogoutResponse.fromJson(response);
  }

  Future<EaseBuzzPaymentInitResponse> easeBuzzPaymentInit(BuildContext context,Map<String,String>map)async{
    final response = await _provider.easeBuzzPaymentInit(context,map);
    return EaseBuzzPaymentInitResponse.fromJson(response);
  }






}