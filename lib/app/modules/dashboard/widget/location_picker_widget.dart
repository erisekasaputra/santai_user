import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class LocationPickerWidget extends GetView<DashboardController> {
  const LocationPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await controller.getCurrentLocation();

                  if (Get.isDialogOpen ?? false) {
                    Get.back(closeOverlays: true);
                  } else {
                    Get.back(closeOverlays: true);
                  }
                },
                icon: Obx(() => controller.isLocationLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : const Icon(Icons.my_location)),
                label: const Text('Current Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (Get.isDialogOpen ?? false) {
                    Get.back(closeOverlays: true);
                  } else {
                    Get.back(closeOverlays: true);
                  }
                  controller.openMap();
                },
                icon: const Icon(Icons.map),
                label: const Text('Select on Map'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Text('Favorite Address',
          //           style: TextStyle(fontWeight: FontWeight.w600)),
          //       TextButton(
          //         onPressed: () {},
          //         child: const Text('View All',
          //             style: TextStyle(color: Colors.green)),
          //       ),
          //     ],
          //   ),
          // ),
          // Expanded(
          //   child: Obx(
          //     () => ListView(
          //       children: [
          //         ...controller.favoriteAddresses
          //             .map((address) => _buildAddressItem(address)),
          //         Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //           child: TextButton(
          //             onPressed: () {},
          //             child: const Text('View All',
          //                 style: TextStyle(color: Colors.green)),
          //           ),
          //         ),
          //         const SizedBox(height: 16),
          //         const Padding(
          //           padding: EdgeInsets.symmetric(horizontal: 16.0),
          //           child: Text('Last Location',
          //               style: TextStyle(fontWeight: FontWeight.w600)),
          //         ),
          //         ...controller.recentAddresses
          //             .map((address) => _buildAddressItem(address)),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Widget _buildAddressItem(Map<String, dynamic> address) {
  //   return FutureBuilder<String>(
  //     future:
  //         _getAddressFromCoordinates(address['latitude'], address['longitude']),
  //     builder: (context, snapshot) {
  //       String addressText = snapshot.data ?? 'Loading address...';
  //       return ListTile(
  //         leading: CircleAvatar(
  //           backgroundColor: Colors.grey[300],
  //           child: Icon(Icons.location_on, color: Colors.grey[600]),
  //         ),
  //         title: Text(address['name']),
  //         subtitle:
  //             Text(addressText, maxLines: 2, overflow: TextOverflow.ellipsis),
  //         trailing: PopupMenuButton<int>(
  //           icon: const Icon(Icons.more_vert),
  //           onSelected: (item) => controller.handleMenuSelection(item, address),
  //           itemBuilder: (context) => [
  //             const PopupMenuItem<int>(value: 0, child: Text('Delete')),
  //             PopupMenuItem<int>(
  //               value: 1,
  //               child: Row(
  //                 children: [
  //                   Icon(
  //                     address['isFavorite'] == 1
  //                         ? Icons.favorite
  //                         : Icons.favorite_border,
  //                     color: address['isFavorite'] == 1 ? Colors.red : null,
  //                   ),
  //                   const SizedBox(width: 8),
  //                   Text(address['isFavorite'] == 1
  //                       ? 'Remove from Favorites'
  //                       : 'Add to Favorites'),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         onTap: () {
  //           Get.back(closeOverlays: true);
  //           controller.locationService.address.value =
  //               '${address['name']} ($addressText)';
  //         },
  //       );
  //     },
  //   );
  // }
  Widget _buildAddressItem(Map<String, dynamic> address) {
    var locationName =
        _getAddressFromCoordinates(address['latitude'], address['longitude']);
    return FutureBuilder<String>(
      future: locationName,
      builder: (context, snapshot) {
        String addressText = snapshot.data ?? 'Loading address...';
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.location_on, color: Colors.grey[600]),
          ),
          title: Text(address['name']),
          subtitle:
              Text(addressText, maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            onSelected: (item) => controller.handleMenuSelection(item, address),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(value: 0, child: Text('Delete')),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      address['isFavorite'] == 1
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: address['isFavorite'] == 1 ? Colors.red : null,
                    ),
                    const SizedBox(width: 8),
                    Text(address['isFavorite'] == 1
                        ? 'Remove from Favorites'
                        : 'Add to Favorites'),
                  ],
                ),
              ),
            ],
          ),
          onTap: () {
            if (Get.isDialogOpen ?? false) {
              Get.back(closeOverlays: true);
            } else {
              Get.back(closeOverlays: true);
            }

            controller.locationService.address.value =
                '${address['name']} ($addressText)';
          },
        );
      },
    );
  }

  Future<String> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        return "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.country}";
      }

      return "Unknown address";
    } catch (e) {
      return "Failed to fetch the line address";
    }
  }
}
