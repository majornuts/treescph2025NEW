import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              // Use a Positioned widget to adjust vertical position dynamically
              Positioned(
                top: constraints.maxHeight * 0.2, // Position text 20% from the top
                left: 0,
                right: 0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Made by volunteers,\n with no affiliation with Copenhagen Municipality. \n'
                          'Remember to hug a tree once in a while',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
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
          );
        },
      ),
    );
  }
}