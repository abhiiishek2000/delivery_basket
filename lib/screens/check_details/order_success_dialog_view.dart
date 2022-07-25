import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:delivery_basket/screens/home/home_screen.dart';

class OrderSuccessDialogView extends StatefulWidget {
  @override
  _OrderSuccessDialogViewState createState() => _OrderSuccessDialogViewState();
}

class _OrderSuccessDialogViewState extends State<OrderSuccessDialogView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.3),
        body: Center(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 26),
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3)
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 8,),
                      Text("Thank you",style: Theme.of(context).textTheme.bodyText2,),
                      SizedBox(height: 8,),
                      Text("Order Successful",style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w500),),
                      SizedBox(height: 8,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text("The system is processing your order. The progress can be seen at success",style: Theme.of(context).textTheme.caption,textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 16,),
                      Image.asset("assets/images/ic_check_order.png",height: 56,),
                      SizedBox(height: 8,),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 0,
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xffFEDD14),
                  child: IconButton(
                    icon: SvgPicture.asset("assets/images/ic_close.svg"),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
