import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/service_detail_controller.dart';

class ServiceDetailView extends GetView<ServiceDetailController> {
  const ServiceDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ServiceDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ServiceDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
