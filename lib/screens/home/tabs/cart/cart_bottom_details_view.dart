import 'package:flutter/material.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/screens/home/tabs/store/model/product_response.dart';
import 'package:delivery_basket/screens/home/welcome/welcome_screen.dart';
import 'package:delivery_basket/screens/pay/pay_screen.dart';

class CartBottomDetailsView extends StatefulWidget {
  final List<ProductResponseDataProdcutData?> product;

  const CartBottomDetailsView({Key? key,required this.product}) : super(key: key);
  @override
  _CartBottomDetailsViewState createState() => _CartBottomDetailsViewState();
}

class _CartBottomDetailsViewState extends State<CartBottomDetailsView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xffEAEAEA)),
        boxShadow: [
          BoxShadow(
            color: Color(0xffEAEAEA),
            spreadRadius: 1.0,
            offset: Offset(1.0,1.4)
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Subtotal",style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Color(0xff191919),fontSize: 18,fontWeight: FontWeight.w600),),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("₹ 160",style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 16,fontWeight: FontWeight.w600),),
                  SizedBox(width: 8,),
                  Text("(${widget.product.length} items)",style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Color(0xffA8A8A8)),)
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: ()async{
              bool? isUserLogin = await getLogin();
              if(isUserLogin??false){
               // Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckDetailsScreen(amount: 0.0,)));
              }else{
                Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomeScreen()));
              }
            },
            onLongPress: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PayScreen()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xff37AB01),
                borderRadius: BorderRadius.circular(4)
              ),
              child: Text("Checkout",style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white,fontSize: 18),),
            ),
          )
        ],
      ),
    );
  }
}
