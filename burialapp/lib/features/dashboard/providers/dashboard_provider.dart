import 'package:flutter/material.dart';
import 'package:burialapp/core/network/api_client.dart';
import 'package:burialapp/features/dashboard/models/dashboard_model.dart';

class DashboardProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  DashboardModel? _dashboard;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DashboardModel? get dashboard => _dashboard;

  Future<void> loadDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiClient().get('dashboard');
      if (response.data['success'] == true) {
        _dashboard = DashboardModel.fromJson(
          Map<String, dynamic>.from(response.data['data'] as Map),
        );
      } else {
        _errorMessage = response.data['message']?.toString() ?? 'Failed to load dashboard';
      }
    } catch (e) {
      _errorMessage = ApiClient.errorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
