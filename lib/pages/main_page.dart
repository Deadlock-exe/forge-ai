import 'package:flex_forge/constants/colors.dart';
import 'package:flex_forge/pages/home_page.dart';
import 'package:flex_forge/pages/progress_page.dart';
import 'package:flex_forge/pages/workout_chat_page.darT';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const ProgressPage(),
    const HomePage(),
    ChatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 30,
        ),
        child: GNav(
          selectedIndex: _selectedIndex,
          onTabChange: navigateBottomBar,
          color: darkText,
          activeColor: darkText,
          tabBackgroundColor: lightText,
          gap: 8,
          padding: const EdgeInsets.all(20),
          tabs: const [
            GButton(
              icon: Icons.history_toggle_off,
              text: "PROGRESS",
            ),
            GButton(
              icon: Icons.home,
              text: "HOME",
            ),
            GButton(
              icon: Icons.lightbulb,
              text: "AI ASSISTANT",
            ),
          ],
        ),
      ),
      backgroundColor: lightRed,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: lightRed,
        toolbarHeight: 70,
        title: const Text(
          "Flex Forge",
          style: TextStyle(
            letterSpacing: 3,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
