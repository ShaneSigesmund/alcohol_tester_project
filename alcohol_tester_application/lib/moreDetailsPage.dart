import 'dart:ffi';

import 'package:alcohol_tester_application/bacPage.dart';
import 'package:alcohol_tester_application/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

double male = 0.68;
double female = 0.55;
int weight = 0;
String gender = "";

double percentAlcohol = 0.0;

class moreDetailsPage extends StatefulWidget {
  moreDetailsPage({Key key, this.title, @required this.weightGrams})
      : super(key: key);

  final String title;
  final int weightGrams;

  @override
  moreDetails createState() => moreDetails();
}

class moreDetails extends State<moreDetailsPage> {
  @override
  void initState() {
    super.initState();
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

  void _getBAC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  void _goNextPage() {
    setState(() {
      //update user weight in shared preferences

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new bacPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(weightGrams);
    final nextPage = Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(20),
          color: Color(0xff5b5b5b),
          child: MaterialButton(
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: _goNextPage,
              child: Text("Next",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    foreground: Paint()..color = Colors.white,
                  ))),
        ));

    Column _buildButtons(String name, double value) {
      return Column(
          mainAxisSize: MainAxisSize.max,
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

    Center makeGenderUI() {
      return Center(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'What is your biological sex?',
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(height: 40),
                _buildButtons("Male", 0.68),
                SizedBox(height: 25),
                _buildButtons("Female", 0.55),
                SizedBox(height: 40),
                
                nextPage,
              ],
            ),
          ),
        ),
      );
    }

    return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
            appBar: new AppBar(
                title: Text('Alcohol Tester Application'),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                        new MaterialPageRoute(builder: (context) {
                      return MyHomePage();
                    }));
                  },
                )),
            body: makeGenderUI()));
  }
}

