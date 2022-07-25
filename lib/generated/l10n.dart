// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hi Welcome`
  String get welcomeText {
    return Intl.message(
      'Hi Welcome',
      name: 'welcomeText',
      desc: '',
      args: [],
    );
  }

  /// `Login successfully`
  String get loginSuccess {
    return Intl.message(
      'Login successfully',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get loginFailed {
    return Intl.message(
      'Login failed',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Hello User,`
  String get helloUser {
    return Intl.message(
      'Hello User,',
      name: 'helloUser',
      desc: '',
      args: [],
    );
  }

  /// `login to continue`
  String get loginToContinue {
    return Intl.message(
      'login to continue',
      name: 'loginToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Mobile`
  String get mobile {
    return Intl.message(
      'Mobile',
      name: 'mobile',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginpage {
    return Intl.message(
      'Login',
      name: 'loginpage',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `SIGN UP`
  String get signUp {
    return Intl.message(
      'SIGN UP',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Please enter mobile number`
  String get enterMobileNumber {
    return Intl.message(
      'Please enter mobile number',
      name: 'enterMobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid mobile number`
  String get enterValidMobileNumber {
    return Intl.message(
      'Please enter valid mobile number',
      name: 'enterValidMobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter password`
  String get enterPassword {
    return Intl.message(
      'Please enter password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be 3 to 15 characters`
  String get passwordLengthInvalid {
    return Intl.message(
      'Password must be 3 to 15 characters',
      name: 'passwordLengthInvalid',
      desc: '',
      args: [],
    );
  }

  /// `For Sign up`
  String get forSignUp {
    return Intl.message(
      'For Sign up',
      name: 'forSignUp',
      desc: '',
      args: [],
    );
  }

  /// `Please type your number below`
  String get pleaseEnterNumberBelow {
    return Intl.message(
      'Please type your number below',
      name: 'pleaseEnterNumberBelow',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get sendOtp {
    return Intl.message(
      'Send OTP',
      name: 'sendOtp',
      desc: '',
      args: [],
    );
  }

  /// `Otp send successfully`
  String get otpSendSuccessfully {
    return Intl.message(
      'Otp send successfully',
      name: 'otpSendSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Your number is already exist`
  String get numberAlreadyExist {
    return Intl.message(
      'Your number is already exist',
      name: 'numberAlreadyExist',
      desc: '',
      args: [],
    );
  }

  /// `Verification`
  String get verification {
    return Intl.message(
      'Verification',
      name: 'verification',
      desc: '',
      args: [],
    );
  }

  /// `We have just your phone an OTP, Please enter below to verify`
  String get enterOtpBelow {
    return Intl.message(
      'We have just your phone an OTP, Please enter below to verify',
      name: 'enterOtpBelow',
      desc: '',
      args: [],
    );
  }

  /// `Resend Otp`
  String get resendOtp {
    return Intl.message(
      'Resend Otp',
      name: 'resendOtp',
      desc: '',
      args: [],
    );
  }

  /// `Resend otp in `
  String get resendOtpIn {
    return Intl.message(
      'Resend otp in ',
      name: 'resendOtpIn',
      desc: '',
      args: [],
    );
  }

  /// `sec`
  String get sec {
    return Intl.message(
      'sec',
      name: 'sec',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Please enter otp`
  String get enterOtp {
    return Intl.message(
      'Please enter otp',
      name: 'enterOtp',
      desc: '',
      args: [],
    );
  }

  /// `Otp not matched`
  String get otpNotMatched {
    return Intl.message(
      'Otp not matched',
      name: 'otpNotMatched',
      desc: '',
      args: [],
    );
  }

  /// `Otp matched successfully`
  String get otpMatched {
    return Intl.message(
      'Otp matched successfully',
      name: 'otpMatched',
      desc: '',
      args: [],
    );
  }

  /// `Password change successfully`
  String get passwordChanged {
    return Intl.message(
      'Password change successfully',
      name: 'passwordChanged',
      desc: '',
      args: [],
    );
  }

  /// `Password change failed`
  String get passwordChangeFailed {
    return Intl.message(
      'Password change failed',
      name: 'passwordChangeFailed',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter new password`
  String get pleaseEnterNewPassword {
    return Intl.message(
      'Please enter new password',
      name: 'pleaseEnterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter repeat password`
  String get pleaseEnterRepeatPassword {
    return Intl.message(
      'Please enter repeat password',
      name: 'pleaseEnterRepeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password not match`
  String get passwordNotMatched {
    return Intl.message(
      'Password not match',
      name: 'passwordNotMatched',
      desc: '',
      args: [],
    );
  }

  /// `Re-Password`
  String get rePassword {
    return Intl.message(
      'Re-Password',
      name: 'rePassword',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Registration successfully`
  String get registrationSuccessfully {
    return Intl.message(
      'Registration successfully',
      name: 'registrationSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed`
  String get registrationFailed {
    return Intl.message(
      'Registration failed',
      name: 'registrationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please type your information below`
  String get pleaseTypeYourInformationBelow {
    return Intl.message(
      'Please type your information below',
      name: 'pleaseTypeYourInformationBelow',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get fullName {
    return Intl.message(
      'Full name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get optional {
    return Intl.message(
      'Optional',
      name: 'optional',
      desc: '',
      args: [],
    );
  }

  /// `By signing up, I agree your terms & conditions`
  String get iAgreeTermConditions {
    return Intl.message(
      'By signing up, I agree your terms & conditions',
      name: 'iAgreeTermConditions',
      desc: '',
      args: [],
    );
  }

  /// `Please enter name`
  String get pleaseEnterName {
    return Intl.message(
      'Please enter name',
      name: 'pleaseEnterName',
      desc: '',
      args: [],
    );
  }

  /// `Already, have an account? `
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already, have an account? ',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Fresh fruits`
  String get introFirstHeadline {
    return Intl.message(
      'Fresh fruits',
      name: 'introFirstHeadline',
      desc: '',
      args: [],
    );
  }

  /// `Fresh vegetables`
  String get introSecondHeadline {
    return Intl.message(
      'Fresh vegetables',
      name: 'introSecondHeadline',
      desc: '',
      args: [],
    );
  }

  /// `Affordable rates.`
  String get introThirdHeadline {
    return Intl.message(
      'Affordable rates.',
      name: 'introThirdHeadline',
      desc: '',
      args: [],
    );
  }

  /// `We deliver fresh and organic fruits directly from the farms with high nutritious values which help in the healthy growth of the body.`
  String get introFirst {
    return Intl.message(
      'We deliver fresh and organic fruits directly from the farms with high nutritious values which help in the healthy growth of the body.',
      name: 'introFirst',
      desc: '',
      args: [],
    );
  }

  /// `We deliver the healthy and fresh quality of vegetable which are directly from the farms containing a high level of healthy proteins and vitamins.`
  String get introSecond {
    return Intl.message(
      'We deliver the healthy and fresh quality of vegetable which are directly from the farms containing a high level of healthy proteins and vitamins.',
      name: 'introSecond',
      desc: '',
      args: [],
    );
  }

  /// `The rates of fruits and vegetables from the Vidarbha basket are very affordable and cheap so that everyone can avail of its facility with the fastest delivery.`
  String get introThird {
    return Intl.message(
      'The rates of fruits and vegetables from the Vidarbha basket are very affordable and cheap so that everyone can avail of its facility with the fastest delivery.',
      name: 'introThird',
      desc: '',
      args: [],
    );
  }

  /// `Store`
  String get store {
    return Intl.message(
      'Store',
      name: 'store',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Offers`
  String get offers {
    return Intl.message(
      'Offers',
      name: 'offers',
      desc: '',
      args: [],
    );
  }

  /// `Wishlist`
  String get wishlist {
    return Intl.message(
      'Wishlist',
      name: 'wishlist',
      desc: '',
      args: [],
    );
  }

  /// `Alert`
  String get alert {
    return Intl.message(
      'Alert',
      name: 'alert',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure close application?`
  String get areYouSureCLoseApp {
    return Intl.message(
      'Are you sure close application?',
      name: 'areYouSureCLoseApp',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get myOrders {
    return Intl.message(
      'My Orders',
      name: 'myOrders',
      desc: '',
      args: [],
    );
  }

  /// `Please login first to perform operation`
  String get pleaseLoginFirst {
    return Intl.message(
      'Please login first to perform operation',
      name: 'pleaseLoginFirst',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get wallet {
    return Intl.message(
      'Wallet',
      name: 'wallet',
      desc: '',
      args: [],
    );
  }

  /// `My delivery address`
  String get myDeliveryAddress {
    return Intl.message(
      'My delivery address',
      name: 'myDeliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `No Address found`
  String get noAddressFound {
    return Intl.message(
      'No Address found',
      name: 'noAddressFound',
      desc: '',
      args: [],
    );
  }

  /// `All Products`
  String get allProducts {
    return Intl.message(
      'All Products',
      name: 'allProducts',
      desc: '',
      args: [],
    );
  }

  /// `Morning`
  String get morning {
    return Intl.message(
      'Morning',
      name: 'morning',
      desc: '',
      args: [],
    );
  }

  /// `Afternoon`
  String get afternoon {
    return Intl.message(
      'Afternoon',
      name: 'afternoon',
      desc: '',
      args: [],
    );
  }

  /// `Evening`
  String get evening {
    return Intl.message(
      'Evening',
      name: 'evening',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `Good`
  String get good {
    return Intl.message(
      'Good',
      name: 'good',
      desc: '',
      args: [],
    );
  }

  /// `Explore by category`
  String get shopByCategory {
    return Intl.message(
      'Explore by category',
      name: 'shopByCategory',
      desc: '',
      args: [],
    );
  }

  /// `Today's offers`
  String get todaysOffer {
    return Intl.message(
      'Today\'s offers',
      name: 'todaysOffer',
      desc: '',
      args: [],
    );
  }

  /// `PRICE DETAILS`
  String get priceDetail {
    return Intl.message(
      'PRICE DETAILS',
      name: 'priceDetail',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Items`
  String get items {
    return Intl.message(
      'Items',
      name: 'items',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Charges`
  String get deliveryCharges {
    return Intl.message(
      'Delivery Charges',
      name: 'deliveryCharges',
      desc: '',
      args: [],
    );
  }

  /// `Free`
  String get free {
    return Intl.message(
      'Free',
      name: 'free',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get totalAmount {
    return Intl.message(
      'Total Amount',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `You will save`
  String get youWllSave {
    return Intl.message(
      'You will save',
      name: 'youWllSave',
      desc: '',
      args: [],
    );
  }

  /// `on this order`
  String get onThisOrder {
    return Intl.message(
      'on this order',
      name: 'onThisOrder',
      desc: '',
      args: [],
    );
  }

  /// `Save extra amount using offers`
  String get saveExtraAmountUsingOffers {
    return Intl.message(
      'Save extra amount using offers',
      name: 'saveExtraAmountUsingOffers',
      desc: '',
      args: [],
    );
  }

  /// `Please wait`
  String get pleaseWait {
    return Intl.message(
      'Please wait',
      name: 'pleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get weight {
    return Intl.message(
      'Weight',
      name: 'weight',
      desc: '',
      args: [],
    );
  }

  /// `Cart Deleted`
  String get cartDeleted {
    return Intl.message(
      'Cart Deleted',
      name: 'cartDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Out of Stock!`
  String get outOfStock {
    return Intl.message(
      'Out of Stock!',
      name: 'outOfStock',
      desc: '',
      args: [],
    );
  }

  /// `Subtotal`
  String get subTotal {
    return Intl.message(
      'Subtotal',
      name: 'subTotal',
      desc: '',
      args: [],
    );
  }

  /// `Minimum order price is `
  String get minimumOrderPriceIs {
    return Intl.message(
      'Minimum order price is ',
      name: 'minimumOrderPriceIs',
      desc: '',
      args: [],
    );
  }

  /// `Please remove out of stock product`
  String get pleaseRemoveOutOfStockProduct {
    return Intl.message(
      'Please remove out of stock product',
      name: 'pleaseRemoveOutOfStockProduct',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Vidarbha Basket`
  String get vidarbhaBasket {
    return Intl.message(
      'Vidarbha Basket',
      name: 'vidarbhaBasket',
      desc: '',
      args: [],
    );
  }

  /// `Cart is empty`
  String get cartIsEmpty {
    return Intl.message(
      'Cart is empty',
      name: 'cartIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Cart Updated`
  String get cartUpdated {
    return Intl.message(
      'Cart Updated',
      name: 'cartUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Offers not available`
  String get offersNotAvailable {
    return Intl.message(
      'Offers not available',
      name: 'offersNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Wish List is empty`
  String get wishListIsEmpty {
    return Intl.message(
      'Wish List is empty',
      name: 'wishListIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Add all to cart`
  String get addAllToCart {
    return Intl.message(
      'Add all to cart',
      name: 'addAllToCart',
      desc: '',
      args: [],
    );
  }

  /// `product out of stock`
  String get productOutOfStock {
    return Intl.message(
      'product out of stock',
      name: 'productOutOfStock',
      desc: '',
      args: [],
    );
  }

  /// `product price is zero`
  String get productPriceIsZero {
    return Intl.message(
      'product price is zero',
      name: 'productPriceIsZero',
      desc: '',
      args: [],
    );
  }

  /// `removed from wish list`
  String get removedFromWishList {
    return Intl.message(
      'removed from wish list',
      name: 'removedFromWishList',
      desc: '',
      args: [],
    );
  }

  /// `failed`
  String get failed {
    return Intl.message(
      'failed',
      name: 'failed',
      desc: '',
      args: [],
    );
  }

  /// `Product added to cart successfully`
  String get productAddedToCartSuccess {
    return Intl.message(
      'Product added to cart successfully',
      name: 'productAddedToCartSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Please select address`
  String get selectAddress {
    return Intl.message(
      'Please select address',
      name: 'selectAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please select delivery date`
  String get selectDeliveryDate {
    return Intl.message(
      'Please select delivery date',
      name: 'selectDeliveryDate',
      desc: '',
      args: [],
    );
  }

  /// `Please select time slot`
  String get selectTimeSlot {
    return Intl.message(
      'Please select time slot',
      name: 'selectTimeSlot',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Order`
  String get confirmOrder {
    return Intl.message(
      'Confirm Order',
      name: 'confirmOrder',
      desc: '',
      args: [],
    );
  }

  /// `Delivery from`
  String get deliveryFrom {
    return Intl.message(
      'Delivery from',
      name: 'deliveryFrom',
      desc: '',
      args: [],
    );
  }

  /// `At Home`
  String get atHome {
    return Intl.message(
      'At Home',
      name: 'atHome',
      desc: '',
      args: [],
    );
  }

  /// `Self Pickup`
  String get selfPickUp {
    return Intl.message(
      'Self Pickup',
      name: 'selfPickUp',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `My delivery and billing addresses are the same`
  String get myDeliveryAddressAndBillingAddressSame {
    return Intl.message(
      'My delivery and billing addresses are the same',
      name: 'myDeliveryAddressAndBillingAddressSame',
      desc: '',
      args: [],
    );
  }

  /// `Order Bill`
  String get orderBill {
    return Intl.message(
      'Order Bill',
      name: 'orderBill',
      desc: '',
      args: [],
    );
  }

  /// `Order List`
  String get orderList {
    return Intl.message(
      'Order List',
      name: 'orderList',
      desc: '',
      args: [],
    );
  }

  /// `Total Price`
  String get totalPrice {
    return Intl.message(
      'Total Price',
      name: 'totalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Fee`
  String get deliveryFee {
    return Intl.message(
      'Delivery Fee',
      name: 'deliveryFee',
      desc: '',
      args: [],
    );
  }

  /// `Coupon Amount`
  String get couponAmount {
    return Intl.message(
      'Coupon Amount',
      name: 'couponAmount',
      desc: '',
      args: [],
    );
  }

  /// `Discounted Amount`
  String get discountedAmount {
    return Intl.message(
      'Discounted Amount',
      name: 'discountedAmount',
      desc: '',
      args: [],
    );
  }

  /// `Total Bill`
  String get totalBill {
    return Intl.message(
      'Total Bill',
      name: 'totalBill',
      desc: '',
      args: [],
    );
  }

  /// `Coupon applied successfully`
  String get couponAppliedSuccessfully {
    return Intl.message(
      'Coupon applied successfully',
      name: 'couponAppliedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Order placed successfully`
  String get orderPlacedSuccessfully {
    return Intl.message(
      'Order placed successfully',
      name: 'orderPlacedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Coupon`
  String get coupon {
    return Intl.message(
      'Coupon',
      name: 'coupon',
      desc: '',
      args: [],
    );
  }

  /// `Enter coupon code`
  String get enterCouponCode {
    return Intl.message(
      'Enter coupon code',
      name: 'enterCouponCode',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `You saved`
  String get youSaved {
    return Intl.message(
      'You saved',
      name: 'youSaved',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to Pay`
  String get proceedToPay {
    return Intl.message(
      'Proceed to Pay',
      name: 'proceedToPay',
      desc: '',
      args: [],
    );
  }

  /// `Add New Address`
  String get addNewAddress {
    return Intl.message(
      'Add New Address',
      name: 'addNewAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please type your phone number below and we can see reset password`
  String get forgotPasswordDesc {
    return Intl.message(
      'Please type your phone number below and we can see reset password',
      name: 'forgotPasswordDesc',
      desc: '',
      args: [],
    );
  }

  /// `Address Updated successfully`
  String get addressUpdatedSuccessfully {
    return Intl.message(
      'Address Updated successfully',
      name: 'addressUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Address added successfully`
  String get addressAddedSuccessfully {
    return Intl.message(
      'Address added successfully',
      name: 'addressAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `failed to update address`
  String get failedToUpateAddress {
    return Intl.message(
      'failed to update address',
      name: 'failedToUpateAddress',
      desc: '',
      args: [],
    );
  }

  /// `failed to add address`
  String get failedToaddAddress {
    return Intl.message(
      'failed to add address',
      name: 'failedToaddAddress',
      desc: '',
      args: [],
    );
  }

  /// `Sorry for inconvenience`
  String get sorryForInconvenience {
    return Intl.message(
      'Sorry for inconvenience',
      name: 'sorryForInconvenience',
      desc: '',
      args: [],
    );
  }

  /// `Delivery is not available on this pincode. We will start delivery soon in your area`
  String get deliveryNotAvailable {
    return Intl.message(
      'Delivery is not available on this pincode. We will start delivery soon in your area',
      name: 'deliveryNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Flat No. /House No. /Bldg`
  String get flatNo {
    return Intl.message(
      'Flat No. /House No. /Bldg',
      name: 'flatNo',
      desc: '',
      args: [],
    );
  }

  /// `Colony, Street, Landmark`
  String get landmark {
    return Intl.message(
      'Colony, Street, Landmark',
      name: 'landmark',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get state {
    return Intl.message(
      'State',
      name: 'state',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid pin code`
  String get enterValidPinCode {
    return Intl.message(
      'Please enter valid pin code',
      name: 'enterValidPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter`
  String get pleaseEnter {
    return Intl.message(
      'Please Enter',
      name: 'pleaseEnter',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Pincode`
  String get pincode {
    return Intl.message(
      'Pincode',
      name: 'pincode',
      desc: '',
      args: [],
    );
  }

  /// `Default Delivery Address`
  String get defaultDeliveryAddress {
    return Intl.message(
      'Default Delivery Address',
      name: 'defaultDeliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Change delivery address`
  String get changeDeliveryAddress {
    return Intl.message(
      'Change delivery address',
      name: 'changeDeliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueText {
    return Intl.message(
      'Continue',
      name: 'continueText',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure delete address?`
  String get areYouSureDeleteAddress {
    return Intl.message(
      'Are you sure delete address?',
      name: 'areYouSureDeleteAddress',
      desc: '',
      args: [],
    );
  }

  /// `Default address`
  String get defaultAddress {
    return Intl.message(
      'Default address',
      name: 'defaultAddress',
      desc: '',
      args: [],
    );
  }

  /// `Address list is empty`
  String get addressListIsEmpty {
    return Intl.message(
      'Address list is empty',
      name: 'addressListIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Order List is empty`
  String get orderListIsEmpty {
    return Intl.message(
      'Order List is empty',
      name: 'orderListIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Order Number`
  String get orderNo {
    return Intl.message(
      'Order Number',
      name: 'orderNo',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Date`
  String get deliveryDate {
    return Intl.message(
      'Delivery Date',
      name: 'deliveryDate',
      desc: '',
      args: [],
    );
  }

  /// `Time Slot`
  String get timeSlot {
    return Intl.message(
      'Time Slot',
      name: 'timeSlot',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Order ID`
  String get orderId {
    return Intl.message(
      'Order ID',
      name: 'orderId',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message(
      'Quantity',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  /// `Order Summary`
  String get orderSummary {
    return Intl.message(
      'Order Summary',
      name: 'orderSummary',
      desc: '',
      args: [],
    );
  }

  /// `Order Status`
  String get orderStatus {
    return Intl.message(
      'Order Status',
      name: 'orderStatus',
      desc: '',
      args: [],
    );
  }

  /// `Payment Status`
  String get paymentStatus {
    return Intl.message(
      'Payment Status',
      name: 'paymentStatus',
      desc: '',
      args: [],
    );
  }

  /// `Payment Options`
  String get paymentOptions {
    return Intl.message(
      'Payment Options',
      name: 'paymentOptions',
      desc: '',
      args: [],
    );
  }

  /// `UPI`
  String get upi {
    return Intl.message(
      'UPI',
      name: 'upi',
      desc: '',
      args: [],
    );
  }

  /// `Credit card / Debit Card / Net Banking `
  String get netBanking {
    return Intl.message(
      'Credit card / Debit Card / Net Banking ',
      name: 'netBanking',
      desc: '',
      args: [],
    );
  }

  /// `Order Details`
  String get orderDetails {
    return Intl.message(
      'Order Details',
      name: 'orderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Summary`
  String get walletSummary {
    return Intl.message(
      'Wallet Summary',
      name: 'walletSummary',
      desc: '',
      args: [],
    );
  }

  /// `Current balance Rs.`
  String get currentBalance {
    return Intl.message(
      'Current balance Rs.',
      name: 'currentBalance',
      desc: '',
      args: [],
    );
  }

  /// `Fund Wallet`
  String get fundWallet {
    return Intl.message(
      'Fund Wallet',
      name: 'fundWallet',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Activity`
  String get walletActivity {
    return Intl.message(
      'Wallet Activity',
      name: 'walletActivity',
      desc: '',
      args: [],
    );
  }

  /// `Please enter amount`
  String get enterAmount {
    return Intl.message(
      'Please enter amount',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Add Amount`
  String get addAmount {
    return Intl.message(
      'Add Amount',
      name: 'addAmount',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Options`
  String get deliveryOptions {
    return Intl.message(
      'Delivery Options',
      name: 'deliveryOptions',
      desc: '',
      args: [],
    );
  }

  /// `Sub Category not available `
  String get subCategoryNotAvailable {
    return Intl.message(
      'Sub Category not available ',
      name: 'subCategoryNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `View all products in`
  String get viewAllProductsIn {
    return Intl.message(
      'View all products in',
      name: 'viewAllProductsIn',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message(
      'Add to Cart',
      name: 'addToCart',
      desc: '',
      args: [],
    );
  }

  /// `Safe`
  String get safe {
    return Intl.message(
      'Safe',
      name: 'safe',
      desc: '',
      args: [],
    );
  }

  /// `Quality`
  String get quality {
    return Intl.message(
      'Quality',
      name: 'quality',
      desc: '',
      args: [],
    );
  }

  /// `Fresh`
  String get fresh {
    return Intl.message(
      'Fresh',
      name: 'fresh',
      desc: '',
      args: [],
    );
  }

  /// `Similar Products`
  String get similarProducts {
    return Intl.message(
      'Similar Products',
      name: 'similarProducts',
      desc: '',
      args: [],
    );
  }

  /// `Customer Support`
  String get customerSupport {
    return Intl.message(
      'Customer Support',
      name: 'customerSupport',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure Logout`
  String get areYouSureLogout {
    return Intl.message(
      'Are you sure Logout',
      name: 'areYouSureLogout',
      desc: '',
      args: [],
    );
  }

  /// `USE MY LOCATION`
  String get useMyLocation {
    return Intl.message(
      'USE MY LOCATION',
      name: 'useMyLocation',
      desc: '',
      args: [],
    );
  }

  /// `USE OTHER LOCATION`
  String get useOtherLocation {
    return Intl.message(
      'USE OTHER LOCATION',
      name: 'useOtherLocation',
      desc: '',
      args: [],
    );
  }

  /// `Delivery charges may apply according to your location`
  String get deliveryChargesVary {
    return Intl.message(
      'Delivery charges may apply according to your location',
      name: 'deliveryChargesVary',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Recent Search`
  String get recentSearch {
    return Intl.message(
      'Recent Search',
      name: 'recentSearch',
      desc: '',
      args: [],
    );
  }

  /// `Popular Search`
  String get popularSearch {
    return Intl.message(
      'Popular Search',
      name: 'popularSearch',
      desc: '',
      args: [],
    );
  }

  /// `Product not available`
  String get productNotAvailable {
    return Intl.message(
      'Product not available',
      name: 'productNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Cash on Delivery`
  String get cod {
    return Intl.message(
      'Cash on Delivery',
      name: 'cod',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient Amount in Wallet`
  String get insufficientAmountInWallet {
    return Intl.message(
      'Insufficient Amount in Wallet',
      name: 'insufficientAmountInWallet',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'gu'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'mr'),
      Locale.fromSubtags(languageCode: 'ta'),
      Locale.fromSubtags(languageCode: 'te'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
