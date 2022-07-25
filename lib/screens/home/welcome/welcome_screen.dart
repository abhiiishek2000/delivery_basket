import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:delivery_basket/constants.dart';
import 'package:delivery_basket/screens/login/login_screen.dart';
import 'package:delivery_basket/screens/signup/mobile_fill_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Image.asset("assets/images/ic_welcome_header.png"),

        Positioned(
          left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Welcome!",style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black,fontWeight: FontWeight.w600),),
                  SizedBox(height: 16,),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text("Login",style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white),)),
                    ),
                  ),
                  SizedBox(height: 16,),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MobileFillScreen()));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kPrimaryColor)
                      ),
                      child: Center(child: Text("Sign up",style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.black),)),
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
