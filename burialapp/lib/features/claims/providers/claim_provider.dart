import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../models/claim_model.dart';

class ClaimProvider with ChangeNotifier {
  List<ClaimModel> _claims = [];
  List<ClaimModel> get claims => _claims;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadClaims() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiClient().get('claims');
      if (response.data['success'] == true) {
        final data = response.data['data'];
        _claims = data is List
            ? data.map((e) => ClaimModel.fromJson(Map<String, dynamic>.from(e as Map))).toList()
            : [];
      } else {
        _errorMessage = response.data['message']?.toString() ?? 'Failed to load claims';
      }
    } catch (e) {
      _errorMessage = ApiClient.errorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
