import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../models/beneficiary_model.dart';

class BeneficiaryProvider with ChangeNotifier {
  List<BeneficiaryModel> _beneficiaries = [];
  List<BeneficiaryModel> get beneficiaries => _beneficiaries;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadBeneficiaries() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient().get('beneficiaries');
      if (response.data['success']) {
        _beneficiaries = (response.data['data'] as List)
            .map((e) => BeneficiaryModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint("Beneficiaries Error: $e");
    }
    _isLoading = false;
    notifyListeners();
  }
}
