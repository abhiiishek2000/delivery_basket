import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class BasketButton extends StatefulWidget {
  final String title;
  final Function() onClick;

  const BasketButton({Key? key, required this.title, required this.onClick})
      : super(key: key);
  @override
  _BasketButtonState createState() => _BasketButtonState();
}

class _BasketButtonState extends State<BasketButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onClick,
      child: Container(
        width: 90,
        height: 44,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${widget.title}",
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  'Lato',
                  color: Color(0xFF323232),
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                )),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        primary: kPrimaryColor,
        onPrimary: Color(0xff323232),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
