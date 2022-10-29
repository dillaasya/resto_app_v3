import 'package:flutter/material.dart';
import 'package:resto_app_v3/provider/theme_provider.dart';
import 'package:resto_app_v3/ui/favorite_page.dart';
import 'package:resto_app_v3/ui/home_page.dart';
import 'package:resto_app_v3/ui/setting_page.dart';
import 'package:provider/provider.dart';

class NavbarPage extends StatefulWidget {
  static const routeName = '/navbar_page';

  const NavbarPage({
    super.key,
  });

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const FavoritePage(),
    const SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context, listen: true);

    return SafeArea(
      child: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: theme.getTheme() == theme.lightTheme
                ? Colors.grey.shade200
                : Colors.grey.shade800,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_rounded,
                  color: Colors.grey,
                ),
                activeIcon: Icon(Icons.home_rounded, color: Color(0xffE23E3E)),
                label: 'Settings',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite_rounded,
                  color: Colors.grey,
                ),
                activeIcon: Icon(
                  Icons.favorite_rounded,
                  color: Color(0xffE23E3E),
                ),
                label: 'Save',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey,
                ),
                activeIcon: Icon(Icons.settings, color: Color(0xffE23E3E)),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped),
      ),
    );
  }
}
