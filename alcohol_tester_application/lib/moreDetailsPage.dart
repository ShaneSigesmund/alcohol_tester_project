import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

int weightGramsValue = 0;
class moreDetailsPage extends StatefulWidget {
  moreDetailsPage({Key key, this.title, @required this.weightGrams}) : super(key: key);

  final String title;
  final int weightGrams;

 
  

  @override
  moreDetails createState() => moreDetails();
}
class moreDetails extends State<moreDetailsPage> {
  String email = "";
  
  @override
  void initState() {
    super.initState();
  }

_getWeight() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    weightGramsValue = prefs.getInt('Weight');
  });
  
}
  @override
  Widget build(BuildContext context) {
   // print(weightGrams);
   _getWeight();
    return Text("$weightGramsValue");
  }
}