import 'package:flutter/material.dart';

import '../screens/About.dart';
import '../screens/ClusterMap.dart';
import '../screens/HeatMap2.dart';

class MyTabBar extends StatefulWidget {
  const MyTabBar({super.key});

  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateFilteredData(List<String> data) {
    setState(() {
      _filteredData.clear();
      _filteredData.addAll(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trees CPH 2025'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(icon: Icon(Icons.map)),
            Tab(icon: Icon(Icons.heat_pump)),
            Tab(icon: Icon(Icons.info_outline)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ClusterMap(filteredData: _filteredData),
          HeatMap2(filteredData: _filteredData),
          const About(),
        ],
      ),
    );
  }
}
