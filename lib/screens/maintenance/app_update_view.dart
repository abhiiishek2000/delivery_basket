import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:delivery_basket/screens/login/login_screen.dart';

class AppUpdateView extends StatefulWidget {
  final String value;

  const AppUpdateView({Key? key,required this.value}) : super(key: key);
  @override
  _AppUpdateViewState createState() => _AppUpdateViewState();
}

class _AppUpdateViewState extends State<AppUpdateView> {
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(onPressed: ()async{
                      const url = 'https://play.google.com/store/apps/details?id=com.profcyma.vidarbha_basket';
                      if (await canLaunch(url)) {
                      await launch(url);
                      } else {
                      throw 'Could not launch $url';
                      }
                    }, child: Text("Update Now")),
                    TextButton(onPressed: ()async{
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
                    }, child: Text("Login")),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
