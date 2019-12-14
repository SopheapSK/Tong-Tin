import 'dart:math';

import 'package:TonTin/core/models/productModel.dart';
import 'package:TonTin/core/viewmodels/CRUDModel.dart';
import 'package:TonTin/model/customIcons.dart';
import 'package:TonTin/model/data.dart';
import 'package:TonTin/pages/login_page_fire.dart';
import 'package:TonTin/ui/views/add_properties.dart';
import 'package:TonTin/ui/views/tong_tin_detail_page.dart';
import 'package:TonTin/ui/widgets/about_page.dart';
import 'package:TonTin/ui/widgets/profile_page.dart';
import 'package:TonTin/util/lang.dart';
import 'package:TonTin/util/share_pref.dart';
import 'package:TonTin/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title, this.userID, this.isDecs = true}) : super(key: key);

  final String title;
  final String userID;
  bool isDecs;

  @override
  _ListPageState createState() => _ListPageState();
}
final cardAspectRatio = 12.0 / 16.0;
final widgetAspectRatio = cardAspectRatio * 1.2;
class _ListPageState extends State<ListPage> {

  bool _isFetching = true;
  List<Property> properties = new List();
  final _prefs = SharedPreferences.getInstance();
  var currentPage = 0.0;
  var currentPageState = 0;
  List<int> imageList;
  int tab = 0;

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();


