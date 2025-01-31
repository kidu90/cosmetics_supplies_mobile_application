import 'package:cosmetic_supplies_application/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:cosmetic_supplies_application/widgets/bottom_nav.dart';
import 'package:cosmetic_supplies_application/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Logout function
  void _logout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 30),
                child: const Column(
                  children: [
                    Text('Masha Kidurangi',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Column(
                children: [
                  ProfileMenu(title: 'Edit Profile'),
                  ProfileMenu(title: 'My orders'),
                  ProfileMenu(title: 'Shipping address'),
                  ProfileMenu(title: 'Help Center'),
                  ProfileMenu(
                    title: 'Log Out',
                    onTap: _logout,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }
}
