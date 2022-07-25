import 'package:flutter/foundation.dart';


class CheckOutNotifier extends ChangeNotifier{
  int addressId = -1;
  int deliveryOption = 0;
  String deliveryDate = "";
  int timeSlot = -1;
  String couponCode = "";
  String paymentType = "";
  int paymentStatus = -1;
  String razorPayPaymentId = "";
  String orderId = "";
  String signature = "";
  String comment = "";

  int cartCount = 0;

  void cartCountUpdate(int cart) {
    cartCount = cart;
    notifyListeners();
  }
  void cartIncrement() {
    cartCount = cartCount+1;
    notifyListeners();
  }
  void cartDecrement() {
    cartCount = cartCount-1;
    notifyListeners();
  }
}

