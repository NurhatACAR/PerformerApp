import 'package:flutter/material.dart';
import 'package:legend_performer_2/tabPages/earning_tab.dart';
import 'package:legend_performer_2/tabPages/home_tab.dart';
import 'package:legend_performer_2/tabPages/profile_tab.dart';
import 'package:legend_performer_2/tabPages/ratings_tab.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          HomeTabPage(),
          EarningsTabPage(),
          RatingsTabPage(),
          ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana sayfa"),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), label: "Kazançlar"),
          BottomNavigationBarItem(
              icon: Icon(Icons.star), label: "Derecelendirmeler"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
        unselectedItemColor: Color.fromARGB(255, 23, 84, 74),
        selectedItemColor: Color.fromARGB(255, 6, 219, 201),
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
