import 'package:alcohol_tester_application/moreDetailsPage.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

double male = 0.68;
double female = 0.55;
int weight = 0;
double weightPounds = 0.0;
String genderString = "";


//VALUE AT WHICH BAC DECREASES

double decreaseBAC = 0.016;

//LEGAL BAC IN CANADA

double legalBAC = 0.08;


double bacVALUE = 0.0;

double elapsedTime = 0.0;

double percentAlcohol = 0.0;


class graphPage extends StatefulWidget {
  List<Series> seriesList2;

  graphPage({Key key, this.title}) : super(key: key);

  final String title;



  @override
  graph createState() => graph();
}

class graph extends State<graphPage> {
  @override
  void initState() {
    _getWeight();
    _getBAC();

    super.initState();
  }


////////////////////////

//Define what data goes into the graph

//Create factory methods to map the data in new function
// factory graph.withTransactionData(
//     List<graph> graphs) {
//   var runningTotal = bacVALUE;

//   List<TimeUntilSober> mapped = graphs.map((item) {
//     runningTotal -= decreaseBAC;
//     return TimeUntilSober(item._getTimeUntilSober(), runningTotal);
//   }).toList();

  
//   List<Series<TimeUntilSober, double>> list = [
//   Series<TimeUntilSober, double>(
//     id: 'BAC',
//     colorFn: (_, __) => MaterialPalette.red.shadeDefault,
//     domainFn: (TimeUntilSober bacs, _) => bacs.time,
//     measureFn: (TimeUntilSober bacs, _) => bacs.bacVal,
//     data: mapped,
//   )
// ];

// //return graph(list);
// }
////////////////////////


/*
 * Beer: 12 ounces (341 ml) with 5% alcohol
 * Wine: 5 ounces (142 ml) with 12% alcohol
 * Spirits: 1.5 ounces (43 ml) with 40% alcohol
 * 
 * One STANDARD Canadian drink contains: 13.6 grams of alcohol
 */
  void _getBeerGrams(int i) {
    percentAlcohol += i * (341 * 0.05 * 0.789);
  }

  void _getWineGrams(int i) {
    percentAlcohol += i * (142 * 0.12 * 0.789);
  }

  void _getSpiritsGrams(int i) {
    percentAlcohol += i * (43 * 0.4 * 0.789);
  }

  _getWeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      weight = prefs.getInt("Weight");
      weightPounds = (weight / 454);
    });
  }

  void _getBAC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //Set gender variable

    if (prefs.getDouble("Gender") == 0.68) {
      genderString = "Male";
    }
    else{
      genderString = "Female";
    }
    //Get gender constant * weight

    //Get weight
    weight = prefs.getInt('Weight');

    //Get gender constant

    double gender = prefs.getDouble('Gender');

    double weightGender = weight * gender;

    double tempBac = percentAlcohol / weightGender;
    bacVALUE = tempBac * 100;

    print("\nBAC percentage: $bacVALUE");

    //elapsedTime = bacVALUE * 0.015;

   // print("\nElapsed time until sober: $elapsedTime");
  }
 double _getTimeUntilSober() {
   double tempBac2 = bacVALUE - legalBAC;
   return tempBac2/decreaseBAC;
  }

  void _goNextPage() {
    setState(() {
      //update user weight in shared preferences

      // Navigator.of(context).pushReplacement(new MaterialPageRoute(
      //   builder: (context) => new moreDetailsPage(
      //     )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return null;//TimeSeriesChart(
   // seriesList,
   // animationDuration: Duration(seconds: 2),
    //dateTimeFactory: const LocalDateTimeFactory(),
  //);
  }

  
}

//Create time object for graph
class TimeUntilSober {
  final double time;
  final double bacVal;

  TimeUntilSober(this.time, this.bacVal);
}
