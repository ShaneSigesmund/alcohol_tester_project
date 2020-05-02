import 'package:alcohol_tester_application/moreDetailsPage.dart';
import 'package:charts_flutter/flutter.dart' as charts;
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

class graph extends StatelessWidget {
  final bool animate = false;

  List<charts.Series> seriesList;

  @override
  void initState() {
    _getWeight();
    _getBAC();
  }

  graph(this.seriesList, {bool animate});

  factory graph.withSampleData() {
    return new graph(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

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
    weight = prefs.getInt("Weight");
    weightPounds = (weight / 454);
  }

  void _getBAC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //Set gender variable

    if (prefs.getDouble("Gender") == 0.68) {
      genderString = "Male";
    } else {
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
  void _goNextPage() {
    //update user weight in shared preferences

    // Navigator.of(context).pushReplacement(
    //   new MaterialPageRoute(builder: (context) => new moreDetailsPage()));
  }

//Define what data goes into the graph

  static List<charts.Series<TimeUntilSober, int>> _createSampleData() {
    List<TimeUntilSober> chartData = [];

    double tempBac2 = bacVALUE - legalBAC;
    double _getTimeUntilSober = tempBac2 / decreaseBAC;

    double result = _getTimeUntilSober;
    int temp = result.round();

    //for (int i = 0; i < temp; i++) {
    //chartData.add(new TimeUntilSober(i, (bacVALUE - decreaseBAC)));
    //}
    chartData = [
      new TimeUntilSober(3, 200),
      new TimeUntilSober(2, 199),
      new TimeUntilSober(1, 25),
      new TimeUntilSober(0, 5),
    ];
    return [
      new charts.Series<TimeUntilSober, int>(
        id: 'BAC',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeUntilSober bacs, _) => bacs.time,
        measureFn: (TimeUntilSober bacs, _) => bacs.bacVal,
        data: chartData,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
      height: 200,
      child:  charts.LineChart(_createSampleData()),
    )
      )
    );
    
    
   

    //TimeSeriesChart(
    // seriesList,
    // animationDuration: Duration(seconds: 2),
    //dateTimeFactory: const LocalDateTimeFactory(),
    //);
  }
}

//Create time object for graph
class TimeUntilSober {
  final int time;
  final double bacVal;

  TimeUntilSober(this.time, this.bacVal);
}
