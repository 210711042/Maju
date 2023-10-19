import 'package:flutter/material.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/home/home.dart';
import 'package:maju/views/product/products.dart';
import 'package:maju/views/seller/inputForm.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomeView()),
        );
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ProductsView()));
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProfileView()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 1,
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Profile"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Kerjakan profile disini yeah"),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Business',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Palette.n900,
            unselectedItemColor: Palette.n600,
            onTap: _onItemTapped,
          ),
        ));
  }
}
