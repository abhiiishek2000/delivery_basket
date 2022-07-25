import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:delivery_basket/data/local/shared_pref.dart';
import 'package:delivery_basket/data/remote/model/notification/notification_list_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';
import 'package:delivery_basket/screens/notification/notification_screen.dart';

class NotificationButtonView extends StatefulWidget {
  final int count;

  const NotificationButtonView({Key? key,required this.count}) : super(key: key);
  @override
  _NotificationButtonViewState createState() => _NotificationButtonViewState();
}

class _NotificationButtonViewState extends State<NotificationButtonView> {
  int notificationCount = 0;
  Repository? _repository;
  @override
  void initState() {
    _repository = Repository();
    super.initState();
    fetchNotificationList(1);
  }

  fetchNotificationList(int page) async {
    var map = Map<String, String>();
    map['page'] = "${page}";
    map['device_key'] = await getFirebaseToken();
    try {
      NotificationListResponse? response =
      await _repository?.apiNotificationList(context, map);
      if (response?.success ?? false) {

        notificationCount = response?.data?.notificationUnread??0;
        setState(() {
        });
        print("notification count $notificationCount");
      }
    } catch (e) {
      print("error: ${e.toString()}");

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  IconButton(onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreen()));
    }, icon: new Stack(
      children: <Widget>[
        FaIcon(FontAwesomeIcons.bell),
        if(notificationCount != 0)new Positioned(
          right: 0,
          child: new Container(
            padding: EdgeInsets.all(1),
            decoration: new BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            child: Center(
              child: new Text(
                '$notificationCount',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      ],
    ));
  }
}
