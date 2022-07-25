import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BasketCartButton extends StatefulWidget {
  final Function onclick;

  const BasketCartButton({Key? key,required this.onclick}) : super(key: key);
  @override
  _BasketCartButtonState createState() => _BasketCartButtonState();
}

class _BasketCartButtonState extends State<BasketCartButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onclick(),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Color(0xff37AB01),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color(0xff37AB01).withOpacity(0.3)
            )
          ]
        ),
        child: SvgPicture.asset("assets/images/ic_cart_small.svg",height: 20,width: 20,),
      ),
    );
  }
}
