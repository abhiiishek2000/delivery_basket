import 'package:flutter/material.dart';
import 'package:delivery_basket/screens/home/widget/ic_menu_button.dart';

class BasketAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 56),
      child: Row(
        children: [
          MenuButton(onClick: (){
            Scaffold.of(context).openDrawer();
          },),
        ],
      ),
    );
  }
}



