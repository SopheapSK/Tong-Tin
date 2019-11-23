import 'package:TonTin/core/models/productModel.dart';
import 'package:TonTin/core/viewmodels/CRUDModel.dart';
import 'package:TonTin/util/share_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/utils.dart';
import 'home_list.dart';

class DetailTongTinPage extends StatefulWidget {
  final Property property;

  DetailTongTinPage({Key key, this.property}) : super(key: key);

  @override
  _DetailTongTinPageState createState() => _DetailTongTinPageState();
}

class _DetailTongTinPageState extends State<DetailTongTinPage> {
  List<TextEditingController> _controllers = new List();
  Property insideProperty;
  @override
  void initState() {
    // TODO: implement initState
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    if(mounted)
      insideProperty = widget.property;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controllers.forEach((c)=> c.dispose());

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CRUDModel>(context);

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Text(
            insideProperty.title,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
      ],
    );

    final topContent = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
      Container(
        margin: EdgeInsets.all(12.0),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),

      Container(
        margin: EdgeInsets.all(12.0),
        child: IconButton(
          onPressed: () {
            _confirmDoneBid(context, 1, insideProperty, provider);
           // Navigator.pop(context);
          },
          icon: Icon(Icons.cloud_done, color: Colors.white),
        ),
      ),
      Container(
        margin: EdgeInsets.all(12.0),
        child: IconButton(
          onPressed: () {
            _confirmDelete(context, 1, widget.property, provider);
          },
          icon: Icon(Icons.delete_forever, color: Colors.white),
        ),
      ),
    ],);



    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [

                  Color(0xFF1b1e44).withOpacity(1),
                  Color(0xFF2d3447).withOpacity(1),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp)),
        child: Column(
          children: <Widget>[

            SizedBox(
              height: 26.0,
            ),
            topContent,
            topContentText,
            headerInfo(context, insideProperty),
            Expanded(child: _buildList(context, insideProperty, provider))
          ],
        ),
      ),
    );
  }

  Widget labelWithText(IconData iconData, String info) {
    final fontX = info.length > 16 ? 13.0 : 15.0;
    return Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                  onPressed: null,
                  disabledColor: Colors.white12,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  color: Colors.white10,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Icon(
                        iconData,
                        color: Colors.white,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: new Text(
                          info,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: fontX,
                              fontWeight: FontWeight.normal),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ))
            ]));
  }

  Widget headerInfo(BuildContext context, Property info) {
    var totalInterest = 0.0;
    var lastMonthInterst = 0.0;
    info.listTrack.forEach((k, v){
      lastMonthInterst = double.parse( v.toString());
      totalInterest+= lastMonthInterst;
    });
    return Container(

      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      color: Color.fromRGBO(58, 66, 86, 0.0),
      child: new Center(
        child: Column(
          children: <Widget>[


            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: labelWithText(
                        Icons.people, 'សរុប ${info.people.toString()} នាក់')),
                SizedBox(
                  width: 4.0,
                ),
                Expanded(
                  child: labelWithText(Icons.monetization_on,
                      '១ក្បាល​: \$${info.amount.toStringAsFixed(2)} '),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: labelWithText(Icons.person,
                        'ដេញហើយ ${info.listTrack.length.toString()} ក្បាល')),
                SizedBox(
                  width: 4.0,
                ),
                Expanded(
                    child: labelWithText(Icons.date_range,
                        'ថ្ងៃលេង ${Utils.dateConvert(info.startOn)}')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: labelWithText(Icons.monetization_on, 'ការសរុប \$ ${totalInterest.toStringAsFixed(2)}')),
                SizedBox(
                  width: 4.0,
                ),
                Expanded(
                    child: labelWithText(Icons.monetization_on,
                        'ការខែមុន \$${lastMonthInterst.toStringAsFixed(2)}')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, Property snapshot, CRUDModel provider) {
    List<String> list = new List();
    for (var i = 0; i < snapshot.people; i++) {
      list.add('${i + 1}');
    }

    return Container(
      color: Colors.transparent,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          var isCurrentMonth = Utils.isDateMatch(Utils.addMonth(snapshot.startOn, index));
          return makeListItem(context, index, list[index], snapshot, isCurrentMonth, provider);
        },
      ),
    );
  }

  Widget makeListItem(BuildContext context, int index, String info, Property snapshot, bool isCurrentMonth, CRUDModel provider) {
    return Container(
        color: isCurrentMonth ? Color.fromRGBO(58, 66, 86, 0.9) : index % 2 == 0 ? Color.fromRGBO(58, 66, 86, .1)  : Color.fromRGBO(58, 66, 86, .4) ,
        child: makeListTile(context,index,  info, snapshot, provider));
  }

  ListTile makeListTile(BuildContext context, int index, String info, Property property, CRUDModel provider) {
    var isInterestAvailable = property.listTrack.containsKey('month$index');
    var interest = isInterestAvailable ? property.listTrack['month$index']??0.00.toStringAsFixed(2) : ' N/A';
    var amountToPay = isInterestAvailable ? (property.amount - ( property.listTrack['month$index']??0.0)).toStringAsFixed(2) : ' N/A';
    if(property.isDead) {
      if (index >= property.listTrack.length) {
        amountToPay = property.amount.toStringAsFixed(2);
        interest = '0.00';
      }
    }

    _controllers.add(new TextEditingController());
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      leading: Container(
        padding: EdgeInsets.only(right: 8.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Text('$info', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      title: Text(
        'ខែ ${Utils.addMonth(property.startOn, index).substring(3)}',
        style: TextStyle(color: Colors.lightBlue, fontSize: 12.0, fontWeight: FontWeight.normal),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
                padding: EdgeInsets.only(left: 0.0),
                child: Text(
                    ' ការ​: \$$interest \n ដេញហើយ $info/${property.people} នាក់. \n បង់លុយ: \$ $amountToPay',
                    style: TextStyle(color: Colors.white))),
          )
        ],
      ),
      trailing: IconButton(
          onPressed: ()=> _showBottomSheet(context, index, property, provider)
          , icon: Icon(Icons.edit, color: Colors.white, size: 20.0)),

      onLongPress: () {
       // print('tap for more');
        _confirmRemoveInterest(context, index, property, provider);

      },
    );


  }

  void _showBottomSheet(BuildContext context, int index, Property property, CRUDModel provider){

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
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
                        child: Text('ការប្រាក់សម្រាប់ខែទី ${index + 1}', style: TextStyle(color: Colors.white),)

                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 10.0),
                      child: new TextField(

                        keyboardType: TextInputType.number,
                        controller: _controllers[index],
                        style:  TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.attach_money, size: 14.0, color: Colors.white,),
                          hintText: '(ex: 12.5\$ ) ',
                          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide(width: 1,color: Colors.white70),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                        ),


                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    _buttonSubmit(context,index, property, provider),


                    SizedBox(height: 32),


                  ],
                ),
              ),
            ),
          );
        });
  }
  Widget _buttonBid( BuildContext context, Property property, CRUDModel provider){
    return new Center(
        child: new RaisedButton(
            onPressed: () async {
              // Navigator.pushNamed(context, '/create');
              updateDoneBid(provider, property);
              Navigator.pop(context);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            color: Colors.blueAccent,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Icon(
                  Icons.cloud_done,
                  color: Colors.white,
                  size: 24.0,
                ),
                SizedBox(
                  width: 16.0,
                ),
                new Text(
                  '\t យល់ព្រម  \t  \t \t' ,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )));
  }
  Widget _buttonSubmit( BuildContext context,int index, Property property, CRUDModel provider){
    return new Center(
        child: new RaisedButton(
            onPressed: () async {
              updateData(provider, index, property);
              Navigator.pop(context);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            color: Colors.blueAccent,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Icon(
                  Icons.donut_large,
                  color: Colors.white,
                  size: 24.0,
                ),
                SizedBox(
                  width: 16.0,
                ),
                new Text(
                  ' \t យល់ព្រម \t \t \t \t' ,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )));
  }

  Widget _buttonDeleteInterest( BuildContext context,int index, Property property, CRUDModel provider){
    return new Center(
        child: new RaisedButton(
            onPressed: () async {
              // Navigator.pushNamed(context, '/create');
              updateRemoveInterest(provider, index, property);
              Navigator.pop(context);

            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            color: Color(0xFFff6e6e),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Icon(
                  Icons.delete_sweep,
                  color: Colors.white,
                  size: 24.0,
                ),
                SizedBox(
                  width: 16.0,
                ),
                new Text(
                  '\t យល់ព្រម \t \t \t \t \t ' ,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )));
  }
  Widget _buttonDeleteTongTin( BuildContext context,int index, Property property, CRUDModel provider){
    return new Center(
        child: new RaisedButton(
            onPressed: () async {
              deleteThisTongTin(property, provider);
              Navigator.pop(context);

            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            color: Color(0xFFff6e6e),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                  size: 24.0,
                ),
                SizedBox(
                  width: 16.0,
                ),
                new Text(
                  '\t \t យល់ព្រម \t  \t \t \t \t' ,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )));
  }


  void deleteThisTongTin(Property property, CRUDModel provider){
    print('start Delete');
    var me =  provider.removeTongTingByID(property.id, property.userId);
    me.then((f){
      SharedPreferences.getInstance().then((sharePref){
        var isDesc = sharePref.getBool(PrefUtil.KEY_SORT_DECS);
        if(isDesc == null) isDesc = true;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>ListPage(title : 'Persona ', userID: property.userId, isDecs: isDesc,)));
      });

    });

  }

  void updateData(CRUDModel productProvider, int index, Property property){
    String interest = _controllers[index].text;
    print('=> interst $interest');
    if(interest.isEmpty) return;
    if(property.listTrack.containsKey('month$index')){
      property.listTrack['month$index'] =  double.parse(interest);


      print('user id ${property.userId}');
      productProvider.updateProperty(property, property.userId, property.id);
    }else {
      property.listTrack['month$index'] =  double.parse(interest);
      print('user id ${property.userId}');
      productProvider.updateProperty(property, property.userId, property.id);

    }
    setState(() {
      insideProperty = property;
    });

  }
  void updateDoneBid(CRUDModel productProvider, Property property){
    property.isDead = !property.isDead;
    print('user id ${property.userId}');
    productProvider.updateProperty(property, property.userId, property.id);
    setState(() {
      insideProperty = property;
    });
  }
  void updateRemoveInterest(CRUDModel productProvider, int index, Property property){

    if( property.listTrack.containsKey('month$index')){
      property.listTrack.remove('month$index');
      print('user id ${property.userId}');
      productProvider.updateProperty(property, property.userId, property.id);
      setState(() {
        insideProperty = property;
      });
    }

  }

  void _confirmDelete(BuildContext context, int index, Property property, CRUDModel provider){

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Color(0xFF2d3447),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        builder: (context) {
          return Container(
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
                      child: Text('លុបតុងទីននេះចោល?', style: TextStyle(color: Colors.white),)

                  ),
                  SizedBox(height: 10),
                  _buttonDeleteTongTin(context, index, property, provider),
                  SizedBox(height: 10),

                ],
              ),
            ),
          );
        });
  }
  void _confirmDoneBid(BuildContext context, int index, Property property, CRUDModel provider){

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Color(0xFF2d3447),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        builder: (context) {
          return Container(
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
                      child: Text('បើអ្នកដេញរួចហើយ សុមចុចប៊ូតុង យល់ព្រម ខាងក្រមនេះ',style: TextStyle(color: Colors.white),)

                  ),
                  SizedBox(height: 10.0),
                  _buttonBid(context, property, provider),
                  SizedBox(height: 10.0),

                ],
              ),
            ),
          );
        });
  }
  void _confirmRemoveInterest(BuildContext context, int index, Property property, CRUDModel provider){

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor:Color(0xFF2d3447),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        builder: (context) {
          return Container(
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
                      child: Text('លុបការប្រាក់សម្រាប់ខែទី ${index + 1} ចោល?', style: TextStyle(color: Colors.white),)
                  ),
                  SizedBox(height: 10.0),
                  _buttonDeleteInterest(context, index, property, provider),
                  SizedBox(height: 10.0),

                ],
              ),
            ),
          );
        });
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height * 0.9);
    path.lineTo(size.width + 400.0, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}