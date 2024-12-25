import 'dart:async';

// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_place/google_place.dart';
import 'package:santai/app/common/widgets/custom_toast.dart';
import 'package:santai/app/helpers/sqlite_db_helper.dart';

class MapPickerController extends GetxController {
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  late GoogleMapController mapController;
  final currentPosition = const LatLng(0, 0).obs;
  final selectedPosition = const LatLng(0, 0).obs;
  final selectedAddress = 'Loading...'.obs;
  final selectedAddressName = ''.obs;
  final GooglePlace googlePlace =
      GooglePlace('AIzaSyB78aKvbp0DNLlAxmHaLZ020HSOOzwAva8');
  final isLoading = false.obs;
  final isLoadingCurrentLocation = false.obs;
  Timer? _debounce;
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final searchResults = <AutocompletePrediction>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await getCurrentLocation(isUsingSelectedPosition: true);
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

  Future<void> getCurrentLocation(
      {bool isUsingSelectedPosition = false}) async {
    try {
      isLoadingCurrentLocation.value = true;
      final currentAddress = await dbHelper.getCurrentAddress();

      double latitude = currentAddress?['latitude'] ?? 0.0;
      double longitude = currentAddress?['longitude'] ?? 0.0;

      if (latitude == 0.0 && longitude == 0.0 || !isUsingSelectedPosition) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        latitude = position.latitude;
        longitude = position.longitude;
      }

      currentPosition.value = LatLng(latitude, longitude);
      selectedPosition.value = currentPosition.value;
      mapController
          .animateCamera(CameraUpdate.newLatLng(currentPosition.value));
      updateSelectedAddress();
    } catch (_) {
    } finally {
      isLoadingCurrentLocation.value = false;
    }
  }

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
      selectedAddressName.value = 'Unknown';
      selectedAddress.value = 'Failed to get address';
    }
  }

  Future<void> confirmLocation() async {
    try {
      isLoading.value = true;
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.updateClearAddressSelected();
      final newAddress = {
        'name': "New Address",
        'latitude': selectedPosition.value.latitude,
        'longitude': selectedPosition.value.longitude,
        'isFavorite': 0,
        'isSelected': 1,
      };

      await dbHelper.createAddress(newAddress);
      Get.back(result: {'addressUpdated': true});
    } catch (e) {
      CustomToast.show(
        message: "Failed to save the address",
        type: ToastType.error,
      );
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
          await mapController
              .animateCamera(CameraUpdate.newLatLngZoom(location, 14));
          selectedPosition.value = location;
          await updateSelectedAddress();
        }
      }
    } catch (e) {
    } finally {
      searchResults.clear();
    }
  }
}