    _fetchData(new CRUDModel(), widget.userID, isDesc: widget.isDecs);

  }
  @override
  void dispose() {

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    var h =  MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    ScreenUtil.instance = ScreenUtil(width: w, height:h)..init(context);

    final pageSlider =  CarouselSlider(

      onPageChanged: _onPageViewChange,
      enlargeCenterPage: true,
      initialPage: 0,
      enableInfiniteScroll: false,
      aspectRatio: 12/16,
      height: ScreenUtil.getInstance().setHeight(h * 0.6),
      items: properties.asMap().map((index, value) =>
          MapEntry(index, Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: _pageView( index, value))))
          .values
          .toList());



      /*items: properties.map((i) {

        return Builder(
          builder: (BuildContext context) {

            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: _pageView(i, (i.amount) == null ? 0 : (i.amount) % 2 == 0 ? 0:1)
            );
          },
        );
      }).toList()*/



    final makeBottom = Container(
      height: 60.0,
      child: BottomAppBar(
        color:  Color(0xFF2d3447),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.opacity, color:  tab == 0 ? Color(0xFFff6e6e) : Colors.white70,),
              onPressed: () {
                if(tab == 0) return;
                _selectedTab(0);

                WidgetsBinding.instance
                    .addPostFrameCallback((_){

                    //pageSlider.animateToPage( currentPageState , duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);
                });
              },
            ),

            IconButton(
              icon: Icon(Icons.account_circle, color: tab == 1 ? Color(0xFFff6e6e) : Colors.white70,),
              onPressed: () {
                if(tab == 1) return;

                _selectedTab(1);

              },
            ), IconButton(
              icon: Icon(Icons.info, color: tab == 2 ? Color(0xFFff6e6e) : Colors.white70,),
              onPressed: () {
                if(tab == 2) return;
                _selectedTab(2);
              },
            )
          ],
        ),
      ),
    );

    final prompt = Center(
      child: Text(
        'No List of Property yet \nLet create New one by \nTap on CREATE NEW ITEM',
        style: TextStyle(
            color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );



    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [

                Color(0xFF1b1e44),
                Color(0xFF2d3447),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              tileMode: TileMode.clamp)),
      child: Scaffold(
        bottomNavigationBar: makeBottom,
        backgroundColor: Colors.transparent,
        body: tab == 0 ?  SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 30.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        CustomIcons.menu,
                        color: Colors.transparent,
                        size: 30.0,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                       // Icons.search,
                        CustomIcons.menu,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () {_showBottomSheet(context);},
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    Row(

                      children: <Widget>[
                        Text('${Language.app_name()}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 46.0,
                              fontFamily: "Calibre-Semibold",
                              letterSpacing: 1.0,
                            )),
                        Text('${concateTitle(properties.length)}',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12.0,

                            )),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 30.0,
                        color:  properties.length != 0 ? Colors.white70 : Colors.white,
                      ),
                      onPressed: () {
                        Utils.startHapticSuccess();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateProperty(userID: widget.userID,)));
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                child: properties.length != 0 ? Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFff6e6e),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 6.0),
                          child: Text('\$ ${properties[currentPageState].amount}',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text("ដេញហើយ ${properties[currentPageState].listTrack.length.toString()}/${properties[currentPageState].people} ក្បាល",
                        style: TextStyle(color: Colors.blueAccent))
                  ],
                ) : Container(),
              ),
              _isFetching ? new Padding(padding: EdgeInsets.only(top: 40.0, bottom: 10.0) , child:  new Center(
                child: new CircularProgressIndicator(backgroundColor: Colors.white,),
              )) :
              properties.length != 0 ? Stack(
              children: <Widget>[
                Container(height:ScreenUtil.getInstance().setHeight(h * 0.6) ,),
                //CardScrollWidget(currentPage, properties),
                pageSlider
              ],
              ) : promptNoItem(),


            ],
          ),
        ) : tab == 1 ? Profile() : AboutPage(),
      ),
    );
  }
  _onPageViewChange(int page) {
    setState(() {
      currentPageState = page;
    });
    Utils.startHapticSuccess();

  }
  void _fetchData(CRUDModel provider, String userID, {bool isDesc = true}){
    var data =  provider.getAllProperties(userID, isDesc: isDesc);
    data.then((result){
      setState(() {
        properties = result;
        _isFetching = false;

      });

    });
  }
  var padding = 20.0;
  var verticalInset = 20.0;

  Widget _selectedTab(int _tab){
    setState(() {
      tab = _tab;
    });

  }
  Widget _pageView( int index , Property property){

    var r = index > 14 ? 1 : index;

    return ClipRRect(
       borderRadius: BorderRadius.circular(24.0),
       child: GestureDetector(
         onTap: () {
           Utils.startHapticSuccess();
           property.userId = widget.userID;
           Navigator.push(
               context,
               MaterialPageRoute(
                   builder: (context) => DetailTongTinPage(property: property,)));
         },
         child: Container(
           decoration: BoxDecoration(color: Colors.white, boxShadow: [
             BoxShadow(
                 color: Colors.black12,
                 offset: Offset(3.0, 6.0),
                 blurRadius: 10.0)
           ]),
           child: AspectRatio(
             aspectRatio: cardAspectRatio,
             child: Stack(
               fit: StackFit.expand,
               children: <Widget>[
                 Image.asset(images[r], fit: BoxFit.cover),
                 Align(
                   alignment: Alignment.bottomLeft,
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       Padding(
                         padding: EdgeInsets.symmetric(
                             horizontal: 16.0, vertical: 8.0),
                         child: Text('${property.title}' ,
                             style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 25.0,
                                 fontFamily: "SF-Pro-Text-Regular")),
                       ),
                       SizedBox(
                         height: 10.0,
                       ),
                       Padding(
                         padding: const EdgeInsets.only(
                             left: 12.0, bottom: 12.0),
                         child: Container(
                           padding: EdgeInsets.symmetric(
                               horizontal: 22.0, vertical: 6.0),
                           decoration: BoxDecoration(
                               color: Colors.blueAccent,
                               borderRadius: BorderRadius.circular(20.0)),
                           child: Text('ថ្ងៃលេង ${Utils.dateConvert(property.startOn)}',
                               style: TextStyle(color: Colors.white)),
                         ),
                       )
                     ],
                   ),
                 )
               ],
             ),
           ),
         ),
       ),
     );


  }
  void _showBottomSheet(BuildContext context){

    showModalBottomSheet(
        context: context,
        backgroundColor: Color(0xFF2d3447),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text('តម្រៀបតុងទីនតាម៖ ', style: TextStyle(color: Colors.white),)

                    ),
                    SizedBox(
                      height: 8.0,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                              height: 30.0,
                              width: 95.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.black54,
                                color: Colors.blueAccent,
                                elevation: 7.0,
                                child: InkWell(
                                  onTap: (){
                                    _prefs.then((f){
                                     f.setBool(PrefUtil.KEY_SORT_DECS, true);

                                      Navigator.pop(context);
                                     setState(() {
                                       _isFetching = true;
                                     });
                                      _fetchData(new CRUDModel(), widget.userID);

                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      'ថ្ងៃថ្មី',
                                      style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              )),
                          Container(
                              height: 30.0,
                              width: 95.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.black54,
                                color: Colors.red,
                                elevation: 7.0,
                                child: InkWell(
                                  onTap: (){
                                    _prefs.then((f){
                                      f.setBool(PrefUtil.KEY_SORT_DECS, false);

                                      Navigator.pop(context);
                                      setState(() {
                                        _isFetching = true;
                                      });
                                      _fetchData(new CRUDModel(), widget.userID, isDesc: false);

                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      'ថ្ងៃចាស់',
                                      style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              ))
                        ],

                      ),
                    ),

                    SizedBox(
                      height: 4.0,
                    ),



                    SizedBox(height: 32),


                  ],
                ),
              ),
            ),
          );
        });
  }
}



Widget promptNoItem() {
  return Padding(
    padding: const EdgeInsets.only(top:50.0),
    child: Center(
      child: Text(
        'លោកអ្មកមិនទាន់មានបញ្ជីតុងទីនទេ \nបង្កើតវាងាយងាយ \nគ្រាន់តែចុច + ខាងលើនេះ',
        style: TextStyle(
            color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    ),
  );
}



double calculateTheRemain(double total, double finish){
  var remain = 100.0 - ((finish * 100) / total);
  print('remain $remain');
  return  remain;
}

double calculateRemainPeopleInPercentage(double total, double finish){
   return (finish * 100 / total) / 100;

}
String concateTitle(int size){
  if(size <= 0) return '';
  return '​​( $sizeក្បាល )';
}

