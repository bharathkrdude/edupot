import 'package:edupot/core/services/authprovier.dart';
import 'package:edupot/view/screens/authentication/login.dart';
import 'package:edupot/view/screens/profile/change_password_screen.dart';
import 'package:edupot/view/screens/profile/edit_profile.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:edupot/viewmodels/staff_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StaffProfileProvider>(context, listen: false).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        actions: [
          Consumer<StaffProfileProvider>(
            builder: (context, provider, child) {
              final staff = provider.staffProfile!;
              return staff.id == 0
                  ? Container()
                  : IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfileScreen()),
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                    );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Consumer<StaffProfileProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.staffProfile == null) {
                  return const Center(child: Text("Failed to load profile."));
                }

                final staff = provider.staffProfile!;
                print('imagePath: ${staff.imagePath}');
                print('image: ${staff.image}');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage(staff.imagePath + staff.image),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      staff.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      staff.phone,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7), fontSize: 16),
                    ),
                    Text(
                      staff.email,
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    MenuItem(
                      icon: Icons.lock_reset_rounded,
                      color: Colors.blue.shade100,
                      title: 'Change Password',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChangePassWordScreen(),
                        ));
                      },
                    ),
                    MenuItem(
                      icon: Icons.logout,
                      color: Colors.red.shade100,
                      title: 'Logout',
                      onTap: () {
                        context.read<AuthProvider>().logout();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ));
                      },
                    ),
                  ],
                );
              },
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

  const InfoCard(
      {super.key,
      required this.title,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
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

  const MenuItem(
      {super.key,
      required this.icon,
      required this.color,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.black87),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
