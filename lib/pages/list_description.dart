import 'dart:async';

import 'package:TonTin/pages/page_utils.dart';
import 'package:drawerbehavior/drawer_scaffold.dart';
import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
class ListDescription extends StatefulWidget {
   static const String tag = 'ListDescrptionReport';
  @override
  _ListDescriptionState createState() => _ListDescriptionState();

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
}

class _ListDescriptionState extends State<ListDescription> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    var selectedMenuItemId = '0';
 

  

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


   
    var progressBar = new Container(
      decoration: new BoxDecoration(color: Colors.white),
      child: new Center(
        child: new CircularProgressIndicator(),
      ),
    );

    return DrawerScaffold(
       
      showAppBar: true,
      appBar: AppBarProps(
        centerTitle: true,
          //[IconButton(icon: Icon(Icons.notifications), onPressed: () {})]
      ),
       menuView: MenuView(
        menu: DrawerUtils.drawermenu(),
        headerView: DrawerUtils.headerView(context),
        footerView: DrawerUtils.footerView(context),
        animation: false,
        alignment: Alignment.topLeft,
        //color: Theme.of(context).primaryColor,
        color: Colors.white,
        selectedItemId: selectedMenuItemId,
        onMenuItemSelected: (String itemId) {
          selectedMenuItemId = itemId;
        },
      ),
      contentView: Screen(
        contentBuilder: (context) => LayoutBuilder(
          builder: (context, constraint) => progressBar
           //_isLoading ? progressBar : bodyNew,
             
        ),        color: Colors.white,
      ),
    
    );
  }
}
