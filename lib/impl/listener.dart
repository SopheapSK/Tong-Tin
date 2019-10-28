
import 'package:TonTin/core/models/productModel.dart';

abstract class Listener{
  void onSuccess(String success);
  void onError(String error);
}

abstract class AddNewProperty{
  void startAddProperty(Property property);
  void onSuccess(String success);
  void onError(String error);
}