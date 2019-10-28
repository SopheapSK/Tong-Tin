import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
class TestListNotificationReport extends StatelessWidget {
  static String tag = 'ListNotificationReport';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool _isLoading = true;

  static final List<String> _items = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N'
  ];


  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 4), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              })));
    });
  }


  @override
  Widget build(BuildContext context) {



    final bodyNew =  LiquidPullToRefresh(
    color:  Colors.white,
    backgroundColor:  Color.fromARGB(255, 	176, 192, 37),
    key: _refreshIndicatorKey,
    onRefresh: _handleRefresh,
    child: ListView.builder(
    padding: kMaterialListPadding,
    itemCount: _items.length,
    itemBuilder: (BuildContext context, int index) {
    final String item = _items[index];
    return ListTile(
    isThreeLine: true,
    leading: CircleAvatar(child: Text(item)),
    title: Text('This item represents $item.'),
    subtitle: const Text(
    'Even more additional list item information appears on line three.'),
    );
    },
    ),

    );

    var progressBar = new Container(
      decoration: new BoxDecoration(color: Colors.white),
      child: new Center(
        child: new CircularProgressIndicator(),
      ),
    );

    return  bodyNew;
    
  }
}
