import 'package:flutter/material.dart';

class About extends StatelessWidget {
  // final List<String> filteredData;

  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 250.0),
            child: Center(
              child: Text(
                'Made by volunteers,\n with no affiliation with Copenhagen Municipality. \n'
                'Remember to hug a tree once in a while',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/trees2.png', color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
