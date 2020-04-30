import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

double male = 0.68;
double female = 0.55;
String gender = "";

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

  _getWeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //gender = prefs.getString('Gender');
    });
  }

  void _goNextPage() {
    setState(() {
      //update user weight in shared preferences

      // Navigator.of(context).pushReplacement(new MaterialPageRoute(
      //   builder: (context) => new moreDetailsPage(
      //     )));
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
            // onPressed: //_goNextPage,
            child: Text("Continue",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  foreground: Paint()..color = Colors.white,
                ))),
      ));

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Alcohol Tester Application'),
      ),
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
               // maleButton,
                //femaleButton,
               Text(
                  'Please select your gender. \n(Click one of the buttons)',
                  style: TextStyle(fontSize: 20),
                ),
               ButtonBar(
                 mainAxisSize: MainAxisSize.min,
                 children: <Widget>[
                _buildButtons("Male", 0.68),
                _buildButtons("Female", 0.55),
                 ],
               ),
                Text(
                  'How much BEER did you drink?',
                  style: TextStyle(fontSize: 20),
                ),
                TextField(
                  controller: beer,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    gender = beer.text;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter value (number of items)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(
                        color: Colors.amber,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 45.0),
                Text(
                  'How much WINE did you drink?',
                  style: TextStyle(fontSize: 20),
                ),
                TextField(
                  controller: wine,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    gender = wine.text;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter value (number of items)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(
                        color: Colors.amber,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 45.0),
                Text(
                  'How much SPIRITS did you drink?',
                  style: TextStyle(fontSize: 20),
                ),
                TextField(
                  controller: spirits,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    gender = spirits.text;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter value (number of items)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(
                        color: Colors.amber,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 45.0),
                nextPage,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
