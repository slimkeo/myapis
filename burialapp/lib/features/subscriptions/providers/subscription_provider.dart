import 'package:flutter/material.dart';
import 'package:burialapp/core/network/api_client.dart';
import 'package:burialapp/features/subscriptions/models/subscription_model.dart';

class SubscriptionProvider with ChangeNotifier {
  List<SubscriptionModel> _statements = [];
  List<SubscriptionModel> get statements => _statements;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadStatements() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiClient().get('statements');
      if (response.data['success'] == true) {
        final data = response.data['data'];
        _statements = data is List
            ? data
                  .map(
                    (e) => SubscriptionModel.fromJson(
                      Map<String, dynamic>.from(e as Map),
                    ),
                  )
                  .toList()
            : [];
      } else {
        _errorMessage =
            response.data['message']?.toString() ??
            'Failed to load subscriptions';
      }
    } catch (e) {
      _errorMessage = ApiClient.errorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
