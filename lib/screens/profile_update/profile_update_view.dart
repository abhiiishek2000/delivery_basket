import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/screens/component/basket_textformfield_view.dart';

class ProfileUpdateView extends StatefulWidget {
  @override
  _ProfileUpdateViewState createState() => _ProfileUpdateViewState();
}

class _ProfileUpdateViewState extends State<ProfileUpdateView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            BasketTextFormFieldView(hint: "Jayesh",text: "",),
            BasketTextFormFieldView(hint: "Shinde",text: "",),
            BasketTextFormFieldView(hint: "+91 7304610113",text: "",),
            BasketTextFormFieldView(hint: "jayesh.shinde@profcyma.com",text: "",),
            Row(
              children: [
                Checkbox(value: false, onChanged: (value){},checkColor: kPrimaryColor,),
                SizedBox(width: 8,),
                Expanded(child: Text("You can send me promotional emails, offers and service offers"))
              ],
            ),
            Spacer(),
            CupertinoButton(child: Text("Update"), onPressed: (){},color: kPrimaryColor,),
            SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xffF1F1F1).withOpacity(0.9),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xffF1F1F1),
                        offset: Offset(0.3, 1.0),
                        blurRadius: 3.0)
                  ]),
              child: SvgPicture.asset("assets/images/ic_back.svg"),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                "Profile",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
