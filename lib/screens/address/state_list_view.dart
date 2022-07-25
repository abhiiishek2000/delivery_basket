import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delivery_basket/data/remote/model/address/state_list_response.dart';
import 'package:delivery_basket/data/remote/repository.dart';

class StateListView extends StatefulWidget {
  @override
  _StateListViewState createState() => _StateListViewState();
}

class _StateListViewState extends State<StateListView> {
  Repository? _repository;
  bool isLoading = false;
  List<StateListResponseDataState?>? stateList;
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
    try {
      StateListResponse? response =
      await _repository?.fetchStateList(context, map);
      setState(() {
        isLoading = false;
      });
      if (response?.success ?? false) {
        setState(() {
          stateList = [];
          stateList?.addAll(response!.data!.state!);
        });
      } else {
        Fluttertoast.showToast(msg: "state list not loaded");
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
        title: Text("Select State",style: TextStyle(color: Colors.black
        ),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: ListView.builder(
        itemCount: stateList?.length,
          shrinkWrap: true,
          itemBuilder: (context,index){
            StateListResponseDataState? state = stateList?[index];
        return ListTile(title: Text(state?.name??""),onTap: (){
          Navigator.pop(context,state);
        },);
      })
    );
  }
}
