import 'dart:async';

// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_place/google_place.dart';

class MapPickerController extends GetxController {
  Completer<GoogleMapController> _mapControllerCompleter = Completer();
  late GoogleMapController mapController;
  final currentPosition = const LatLng(0, 0).obs;
  final selectedPosition = const LatLng(0, 0).obs;
  final selectedAddress = 'Mencari alamat...'.obs;
  final selectedAddressName = ''.obs;
  final GooglePlace googlePlace =
      GooglePlace('AIzaSyB78aKvbp0DNLlAxmHaLZ020HSOOzwAva8');
  final isLoading = false.obs;
  final isLoadingCurrentLocation = false.obs;
  Timer? _debounce;

  final searchResults = <AutocompletePrediction>[].obs;

  @override
   void onInit() {
    super.onInit();
    _initializeMap();
  }

    Future<void> _initializeMap() async {
    await getCurrentLocation();
    mapController = await _mapControllerCompleter.future;
    mapController.animateCamera(CameraUpdate.newLatLng(currentPosition.value));
    updateSelectedAddress();
  }

 void onMapCreated(GoogleMapController controller) {
    if (!_mapControllerCompleter.isCompleted) {
      _mapControllerCompleter.complete(controller);
    }
  }

  void onCameraMove(CameraPosition position) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      selectedPosition.value = position.target;
      updateSelectedAddress();
    });
  }

Future<void> getCurrentLocation() async {
  try {
    isLoadingCurrentLocation.value = true;
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition.value = LatLng(position.latitude, position.longitude);
    selectedPosition.value = currentPosition.value;
    mapController.animateCamera(CameraUpdate.newLatLng(currentPosition.value));
    updateSelectedAddress();
  } catch (e) {
    print("Error getting current location: $e");
  } finally {
    isLoadingCurrentLocation.value = false;
  }
}

  // void goToCurrentLocation() {
  //   mapController.animateCamera(CameraUpdate.newLatLng(currentPosition.value));
  // }
Future<void> updateSelectedAddress() async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      selectedPosition.value.latitude,
      selectedPosition.value.longitude,
    );
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      selectedAddressName.value =
          placemark.subLocality ?? placemark.locality ?? 'Unknown';
      selectedAddress.value =
          "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.postalCode}, ${placemark.country}";
    }
  } catch (e) {
    print("Error getting address: $e");
    selectedAddressName.value = 'Unknown';
    selectedAddress.value = 'Failed to get address';
  }
}

  Future<void> confirmLocation() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      Get.back(result: {
        'address': selectedAddress.value,
        'position': selectedPosition.value
      });
    } catch (e) {
      print("Error confirming location: $e");
    } finally {
      isLoading.value = false;
    }
  }

void searchPlaces(String query) async {
    if (query.isNotEmpty) {
      var result = await googlePlace.autocomplete.get(query);
      if (result != null && result.predictions != null) {
        searchResults.value = result.predictions!;
      } else {
        searchResults.clear();
      }
    } else {
      searchResults.clear();
    }
  }

  void selectPlace(AutocompletePrediction prediction) async {
  try {
    var details = await googlePlace.details.get(prediction.placeId!);
    if (details != null && details.result != null) {
      LatLng location = LatLng(
        details.result!.geometry!.location!.lat!,
        details.result!.geometry!.location!.lng!,
      );
      if (_mapControllerCompleter.isCompleted) {
        mapController = await _mapControllerCompleter.future;
        await mapController.animateCamera(CameraUpdate.newLatLngZoom(location, 14));
        selectedPosition.value = location;
        await updateSelectedAddress();
      } else {
        print("Map controller not initialized");
      }
    }
  } catch (e) {
    print("Error selecting place: $e");
  } finally {
    searchResults.clear();
  }
}
}
