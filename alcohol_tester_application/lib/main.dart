import 'package:alcohol_tester_application/moreDetailsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

//App bar colours
Map<int, Color> color = {
  50: Color.fromRGBO(59, 59, 59, .1),
  100: Color.fromRGBO(59, 59, 59, .2),
  200: Color.fromRGBO(59, 59, 59, .3),
  300: Color.fromRGBO(59, 59, 59, .4),
  400: Color.fromRGBO(59, 59, 59, .5),
  500: Color.fromRGBO(59, 59, 59, .6),
  600: Color.fromRGBO(59, 59, 59, .7),
  700: Color.fromRGBO(59, 59, 59, .8),
  800: Color.fromRGBO(59, 59, 59, .9),
  900: Color.fromRGBO(59, 59, 59, 1),
};

//Main page colours
Map<int, Color> color2 = {
  50: Color.fromRGBO(91,91,91, .1),
  100: Color.fromRGBO(91,91,91, .2),
  200: Color.fromRGBO(91,91,91, .3),
  300: Color.fromRGBO(91,91,91, .4),
  400: Color.fromRGBO(91,91,91, .5),
  500: Color.fromRGBO(91,91,91, .6),
  600: Color.fromRGBO(91,91,91, .7),
  700: Color.fromRGBO(91,91,91, .8),
  800: Color.fromRGBO(91,91,91, .9),
  900: Color.fromRGBO(91,91,91, 1),
};

void main() => runApp(MyApp());

MaterialColor colorCustom = MaterialColor(0xFF3B3B3B, color);
MaterialColor colorCustom2 = MaterialColor(0xFF5B5B5B, color2);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alcohol Tester Application',
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      home: MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();
  String _weight = '';
  int _weightGrams = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
  }

//Make alerts
  void _showDialog(BuildContext context) {
   

    showDialog(
      context: context,
      builder: (context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Important Information"),
          content: new Text("Sample Text to include legal info"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _updateWeight(weight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('Weight', weight);
      print(prefs.getInt('Weight'));
    });
  }

  void _goNextPage() {
    setState(() {
      
      _weight = myController.text;
      _weightGrams = int.parse(_weight) * 454;
      print(_weightGrams);

      //update user weight in shared preferences
      _updateWeight(_weightGrams);
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => new moreDetailsPage(
                weightGrams: _weightGrams,
              )));
    });
  }


  @override
  Widget build(BuildContext context) {
  
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
    return new Scaffold(
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
              children: <Widget>[
                Text(
                  'How much do you weigh? (in lb)',
                  style: TextStyle(fontSize: 20),
                ),
                TextField(
                  controller: myController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    _weight = myController.text;
                  },
                  onTap: (){
                    _showDialog(context);
                    },
                  decoration: InputDecoration(
                    hintText: "Enter Weight",
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
