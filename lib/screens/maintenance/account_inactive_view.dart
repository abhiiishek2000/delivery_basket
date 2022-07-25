import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountInActiveView extends StatefulWidget {
  final String value;

  const AccountInActiveView({Key? key,required this.value}) : super(key: key);
  @override
  _AccountInActiveViewState createState() => _AccountInActiveViewState();
}

class _AccountInActiveViewState extends State<AccountInActiveView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.5),
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.exclamationTriangle,
                  size: 56,
                  color: Colors.red.withOpacity(0.6),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "${widget.value}",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                TextButton(onPressed: ()async{
                  Navigator.pop(context);
                }, child: Text("back"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
