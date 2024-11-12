import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/view/screens/profile/edit_profile.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';



class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            icon: Icon(Icons.edit, color: Colors.white),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image and Info
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://publichealth.uga.edu/wp-content/uploads/2020/01/Thomas-Cameron_Student_Profile.jpg'),
                ),
                SizedBox(height: 16),
                Text(
                  'Alwin Jhonny',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ), Text(
                  '8087935135',
                  style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 16),
                ),
                Text(
                  'alwinjhonny@gmail.com',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                
                SizedBox(height: 24),

                // Info Cards
               
                SizedBox(height: 32),

                // Menu Items
                MenuItem(
                  icon: Icons.school,
                  color: Colors.blue.shade100,
                  title: 'Education Information',
                  onTap: () {},
                ),
                MenuItem(
                  icon: Icons.card_membership,
                  color: Colors.teal.shade100,
                  title: 'Subscription Pack',
                  onTap: () {},
                ),
                MenuItem(
                  icon: Icons.payment,
                  color: Colors.blue.shade100,
                  title: 'Payment History',
                  onTap: () {},
                ),
                MenuItem(
                  icon: Icons.logout,
                  color: Colors.red.shade100,
                  title: 'Logout',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  InfoCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  MenuItem({required this.icon, required this.color, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.black87),
      ),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
