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
      if (response.data['success']) {
        _dashboard = DashboardModel.fromJson(response.data['data']);
      } else {
        _errorMessage = response.data['message'] ?? 'Failed to load dashboard';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
