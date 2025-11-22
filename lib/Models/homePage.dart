import 'package:Afghan_Donors/Models/signUp.dart';
import 'package:Afghan_Donors/api_service.dart' hide SignUp;
import 'package:flutter/material.dart';
import 'DonerPage.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  Map<String, dynamic>? _user;
  bool _loadingUser = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _loadingUser = true);
    final phone = await LocalStorage.getUserPhone();
    if (phone != null) {
      final user = await ApiService().getUserByPhone(phone);
      if (user != null) {
        _user = user;
      } else {
        await LocalStorage.deleteUserPhone();
      }
    }
    setState(() => _loadingUser = false);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget profileTab;
    if (_loadingUser) {
      profileTab = const Center(child: CircularProgressIndicator());
    } else if (_user != null) {
      profileTab = ProfilePage(user: _user!);
    } else {
      profileTab = const SignUp();
    }

    final pages = [profileTab, const DonorPage()];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFE53935),
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 28),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: 28),
            label: 'Donor',
          ),
        ],
      ),
    );
  }
}
