import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PackageModel {
  PackageModel({
    required this.name,
    required int price,
    required this.features,
    this.minGuests = 150,
    this.popular = false,
    bool visible = true,
  })  : price = RxInt(price),
        visible = RxBool(visible);

  final String name;
  final RxInt price; // per head
  final List<String> features;
  final int minGuests;
  final bool popular;
  final RxBool visible; // shown to customers or not
}

class PackagesController extends GetxController {
  final RxList<PackageModel> packages = <PackageModel>[
    PackageModel(
      name: 'Silver',
      price: 2200,
      features: [
        '2 main dishes + rice',
        'Soft drinks & mineral water',
        'Standard stage décor',
      ],
    ),
    PackageModel(
      name: 'Gold',
      price: 2800,
      popular: true,
      features: [
        '3 main dishes + BBQ',
        'Dessert bar & tea station',
        'Premium stage décor',
      ],
    ),
  ].obs;

  // Peak-day pricing (Fri, Sat, Sun)
  final RxBool peakEnabled = true.obs;
  final RxInt peakPercent = 10.obs;

  void duplicate(PackageModel p) {
    final copy = PackageModel(
      name: '${p.name} copy',
      price: p.price.value,
      features: List<String>.from(p.features),
      minGuests: p.minGuests,
      visible: p.visible.value,
    );
    packages.insert(packages.indexOf(p) + 1, copy);
  }

  void addPackage() {
    packages.add(PackageModel(
      name: 'New package',
      price: 2000,
      features: ['Add your menu items'],
    ));
  }

  /// Small dialog to change the per-head price.
  void editPrice(PackageModel p) {
    final tc = TextEditingController(text: p.price.value.toString());
    Get.defaultDialog(
      title: 'Edit ${p.name} price',
      content: TextField(
        controller: tc,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(prefixText: 'Rs ', suffixText: '/ head'),
      ),
      textConfirm: 'Save',
      textCancel: 'Cancel',
      onConfirm: () {
        final v = int.tryParse(tc.text);
        if (v != null && v > 0) p.price.value = v;
        Get.back();
      },
    );
  }
}