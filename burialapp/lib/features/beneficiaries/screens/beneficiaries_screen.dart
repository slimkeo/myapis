import 'package:flutter/material.dart';

class BeneficiariesScreen extends StatelessWidget {
  const BeneficiariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beneficiaries')),
      body: const Center(child: Text('Beneficiaries Screen')),
    );
  }
}
