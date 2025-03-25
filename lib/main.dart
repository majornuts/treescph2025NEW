import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treescph2025/utils/TabExampleBar.dart';
import 'package:treescph2025/utils/fab.dart';
import 'package:treescph2025/utils/locationProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(create: (_) => MapProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<MapProvider>(context, listen: false).locationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              floatingActionButton: ExpandableFab(
                distance: 112,
                children: [
                  ActionButton(
                    onPressed: () {},
                    icon: Icon(Icons.map, color: Colors.white),
                  ),
                  ActionButton(
                    onPressed: () {},
                    icon: Icon(Icons.search, color: Colors.white),
                  ),
                ],
              ),
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            ),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.green[700],
            ),
            home: const MyTabBar(),
          );
        }
      },
    );
  }
}
