import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delivery_basket/data/remote/model/address/city_list_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';

class CityListView extends StatefulWidget {
  final int stateId;

  const CityListView({Key? key,required this.stateId}) : super(key: key);
  @override
  _CityListViewState createState() => _CityListViewState();
}

class _CityListViewState extends State<CityListView> {
  Repository? _repository;
  bool isLoading = false;
  List<CityListResponseDataCity?>? cityList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository = Repository();
    fetchStateList();
  }

  fetchStateList() async {
    setState(() {
      isLoading = true;
    });
    var map = Map<String, String>();
    map['state_id'] = widget.stateId.toString();
    try {
      CityListResponse? response =
      await _repository?.fetchCityList(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          cityList = [];
          cityList?.addAll(response!.data!.city!);
        });
      } else {
        Fluttertoast.showToast(msg: "city list not loaded");
      }
    } catch (e) {
      print("error: ${e.toString()}");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select City",style: TextStyle(color: Colors.black
          ),),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
              color: Colors.black
          ),
        ),
        body: ListView.builder(
            itemCount: cityList?.length,
            shrinkWrap: true,
            itemBuilder: (context,index){
              CityListResponseDataCity? state = cityList?[index];
              return ListTile(title: Text(state?.name??""),onTap: (){
                Navigator.pop(context,state);
              },);
            })
    );
  }
}