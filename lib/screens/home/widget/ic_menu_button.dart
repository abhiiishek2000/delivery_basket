import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuButton extends StatelessWidget {
  final Function() onClick;

  const MenuButton({Key? key, required this.onClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: SvgPicture.asset("assets/images/ic_menu.svg"),
      ),
    );
  }
}
