import 'package:flutter/material.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/home/home.dart';
import 'package:maju/views/product/products.dart';
import 'package:maju/data/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String _profileImagePath = '';
  int _selectedIndex = 2;
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _addressController;
  int? id;

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

  Future<void> updateUser(int id) async {
    await SQLHelper.updateProfile(
        id,
        _nameController!.text,
        _emailController!.text,
        _phoneNumberController!.text,
        _addressController!.text);

    // Update user data in shared preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accountData = [
      id.toString(),
      _emailController!.text,
      _nameController!.text,
      _phoneNumberController!.text,
      _addressController!.text,
    ];
    prefs.setStringList('account', accountData);
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? account = prefs.getStringList('account');
    setState(() {
      _nameController = TextEditingController(text: account?[2] ?? '');
      _phoneNumberController = TextEditingController(text: account?[3] ?? '');
      _emailController = TextEditingController(text: account?[1] ?? '');
      _addressController = TextEditingController(text: account?[4] ?? '');
      id = int.parse(account![0]);
    });
  }

  Future<void> _ambilGambarDariKamera() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final imagePath = pickedFile.path;
      // await SQLHelper.updateProfileImage(id!, imagePath);

      // Update gambar profil di SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('account', [
        id.toString(),
        _emailController!.text,
        _nameController!.text,
        _phoneNumberController!.text,
        _addressController!.text,
        imagePath, // Menambah path gambar ke SharedPreferences
      ]);

      setState(() {
        // Perbarui tampilan gambar profil
        _profileImagePath = imagePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              // backgroundImage: _profileImagePath.isNotEmpty ?
              // FileImage(File(_profileImagePath)): const AssetImage('assets/images/profile.jpg') as ImageProvider,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'No Telepon'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                await updateUser(id!);
                _loadUserData();
              },
              child: const Text('Save'),
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
    );
  }
}
