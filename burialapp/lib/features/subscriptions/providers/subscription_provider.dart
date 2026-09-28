import 'package:flutter/material.dart';
import 'package:burialapp/core/network/api_client.dart';
import 'package:burialapp/features/subscriptions/models/subscription_model.dart';

class SubscriptionProvider with ChangeNotifier {
  List<SubscriptionModel> _statements = [];
  List<SubscriptionModel> get statements => _statements;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadStatements() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient().get('statements');
      if (response.data['success']) {
        _statements = (response.data['data'] as List)
            .map((e) => SubscriptionModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint("Statements Error: $e");
    }
    _isLoading = false;
    notifyListeners();
  }
}
