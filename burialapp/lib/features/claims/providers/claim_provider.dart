import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../models/claim_model.dart';

class ClaimProvider with ChangeNotifier {
  List<ClaimModel> _claims = [];
  List<ClaimModel> get claims => _claims;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadClaims() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient().get('claims');
      if (response.data['success']) {
        _claims = (response.data['data'] as List)
            .map((e) => ClaimModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint("Claims Error: $e");
    }
    _isLoading = false;
    notifyListeners();
  }
}
