import 'dart:ffi';

import 'package:alcohol_tester_application/createGraph.dart';
import 'package:alcohol_tester_application/main.dart';
import 'package:alcohol_tester_application/moreDetailsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
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

class bacPage extends StatefulWidget {
  bacPage({Key key, this.title}) : super(key: key);

  final String title;
  List<charts.Series> seriesList;

  @override
  bac createState() => bac(seriesList);
}

class bac extends State<bacPage> {
  @override
  void initState() {
    _getWeight();
    _getBAC();

    super.initState();
  }

  final bool animate = false;

  List<charts.Series> seriesList;

  bac(this.seriesList, {bool animate});

  factory bac.withSampleData() {
    return new bac(
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

  double _getTimeUntilSober() {
    double tempBac2 = bacVALUE - legalBAC;
    return tempBac2 / decreaseBAC;
  }

//Define what data goes into the graph

  static List<charts.Series<TimeUntilSober, int>> _createSampleData() {
    List<TimeUntilSober> chartData = [];

    double tempBac2 = bacVALUE - legalBAC;
    double _getTimeUntilSober = tempBac2 / decreaseBAC;

    double result = _getTimeUntilSober;
    int temp = result.round();

    for (int i = temp; i > 0; i--) {
    chartData.add(new TimeUntilSober(i, (bacVALUE - decreaseBAC)));
    }
   
    var axis = charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
      labelStyle: charts.TextStyleSpec(
          fontSize: 10,
          color: charts.MaterialPalette
              .white), //chnage white color as per your requirement.
    ));
    return [
      new charts.Series<TimeUntilSober, int>(
        id: 'BAC',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        outsideLabelStyleAccessorFn: (_, __) => charts.TextStyleSpec(
          fontSize: 10,
          color: charts.MaterialPalette.white,
        ),
        domainFn: (TimeUntilSober bacs, _) => bacs.time,
        measureFn: (TimeUntilSober bacs, _) => bacs.bacVal,
        data: chartData,
      )
    ];
  }

  Column _buildButtons(String name, double value) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(20),
              color: Color(0xff5b5b5b),
              child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setDouble("Gender", value);
                    print(prefs.get('Gender'));
                  },
                  child: Text("$name",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        foreground: Paint()..color = Colors.white,
                      ))),
            ),
          ),
        ]);
  }

  final beer = TextEditingController();
  final wine = TextEditingController();
  final spirits = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print(weightGrams);

    void _goNextPage() {
      setState(() {
        //update user weight in shared preferences

        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (context) => new graph.withSampleData()));
      });
    }

    final nextPage = Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(20),
          color: Color(0xff5b5b5b),
          child: MaterialButton(
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: _goNextPage,
              child: Text("Continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    foreground: Paint()..color = Colors.white,
                  ))),
        ));

    Container createTextBac(String text) {
      return Container(
          width: 2000,
          height: 40,
          child: new Container(
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10),
              color: colorCustom,
              child: Center(
                child: Text(
                  "$text",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ));
    }

    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: colorCustom,
          appBar: new AppBar(
              title: Text('Alcohol Tester Application'),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (context) => new moreDetailsPage(
                              weightGrams: null,
                            )));
                  })),
          body: Center(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    createTextBac('BAC:                   $bacVALUE%'),
                    Text(
                      "$weightPounds    $genderString",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: charts.LineChart(_createSampleData(),
                      animate: false, 
                      domainAxis: charts.AxisSpec(
                        renderSpec: charts.SmallTickRendererSpec(
                          labelStyle: charts.TextStyleSpec(
                            fontSize: 10,
                            color: charts.MaterialPalette.white, 
                          )
                        )
                      ),
                      primaryMeasureAxis: charts.AxisSpec(
                        renderSpec: charts.GridlineRendererSpec(
                          labelStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.white,
                          )

                        )
                      ),

                      ),
                    ),
                    nextPage,
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

//Create time object for graph
class TimeUntilSober {
  final int time;
  final double bacVal;

  TimeUntilSober(this.time, this.bacVal);
}
