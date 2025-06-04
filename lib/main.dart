import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
    @override
    build(BuildContext context) {
        return MaterialApp(
            theme: ThemeData(
                primarySwatch: Colors.green,
            ), // ThemeData
            home: TempApp(),
        ); // MaterialApp
    }
}

class TempApp extends Statefulwidget{
    @override
    TempState createState() => TempState();
}

class TempState extends State <TempApp> {
    double input;
    double output;
    bool fOrC;

    @override
    void initState(){
        super.initState();
        input = 0.0;
        output = 0.0;
        fOrC = true;
    }

    @override
    widget build(BuildContext context){
        TextField inputField = TextField(
            keyboardType: TextInputType.number,
            onChanged: (str){
                try{
                    input = double.parse(str);
                } catch(e) {
                    input = 0.0;
                }
            },
            decoration: InputDecoration(
                labelText: "Input a value in ${fOrC == false ? "Fahrenheit" : "Celsius"}", 
            )
        );


        return Scaffold(
            body: Container(
                child: Column(
                    children: <Widget>[inputField],
                ),
            ),
        );
    }
}
