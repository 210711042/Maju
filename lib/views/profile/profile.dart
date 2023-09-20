import 'package:flutter/material.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/home/home.dart';

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
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: "11042",
                  icon: Icon(Icons.person),
                ),
                Tab(
                  text: "11127",
                  icon: Icon(Icons.person),
                ),
                Tab(
                  text: "11133",
                  icon: Icon(Icons.person),
                ),
                Tab(
                  text: "11134",
                  icon: Icon(Icons.person),
                ),
                Tab(
                  text: "11355",
                  icon: Icon(Icons.person),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Center(
                child: Text("Abraham Jonathan Hortalanus"),
              ),
              Center(
                child: Text("Nicodemus Anggit Krisnuaji"),
              ),
              Center(
                child: Text("Natasya Irwanto"),
              ),
              Center(
                child: Text("Natalia Oktaviani Herindra Putri"),
              ),
              Center(
                child: Text("Gratia Lishe Emerald Sagay"),
              ),
            ],
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
