import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treescph2025/screens/About.dart';
import 'package:treescph2025/screens/ClusterMap.dart';
import 'package:treescph2025/screens/HeatMap2.dart';
import 'package:treescph2025/utils/Autocompleter.dart';
import 'package:treescph2025/utils/Utils.dart';
import 'package:treescph2025/utils/fab.dart';

import 'data/DataApi.dart';
import 'data/FT.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MapProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green[700]),
      home: const TabBarExample(),
    );
  }
}

class TabBarExample extends StatefulWidget {
  const TabBarExample({Key? key}) : super(key: key);

  @override
  State<TabBarExample> createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<TabBarExample>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late final TabController _tabController;
  String searchQuery = '';
  List<String> fullData = [];
  List<String> filteredData = [];
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _loadMarkerData();
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<FT> fetchdata() async {
    return await DataApi.fetchDataTreesParser();
  }

  Future<void> _loadMarkerData() async {
    final value = await fetchdata();
    final List<String> newData =
        value.features.map((feature) => feature.properties.danskNavn).toList();
    final Set<String> uniqueData = newData.toSet();
    setState(() {
      fullData = uniqueData.toList();
    });
  }

  void _handleTabChange() {
    if (_tabController.index == 0) {
      _searchFocusNode.requestFocus();
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
      filteredData =
          fullData
              .where(
                (item) =>
                    item.toLowerCase().contains(searchQuery.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () {
              print('Action 1 pressed');
            },
            icon: const Icon(Icons.location_off, color: Colors.white),
          ),
          ActionButton(
            onPressed: () {
              print('Action 2 pressed');
            },
            icon: const Icon(Icons.navigation_outlined, color: Colors.white),
          ),
          ActionButton(
            onPressed: () {
              _tabController.animateTo(0);
            },
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          ActionButton(
            onPressed: () {
              print('Action 3 pressed');
            },
            icon: const Icon(
              Icons.edit_location_alt_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      appBar: AppBar(
        centerTitle: true,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return AlignTransition(
              alignment: AlignmentTween(
                begin: Alignment.centerRight,
                end: Alignment.center,
              ).animate(animation),
              child: child,
            );
          },
          child: _buildAppBarTitle(),
        ),
        bottom: TabBar(
          indicatorColor: Colors.green,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
          isScrollable: false,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(icon: Icon(Icons.map)),
            Tab(icon: Icon(Icons.map_outlined)),
            Tab(icon: Icon(Icons.account_box_outlined)),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: <Widget>[
              ClusterMap(filteredData: filteredData),
              HeatMap2(filteredData: filteredData),
              About(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return AutocompleteWidget(
      fullData: fullData,
      searchController: _searchController,
      onSearchChanged: _onSearchChanged,
      searchFocusNode: _searchFocusNode,
      filteredData: filteredData,
    );
  }
}
