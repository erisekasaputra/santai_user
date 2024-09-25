import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:santai/app/common/widgets/custom_elvbtn_001.dart';
import '../controllers/map_picker_controller.dart';

class MapPickerView extends GetView<MapPickerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Obx(() => GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: controller.currentPosition.value,
                        zoom: 15.0,
                      ),
                      onMapCreated: controller.onMapCreated,
                      onCameraMove: controller.onCameraMove,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      compassEnabled: false,
                      mapType: MapType.terrain,
                      buildingsEnabled: false,
                      tiltGesturesEnabled: true,
                      trafficEnabled: false,
                      indoorViewEnabled: true,
                      liteModeEnabled: false,
                      padding: EdgeInsets.only(bottom: 70),
                    )),
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: _buildSearchBar(),
                ),
                // const Center(
                //   child: Icon(Icons.location_on, color: Colors.red, size: 50),
                // ),
                const Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom:
                      110, 
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 50),
                   
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  child: _buildBackButton(),
                ),
                Positioned(
                  bottom: 20,
                  right: 16,
                  child: _buildCurrentLocationButton(),
                ),
              ],
            ),
          ),
          _buildAddressCard(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: TextField(
            onChanged: (value) {
              controller.searchPlaces(value);
            },
            decoration: const InputDecoration(
              hintText: 'Search location',
              border: InputBorder.none,
              icon: Icon(Icons.search),
            ),
          ),
        ),
        Obx(() => controller.searchResults.isNotEmpty
            ? Container(
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    final prediction = controller.searchResults[index];
                    return ListTile(
                      title: Text(prediction.description ?? ''),
                      onTap: () => controller.selectPlace(prediction),
                    );
                  },
                ),
              )
            : SizedBox.shrink()),
      ],
    );
  }

  Widget _buildBackButton() {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
    );
  }

 Widget _buildCurrentLocationButton() {
  return Obx(() => CircleAvatar(
    backgroundColor: Colors.white,
    child: controller.isLoadingCurrentLocation.value
      ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        )
      : IconButton(
          icon: Icon(Icons.my_location, color: Colors.black),
          onPressed: controller.getCurrentLocation,
        ),
  ));
}

  Widget _buildAddressCard() {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                 const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.selectedAddressName.value,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            controller.selectedAddress.value,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => CustomElevatedButton(
                  text: 'Konfirmasi alamat',
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.confirmLocation,
                  isLoading: controller.isLoading.value,
                )),
          ],
        ),
      );
    });
  }
}
