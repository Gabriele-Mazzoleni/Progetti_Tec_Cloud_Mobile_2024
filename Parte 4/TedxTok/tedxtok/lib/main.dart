import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Titolo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked1,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked1 = value ?? false;
                        });
                      },
                    ),
                    Text('Checkbox 1'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked2,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked2 = value ?? false;
                        });
                      },
                    ),
                    Text('Checkbox 2'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked3,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked3 = value ?? false;
                        });
                      },
                    ),
                    Text('Checkbox 3'),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Aggiungi qui l'azione del bottone
                print('Bottone premuto');
              },
              child: Text('Premi'),
            ),
          ],
        ),
      ),
    );
  }
}
