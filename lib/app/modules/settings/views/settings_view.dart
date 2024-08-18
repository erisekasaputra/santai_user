import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            const Divider(),
            _buildSettingsOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(controller.profileImageUrl),
              ),
              Container(
                padding: const EdgeInsets.all(8.0), // Added padding
                decoration: BoxDecoration(
                  color: Colors.blue[800],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            controller.userName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            controller.phoneNumber,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOptions() {
    return Column(
      children: [
        _buildSettingItem(Icons.person_outline, 'Edit Profile'),
        _buildSettingItem(Icons.location_on_outlined, 'Address'),
        _buildSettingItem(Icons.notifications_none, 'Notification'),
        _buildSettingItem(Icons.security, 'Security'),
        _buildLanguageItem(),
        _buildSettingItem(Icons.privacy_tip_outlined, 'Privacy Policy'),
        _buildSettingItem(Icons.help_outline, 'Support'),
        _buildSettingItem(Icons.group_outlined, 'Invite Friends'),
        _buildLogoutItem(),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[800]),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Handle tap for each setting
      },
    );
  }

  Widget _buildLanguageItem() {
    return ListTile(
      leading: Icon(Icons.language, color: Colors.blue[800]),
      title: const Text('Language', style: TextStyle(fontSize: 16)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(controller.currentLanguage, style: TextStyle(color: Colors.grey[600])),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        // Handle language selection
      },
    );
  }

  Widget _buildLogoutItem() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Logout', style: TextStyle(fontSize: 16, color: Colors.red)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Handle logout
      },
    );
  }
}