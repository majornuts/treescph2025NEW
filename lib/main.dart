import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treescph2025/screens/About.dart';
import 'package:treescph2025/screens/ClusterMap.dart';
import 'package:treescph2025/screens/HeatMap2.dart';
import 'package:treescph2025/utils/Utils.dart';
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
  const MyApp({super.key});

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
  const TabBarExample({super.key});

  @override
  State<TabBarExample> createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<TabBarExample>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late final TabController _tabController;
  String searchQuery = '';
  List<String> fullData = [];

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

  List<String> filteredData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _loadMarkerData();
    _tabController.addListener(_handleTabChange);
  }

  String _appBarTitle = '';

  void _handleTabChange() {
    setState(() {
      _appBarTitle = 'About';
    });
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
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[
          ClusterMap(
            filteredData: filteredData

          ),
          HeatMap2(filteredData: filteredData),
          About(),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return _tabController.index == 2
        ? Container(child: Text(_appBarTitle, textAlign: TextAlign.center))
        : buildAutocomplete();
  }

  Autocomplete<String> buildAutocomplete() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        } else {
          return fullData.where((String option) {
            return option.toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            );
          });
        }
      },
      onSelected: (String selection) {
        _onSearchChanged(selection);
        _searchController.text = selection;
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: 'Search... for a tree',
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                textEditingController.clear();
                filteredData.clear();
                _onSearchChanged('');
              },
            ),
          ),
          onChanged: _onSearchChanged,
        );
      },
    );
  }
}

