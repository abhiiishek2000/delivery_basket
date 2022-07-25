import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:delivery_basket/constants.dart';

import 'check_details/order_success_dialog_view.dart';

class TestView extends StatefulWidget {
  @override
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ElevatedButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderSuccessDialogView()));
      },child: Text("open dialog"),),
    ));
  }



}
