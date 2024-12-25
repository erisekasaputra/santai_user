import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai/app/common/widgets/custom_back_button.dart';
import 'package:santai/app/theme/app_theme.dart';
import '../controllers/support_screen_controller.dart';

class SupportScreenView extends GetView<SupportScreenController> {
  const SupportScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color primary_100 = Theme.of(context).colorScheme.primary_100;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
          child:
              CustomBackButton(onPressed: () => Get.back(closeOverlays: true)),
        ),
        leadingWidth: 100,
        title: const Text(
          'Support',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: _buildFAQList(borderInput_01, primary_300),
            ),
          ),
          _buildContactSection(primary_100, primary_300),
        ],
      ),
    );
  }

  Widget _buildFAQList(Color borderInput_01, Color primary_300) {
    return Column(
      children: controller.faqItems
          .map((item) => _buildFAQItem(item, borderInput_01, primary_300))
          .toList(),
    );
  }

  Widget _buildFAQItem(FaqItem faq, Color borderInput_01, Color primary_300) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderInput_01, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // The FAQ question tile
          Obx(() {
            return ListTile(
              title: Text(faq.question,
                  style: const TextStyle(color: Colors.black)),
              trailing: Icon(
                controller.expandedIndex.value == faq.id
                    ? Icons.expand_less
                    : Icons.expand_more,
                color: primary_300,
                weight: 2,
              ),
              onTap: () {
                controller.toggleExpanded(faq.id);
              },
            );
          }),

          // Expanded answer section
          Obx(() {
            if (controller.expandedIndex.value == faq.id) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft, // Align text to the left
                  child: Text(
                    faq.answer, // Display the answer when expanded
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildContactSection(Color primary_100, Color primary_300) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary_100, primary_300],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Would you like to our representative ?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(Icons.phone, '(+60)3 412 3456'),
          _buildContactItem(Icons.email, 'support@santaitechnology.com'),
          _buildContactItem(Icons.chat, 'Live Agent'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
