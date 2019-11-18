import 'dart:math';

import 'package:TonTin/core/models/productModel.dart';
import 'package:TonTin/core/viewmodels/CRUDModel.dart';
import 'package:TonTin/model/customIcons.dart';
import 'package:TonTin/model/data.dart';
import 'package:TonTin/pages/login_page_fire.dart';
import 'package:TonTin/ui/views/tong_tin_detail_page.dart';
import 'package:TonTin/ui/widgets/profile_page.dart';
import 'package:TonTin/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title, this.userID}) : super(key: key);

  final String title;
  final String userID;

  @override
  _ListPageState createState() => _ListPageState();
}
final cardAspectRatio = 10.0 / 16.0;
final widgetAspectRatio = cardAspectRatio * 1.2;
class _ListPageState extends State<ListPage> {
  PageController _pageController;
  bool _isFetching = true;
  List<Property> properties = new List();
  List<Property> propertiesState = new List();
  var currentPage = 0.0;
  var currentPageState = 0;
  bool isHomeActive = true;
  bool isProfileActive = false;
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    //var provider = Provider.of<CRUDModel>(context);
    _pageController = PageController(initialPage: 0, keepPage: true);
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
      });

      if(!_isFetching && properties.length != 0){
      for(var me = 0 ; me < properties.length; me++){
        if(me >= 1){
          if(currentPage == (me/2) ){
            //Utils.startHapticSuccess();
          }
        }else{
          if(currentPage == 0.5){
            //Utils.startHapticSuccess();
          }
        }

      }}

    });

    _fetchData(new CRUDModel(), widget.userID);

  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final makeBottom = Container(
      height: 60.0,
      child: BottomAppBar(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color:  isHomeActive ? Color(0xFFff6e6e) : Colors.white70,),
              onPressed: () {
                if(isHomeActive) return;
                setState(() {
                  isProfileActive = !isProfileActive;
                  isHomeActive = !isHomeActive;

                });

                WidgetsBinding.instance
                    .addPostFrameCallback((_){

                  if(_pageController.hasClients)
                    _pageController.animateToPage( currentPage.floor() , duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);
                });
              },
            ),

            IconButton(
              icon: Icon(Icons.account_box, color: isProfileActive ? Color(0xFFff6e6e) : Colors.white70,),
              onPressed: () {
                if(isProfileActive) return;
                setState(() {
                  isProfileActive = !isProfileActive;
                  isHomeActive = !isHomeActive;

                });
                if(true) return;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage()));

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


    /*
     body:isHomeActive ? Column(
        children: <Widget>[
          Expanded(child: widget.userID == null ? prompt : makeBody),
          makeNewItem
        ],
      ): Profile(),
      bottomNavigationBar: makeBottom,
     */

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
        body: isHomeActive ? SingleChildScrollView(
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
                        Icons.search,
                        color: Colors.transparent,
                        size: 30.0,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Persona",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 46.0,
                          fontFamily: "Calibre-Semibold",
                          letterSpacing: 1.0,
                        )),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 30.0,
                        color:  properties.length != 0 ? Colors.white70 : Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/create');
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
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

                  CardScrollWidget(currentPage, properties),

                  Positioned.fill(
                    child: PageView.builder(
                      itemCount: properties.length,
                      controller: _pageController,
                      reverse: true,
                      onPageChanged: _onPageViewChange,
                      itemBuilder: (context, index) {
                        return new GestureDetector( onTap: () => {print('get call')},
                            child: IgnorePointer(child: Container()));
                      },
                    ),
                  )
                ],
              ): promptNoItem(),


            ],
          ),
        ) : Profile(),
      ),
    );
  }
  _onPageViewChange(int page) {

    setState(() {
      currentPageState = page;
    });

  }
  void _fetchData(CRUDModel provider, String userID){
    var data =  provider.getAllProperties(userID);
    data.then((result){
      setState(() {
        properties = result.reversed.toList();
        _isFetching = false;


      });

      WidgetsBinding.instance
          .addPostFrameCallback((_){

        if(_pageController.hasClients)
          _pageController.animateToPage( properties.length - 1 , duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);
      });


    });


  }
}

class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;
  List<Property> properties;

  CardScrollWidget(this.currentPage, this.properties);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        // var safeHeight = height - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight ;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var i = 0; i < properties.length; i++) {
          var pos = i > 3 ? 0 : i;
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: (padding  + verticalInset * max(-delta, 0.0)),
            bottom: (padding + verticalInset * max(-delta, 0.0)) /1,
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: new GestureDetector( onTap: ()=> print('wil will'),
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
                        Image.asset(images[pos], fit: BoxFit.cover),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text(properties[i].title,
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
                                   child: new GestureDetector(
                                     onTap: ()=> print('call la'),
                                     child: Text("មើលបន្ថែម",
                                         style: TextStyle(color: Colors.white)),
                                   ),
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
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
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

