import 'package:flutter/foundation.dart'; // for debugPrint
import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../models/beneficiary_model.dart';

class BeneficiaryProvider with ChangeNotifier {
  List<BeneficiaryModel> _beneficiaries = [];
  List<BeneficiaryModel> get beneficiaries => _beneficiaries;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadBeneficiaries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiClient().get('beneficiaries');

      if (response.data['success'] == true) {
        final data = response.data['data'];
        _beneficiaries = data is List
            ? data
                  .map(
                    (e) => BeneficiaryModel.fromJson(
                      Map<String, dynamic>.from(e as Map),
                    ),
                  )
                  .toList()
            : [];
      } else {
        _errorMessage =
            response.data['message']?.toString() ??
            'Failed to load beneficiaries';
        debugPrint('BeneficiaryProvider error: $_errorMessage');
        debugPrint('Full response: ${response.data}');
      }
    } catch (e, stackTrace) {
      _errorMessage = ApiClient.errorMessage(e);
      debugPrint('BeneficiaryProvider exception: $e');
      debugPrint('StackTrace: $stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
