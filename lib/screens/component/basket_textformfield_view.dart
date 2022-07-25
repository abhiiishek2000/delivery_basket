import 'package:flutter/material.dart';

class BasketTextFormFieldView extends StatefulWidget {
  final String hint;
  final String text;

  const BasketTextFormFieldView({Key? key,required this.hint,required this.text}) : super(key: key);

  @override
  _BasketTextFormFieldViewState createState() => _BasketTextFormFieldViewState();
}

class _BasketTextFormFieldViewState extends State<BasketTextFormFieldView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
            labelText: widget.hint,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xffDBDBDB)),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffDBDBDB)),
              borderRadius: BorderRadius.circular(15),
            )),
      ),
    );
  }
}
