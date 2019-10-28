import 'dart:async';

import 'package:TonTin/model/list_notification.dart';
import 'package:TonTin/pages/main_page.dart';
import 'package:TonTin/util/NetworkService.dart';
import 'package:TonTin/util/constant.dart';
import 'package:TonTin/util/share_pref.dart';
import 'package:TonTin/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert' as JSON;

import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:vibrate/vibrate.dart';

class ListReportSticky extends StatefulWidget {
  static String tag = 'ListNotificationReport';

  @override
  _ListReportStickyState createState() => _ListReportStickyState();
}

class _ListReportStickyState extends State<ListReportSticky> {
  ListNotificationModel listNotificationModel;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKey');
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>(debugLabel: '_refreshIndicator');
  ScrollController _controller;

  bool _isBottomLoading = false;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  var _currentPage = 1;

  Future<void> _handleRefresh() async {
    setState(() {
      listNotificationModel.notifications.clear();
      _currentPage = 1;
    });
    _startHaptic(FeedbackType.medium);
    _callApi();
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();

    _callApi();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bodyNew = LiquidPullToRefresh(
        color:  Color.fromARGB(255, 176, 192, 37),
        backgroundColor: Colors.white, //Color.fromARGB(255, 176, 192, 37)
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        scrollController: _controller,
        child: ListView.builder(
            itemCount: listNotificationModel?.notifications?.length,
            itemBuilder: (context, index) {
              final String content =
                  listNotificationModel.notifications[index]?.contentSms;

              final String title =
                  listNotificationModel.notifications[index]?.titleEn;
              final createOnDate =
                  listNotificationModel.notifications[index]?.createOn?.trim();
              final createOnOld = listNotificationModel
                  .notifications[index == 0 ? index : index - 1]?.createOn
                  ?.split('|')[0]
                  ?.trim();
              final createOn = listNotificationModel
                  .notifications[index]?.createOn
                  ?.split('|')[0]
                  ?.trim();
              final listSize = listNotificationModel.notifications.length;
              final createOnNext = listNotificationModel
                  .notifications[index < listSize - 1 ? index + 1 : index]
                  ?.createOn
                  ?.split('|')[0]
                  ?.trim();
              var isHeader = index == 0 || (createOn != createOnOld);
              var isDivider = createOn == createOnNext;

              return StickyHeader(
                header: !isHeader
                    ? Container()
                    : Container(
                        height: 30.0,
                        color: Colors.lightBlue,
                        padding:
                            EdgeInsets.only(left: 4.0, top: 4.0, bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ' $createOn ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                content: GestureDetector(
                  onTap: () {
                    _showMessage(context, title, content);
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                        child: Text(
                          createOnDate,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                        child: Text(
                          title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                        child: Text(
                          content,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: (isDivider)
                            ? Divider(
                                thickness: 0.6,
                              )
                            : Container(),
                      ),
                      new GestureDetector(
                        onTap: () {print('tap bottom');},
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                          child: (_hasMore)
                              ? Container()
                              : listSize == index + 1
                                  ? Text('No More Data',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold))
                                  : Container(),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));

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
              valueColor: AlwaysStoppedAnimation(Colors.blue),
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
          backgroundColor: Color.fromARGB(255, 176, 192, 37),
          title: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment(-0.3, 0.0),
                  child: Text(
                    "List Report",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
        body: Container(
          decoration: new BoxDecoration(color: Colors.white),
          child: Column(
            children: <Widget>[
              Expanded(child: _isLoading ? progressBar : bodyNew),
              _isLoadingMore ? progressBarLoadMore : new Container()
            ],
          ),
        ),
      ),
    );
  }

  Future _startHaptic(var _type) async {
    var canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      if (_type == null) _type = FeedbackType.success;
      Vibrate.feedback(_type);
    }
  }

  Future<bool> _onBackPress() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new DrawerSlideWithHeader()));
    return null;
  }

  void _callApi() {
    var res = NetworkUtil.makeRequestWithToken(
        "/api/account/notification?start=$_currentPage&limit=20&master_account_id=MST000004431",
        null,
        Method.GET);

    res?.then((response) {
      var result = response?.getSuccessResponse();

      if (result == null) {
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
      if (listNotificationModel != null ||
          listNotificationModel?.notifications?.length == 0) {
        var list = ListNotificationModel.fromJson(me);
        listNotificationModel.notifications.addAll(list.notifications);
      } else {
        listNotificationModel = ListNotificationModel.fromJson(me);
      }

      // if(_isLoading == false) return;
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
          _isBottomLoading = false;
          if (_currentPage <= listNotificationModel.totalPage) {
            _hasMore = true;
            _currentPage++;
            print("bottom $_hasMore");
          } else {
            _hasMore = false;
            print("No more bottom_ $_hasMore");
          }
        });
      }
    });
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print("reach the bottom $_hasMore");
      if (_isBottomLoading) {
        _startHaptic(FeedbackType.medium);
        return;
      }
      if (!_hasMore) {
        _startHaptic(FeedbackType.heavy);
        return;
      }
      setState(() {
        _isLoadingMore = true;
        _isBottomLoading = true;
      });
      if (_hasMore) _callApi();
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      print("reach the Top");
      setState(() {
        _isLoadingMore = false;
      });
    }
    if (_controller.offset - 1 <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      print("User Scrollback Reset");
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  _showMessage(BuildContext context, String title, String msg) {
    Alert(
      context: context,
      type: AlertType.none,
      title: title,
      desc: msg,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }
}
