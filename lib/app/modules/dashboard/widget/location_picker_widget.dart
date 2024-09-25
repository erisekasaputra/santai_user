import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class LocationPickerWidget extends GetView<DashboardController> {
  LocationPickerWidget({Key? key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: TextField(
          //     controller: searchController,
          //     decoration: InputDecoration(
          //       hintText: 'Cari alamat',
          //       prefixIcon: Icon(Icons.search, color: Colors.orange),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(30),
          //         borderSide: BorderSide.none,
          //       ),
          //       filled: true,
          //       fillColor: Colors.grey[200],
          //     ),
          //     onSubmitted: searchPlaces,
          //   ),
          // ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await controller.getCurrentLocation();
                  Get.back();
                },
                icon: Obx(() => controller.isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : Icon(Icons.my_location)),
                label: Text('Current Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  controller.openMap();
                },
                icon: Icon(Icons.map),
                label: Text('Select on Map'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Favorite Address',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  child:
                      Text('View All', style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => ListView(
                  children: [
                    ...controller.favoriteAddresses
                        .map((address) => _buildAddressItem(address)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextButton(
                        onPressed: () {},
                        child: Text('View All',
                            style: TextStyle(color: Colors.green)),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Last Location',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ...controller.recentAddresses
                        .map((address) => _buildAddressItem(address)),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressItem(Map<String, dynamic> address) {
    return FutureBuilder<String>(
      future:
          _getAddressFromCoordinates(address['latitude'], address['longitude']),
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
  icon: Icon(Icons.more_vert),
  onSelected: (item) => controller.handleMenuSelection(item, address),
  itemBuilder: (context) => [
    PopupMenuItem<int>(value: 0, child: Text('Delete')),
    PopupMenuItem<int>(value: 1, child: Text('Favorite')),
  ],
),
          onTap: () {
            Get.back();
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
    } catch (e) {
      print("Error getting address: $e");
    }
    return 'Address not found';
  }
}
