import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/domain/enumerations/user_types_enum.dart';
import 'package:santai/app/routes/app_pages.dart';
import 'package:santai/app/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

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
            onPressed: () => Get.back(closeOverlays: true),
          ),
        ),
        leadingWidth: 100,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
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
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: Image.asset('assets/images/background.png').image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -40,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      // Avatar with Border
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromRGBO(
                                255, 255, 255, 1.0), // Border Color
                            width: 6.0, // Border Width
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 200,
                          backgroundImage:
                              controller.profileImageUrl.value.isEmpty
                                  ? null
                                  : Image.network(
                                      '${controller.commonUrl}${controller.profileImageUrl.value}',
                                    ).image,
                          child: controller.profileImageUrl.value.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 35,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await controller.pickImage();
                        },
                        child: controller.userType.value ==
                                UserTypesEnum.regularUser
                            ? Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: controller.userType.value ==
                                        UserTypesEnum.regularUser
                                    ? (controller.isImageUploading.value
                                        ? const CircularProgressIndicator(
                                            color: Colors.blue,
                                            strokeWidth: 2,
                                          )
                                        : const Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                            size: 20,
                                          ))
                                    : const SizedBox.shrink(),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50), // Space for Avatar Compensation
            // Username Text
            Text(
              controller.userName.value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            // Phone Number Text
            Text(
              controller.phoneNumber.value,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildReferralCode(BuildContext context) {
    return AlertDialog(
      title: const Text("Referral Code"),
      content: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Share your referral code with friends to invite them to the app!",
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                controller.referralCode.value.isEmpty
                    ? 'N/A'
                    : controller.referralCode.value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            if (controller.referralCode.value.isEmpty) {
              Navigator.of(context).pop();
              return;
            }
            Navigator.of(context).pop();
            Clipboard.setData(
                ClipboardData(text: controller.referralCode.value));
          },
          child: const Text("Copy"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }

  Widget _buildPrivacyPolicy(BuildContext context) {
    return AlertDialog(
      title: const Text("Privacy Policy"),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 1, // 50% dari tinggi layar
        width: MediaQuery.of(context).size.width * 1, // 80% dari lebar layar
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: MarkdownBody(
              data: controller.privacyPolicy.value,
              onTapLink: (text, href, title) {
                if (href != null) {
                  launchUrl(Uri.parse(href));
                }
              },
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }

  Widget _buildTermsAndCondition(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Terms & Conditions",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height, // 60% dari tinggi layar
        width: MediaQuery.of(context).size.width, // 90% dari lebar layar
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: MarkdownBody(
              data: controller.termsAndCondition.value,
              onTapLink: (text, href, title) {
                if (href != null) {
                  launchUrl(Uri.parse(href));
                }
              },
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Close",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsOptions(Color borderColor) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              if (controller.userType.value == 'regularUser') ...[
                _buildSettingItem(Icons.person_3_outlined, 'Edit Profile',
                    borderColor, controller.onEditProfileTap)
              ],
              // _buildSettingItem(Icons.location_on_outlined, 'Address', borderColor,
              //     controller.onAddressTap),
              // _buildSettingItem(Icons.notifications_none, 'Notification',
              //     borderColor, controller.onNotificationTap),
              // _buildSettingItem(Icons.account_balance_wallet_outlined, 'E-Wallet',
              //     borderColor, controller.onEWalletTap),
              // _buildSettingItem(Icons.security, 'Security', borderColor,
              //     controller.onSecurityTap),
              // _buildSettingItem(Icons.language, 'Language', borderColor,
              //     controller.onLanguageTap),
              _buildSettingItem(
                  Icons.visibility_off, 'Privacy Policy', borderColor, () {
                showDialog(
                  context: Get.context!,
                  builder: (context) => _buildPrivacyPolicy(context),
                );
              }),
              _buildSettingItem(
                  Icons.privacy_tip_outlined, 'Terms & Condition', borderColor,
                  () {
                showDialog(
                  context: Get.context!,
                  builder: (context) => _buildTermsAndCondition(context),
                );
              }),
              _buildSettingItem(Icons.help_outline, 'Support', borderColor, () {
                Get.toNamed(Routes.SUPPORT_SCREEN);
              }),
              _buildSettingItem(
                  Icons.group_outlined, 'Invite Friends', borderColor, () {
                showDialog(
                  context: Get.context!,
                  builder: (context) => _buildReferralCode(context),
                );
              }),
              _buildLogoutItem(),
            ],
          );
        }));
  }

  Widget _buildSettingItem(
      IconData icon, String title, Color borderColor, Function() onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
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
          Text(controller.currentLanguage,
              style: TextStyle(color: Colors.grey[600])),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildLogoutItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Obx(() => ListTile(
            leading: controller.isLoggingOut.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  )
                : const Icon(Icons.logout, color: Colors.red),
            title: Text(
              controller.isLoggingOut.value ? 'Logging out...' : 'Logout',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            onTap: controller.isLoggingOut.value ? null : controller.doLogout,
          )),
    );
  }
}
