import 'package:flutter/material.dart';

class ProductRatingView extends StatefulWidget {
  @override
  _ProductRatingViewState createState() => _ProductRatingViewState();
}

class _ProductRatingViewState extends State<ProductRatingView> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 45,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xfF1F1F1)),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(color: Color(0xfF1F1F1),spreadRadius: 3,offset: Offset(0.2,1.2))
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.star,color: Color(0xffF1D903),size: 20,),
          SizedBox(width: 2,),
          Text("5",style: Theme.of(context).textTheme.bodyText2,)
        ],
      ),
    );
  }
}
