// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:santai/app/common/widgets/custom_back_button.dart';
// import 'package:santai/app/routes/app_pages.dart';
// import 'package:santai/app/theme/app_theme.dart';
// import '../controllers/motorcycle_detail_controller.dart';

// class MotorcycleDetailView extends GetView<MotorcycleDetailController> {
//   const MotorcycleDetailView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     final Color primary_300 = Theme.of(context).colorScheme.primary_300;
//     final Color button_text_01 = Theme.of(context).colorScheme.button_text_01;
    


//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: Padding(
//           padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
//           child: CustomBackButton(
//             onPressed: () => Get.back(),
//           ),
//         ),
//         leadingWidth: 100,
//         title: const Text(
//           'Motorcycle',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         centerTitle: true,
//       ),

//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//                 TextButton.icon(
//                 onPressed: () {
//                   Get.toNamed(Routes.REG_MOTORCYCLE);
//                 },
//                 icon: Icon(Icons.add_circle_outline, color: button_text_01, size: 18),
//                 label: Text(
//                   'Add more',
//                   style: TextStyle(
//                     color: button_text_01,
//                     fontSize: 14,
//                   ),
//                 ),
//                 style: TextButton.styleFrom(
//                   backgroundColor: primary_300,
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               _buildMotorcycleChips(context),
//               const SizedBox(height: 10),
//               _buildMotorcycleCard(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// Widget _buildMotorcycleChips(BuildContext context) {
//   final Color primary_300 = Theme.of(context).colorScheme.primary_300;
//   final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

//   return Obx(() => SingleChildScrollView(
//     scrollDirection: Axis.horizontal,
//     child: Wrap(
//       spacing: 8,
//       children: controller.motorcycles.map((motorcycle) {
//         return Container(
//           margin: const EdgeInsets.symmetric(vertical: 1),
//           child: ChoiceChip(
//             padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//             label: Text(
//               motorcycle,
//               style: const TextStyle(fontSize: 12), 
//             ),
//             selected: motorcycle == controller.selectedMotorcycle.value,
//             onSelected: (selected) {
//               if (selected) {
//                 controller.updateSelectedMotorcycle(motorcycle);
//               }
//             },
//             selectedColor: primary_300,
//             backgroundColor: Colors.white, 
//             labelStyle: TextStyle(
//               color: motorcycle == controller.selectedMotorcycle.value ? Colors.white : Colors.black,
//             ),
//             checkmarkColor: Colors.white,
//             side: BorderSide(color: borderColor, width: 1),
//           ),
//         );
//       }).toList(),
//     ),
//   ));
// }

//   Widget _buildMotorcycleCard(BuildContext context) {

//   final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
//   final Color warning_300 = Theme.of(context).colorScheme.warning_300;

//   return Obx(() => Card(
//     color: Colors.white,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(20),
//       side: BorderSide(color: borderColor, width: 1),
//     ),
//     child: Column(
//       children: [
      
//         Stack(
//           children: [
//             AspectRatio(
//               aspectRatio: 16 / 9,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: const BorderRadius.only(
//                     topRight: Radius.circular(20),
//                     topLeft: Radius.circular(20),
//                     bottomRight: Radius.circular(20),
//                     bottomLeft: Radius.zero,
//                   ),
//                 ),
//                 child: const Center(
//                   child: Icon(Icons.image, size: 60, color: Colors.grey),
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 0,
//               bottom: 0,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: warning_300,
//                   borderRadius: const BorderRadius.only(
//                     topRight: Radius.circular(20),
//                     topLeft: Radius.zero,
//                     bottomRight: Radius.zero,
//                     bottomLeft: Radius.zero,
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(10, 8, 20, 8),
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Get.toNamed(Routes.MOTORCYCLE_INFORMATION);
//                         },
//                         child: const Icon(Icons.edit_square, color: Colors.white, size: 18),
//                       ),
//                       SizedBox(width: 5),
//                       Text(
//                         controller.selectedMotorcycle.value,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
              
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Preference', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   GestureDetector(
//                     onTap: () {
//                     },
//                     child: const Icon(Icons.edit, color: Colors.grey, size: 18),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               _buildPreferenceRow(context),
//               const SizedBox(height: 16),
//               ...controller.currentMotorcycleDetails.entries.map(
//                 (entry) => _buildDetailRow(entry.key, entry.value),
//               ),
//             ],
//           ),
//         ),
        
//       ],
//     ),
//   ));
// }

// Widget _buildPreferenceRow(BuildContext context) {

//   final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     children: controller.preferenceItems.map((item) {
//       return Expanded(
//         child: Container(
//           height: 150,
//           margin: const EdgeInsets.symmetric(horizontal: 6),
//           padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: borderColor.withOpacity(0.3),
//                 spreadRadius: 1,
//                 blurRadius: 2,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               ClipOval(
//                 child: Container(
//                   color: Colors.white,
//                   child: ClipOval(
//                     child: Image.network('https://picsum.photos/200/200', fit: BoxFit.cover),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Flexible(
//                 child: Text(
//                   item['title'] as String,
//                   style: TextStyle(fontSize: 14, color: Colors.black),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               Flexible(
//                 child: Text(
//                   item['subtitle'] as String,
//                   style: const TextStyle(fontSize: 12, color: Colors.black),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }).toList(),
//   );
// }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: TextStyle(color: Colors.black)),
//           Text(value, style: const TextStyle(color: Colors.black)),
//         ],
//       ),
//     );
//   }
// }