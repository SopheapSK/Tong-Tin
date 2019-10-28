

import 'dart:async';

import 'package:TonTin/pages/main_page.dart';
import 'package:TonTin/util/NetworkService.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'dart:convert' as JSON;
class WingPayReport extends StatefulWidget {
  static String tag = 'WingPayReport';
  @override
  _WingPayReportState createState() => _WingPayReportState();

}

class _WingPayReportState extends State<WingPayReport> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKey');
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>(debugLabel: '_refreshIndicator');

  bool _isLoading = true;
  int _seletedPage = 0;
  bool _isUSDAccountSelected = true;
  _getSeletedtPage (int page){

  }


  Future<void> _handleRefresh() async {
    setState(() {
    });
    _callApi();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //_callApi();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    final bodyNew =  new Container();

    var progressBarLoadMore = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            height: 20,
            width: 20,
            margin: EdgeInsets.all(5),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor : AlwaysStoppedAnimation(Colors.blue),
            ),
          ),
        ),
      ],
    );

    var progressBar = new Container(
      decoration: new BoxDecoration(color: Colors.white),
      child: new Center(
        child: new CircularProgressIndicator(),
      ),
    );

    return new WillPopScope(
      onWillPop: _onBackPress,
      child: new Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _onBackPress(),
          ),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Color.fromARGB(255, 	176, 192, 37),
          title: Stack(
            children: <Widget>[
              Align(alignment: Alignment(-0.3, 0.0), child: Text("List Report" , style: TextStyle(color: Colors.white),)),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
           accountBar(),
            Expanded(child: _isLoading ? progressBar : bodyNew),


          ],
        ),
      ),
    );
  }
  Future<bool> _onBackPress() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new DrawerSlideWithHeader()));
    // Navigator.pop(context);
    return null;
  }

  void _callApi(){
    var res = NetworkUtil.makeRequestWithToken("/api/account/notification?start=&limit=20&master_account_id=MST000004431", null, Method.GET);



    res?.then((response) {
      var result = response?.getSuccessResponse();

      if(result == null){
        _scaffoldKey.currentState?.showSnackBar(SnackBar(
            content: const Text('Error Fetching Data'),
            action: SnackBarAction(
                label: 'RETRY',
                onPressed: () {
                  _refreshIndicatorKey.currentState.show();
                })));
        return;
      }

      print('report: $result');

      var me = JSON.jsonDecode(result);


    });
  }
    Widget accountBar () {
      return new Padding(padding: EdgeInsets.all(8.0),
        child: Card(color: Colors.white, elevation: 1.0,
          child: Container(height: 40.0,
            width: double.infinity,
            padding: EdgeInsets.all(0.2),
            decoration: new BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueAccent)
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: new BoxDecoration(
                      color: _isUSDAccountSelected ? Colors.blueAccent : Colors.white,
                    ),
                    child: new InkWell(
                      onTap: () { _accountTap('USD');},
                      child: new Center(
                        child: new Text('USD',
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: new TextStyle(fontSize: 14.0,
                                color: _isUSDAccountSelected ?  Colors.white :Colors.blue ,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: new BoxDecoration(
                      color: _isUSDAccountSelected ? Colors.white : Colors.blueAccent,
                    ),
                  child: new InkWell(onTap: () {
                    _accountTap('KHR');
                  },
                    child: new Center(
                      child: new Text('KHR',
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                          style: new TextStyle(fontSize: 14.0,
                              color: _isUSDAccountSelected ? Colors.blue : Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
                )
              ],
            ),
          ),
        ),
      );
    }

  void  _accountTap(String account){
      setState(() {
        if(account == 'USD')
          _isUSDAccountSelected = true;
        else _isUSDAccountSelected = false;
      });
    }
    // sopheap@asdf
}
