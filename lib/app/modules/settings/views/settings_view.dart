import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/theme/app_theme.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
          child: CustomBackButton(
            onPressed: () => Get.back(),
          ),
        ),
        leadingWidth: 100,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 20),
            _buildSettingsOptions(borderColor),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: Image.network('https://picsum.photos/200/200').image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -40),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: Image.network('https://picsum.photos/200/200').image,
                backgroundColor: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 7,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: Colors.black, size: 20),
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildSettingsOptions(Color borderColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          _buildSettingItem(Icons.person_outline, 'Edit Profile', borderColor ),
          _buildSettingItem(Icons.location_on_outlined, 'Address', borderColor),
          _buildSettingItem(Icons.notifications_none, 'Notification', borderColor),
          _buildSettingItem(Icons.account_balance_wallet_outlined, 'E-Wallet', borderColor),
          _buildSettingItem(Icons.security, 'Security', borderColor),
          _buildSettingItem(Icons.language, 'Language', borderColor),
          _buildSettingItem(Icons.privacy_tip_outlined, 'Privacy Policy', borderColor),
          _buildSettingItem(Icons.help_outline, 'Support', borderColor),
          _buildSettingItem(Icons.group_outlined, 'Invite Friends', borderColor),
          _buildLogoutItem(),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, Color borderColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
         
        },
      ),
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
        
      },
    );
  }

  Widget _buildLogoutItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
     
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text('Logout', style: TextStyle(fontSize: 16, color: Colors.red)),
        onTap: () {
          controller.signOut();
        },
      ),
    );
  }
}