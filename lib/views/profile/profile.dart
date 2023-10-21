import 'package:flutter/material.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/home/home.dart';
import 'package:maju/views/product/products.dart';
import 'package:maju/data/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _selectedIndex = 2;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;

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
        break; // Tambahkan break di sini
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProfileView()),
        );
        break; // Tambahkan break di sini
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('Name');
    String? phone = prefs.getString('phone');
    String? email = prefs.getString('email');
    String? address = prefs.getString('address');

    setState(() {
      _nameController = TextEditingController(text: name ?? '');
      _phoneNumberController = TextEditingController(text: phone ?? '');
      _emailController = TextEditingController(text: email ?? '');
      _addressController = TextEditingController(text: address ?? '');
    });
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
              CircleAvatar(
                radius: 50, 
                backgroundImage: AssetImage('assets/images/profile.jpg'), 
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'No Telepon'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Menyimpan data di Shared Preferences
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('Name', _nameController.text);
                  await prefs.setString('phone', _phoneNumberController.text);
                  await prefs.setString('email', _emailController.text);
                  await prefs.setString('address', _addressController.text);

                  // Tampilkan pesan sukses atau lakukan navigasi ke halaman lain
                  // Contoh: 
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) => NextPage()),
                  // );
                },
                child: Text('Save'),
              ),
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
      ),
    );
  }
}
