import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:burialapp/core/network/api_client.dart';
import 'package:burialapp/features/dashboard/models/dashboard_model.dart';
import 'package:burialapp/features/beneficiaries/models/beneficiary_model.dart';

class DashboardProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  DashboardModel? _dashboard;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DashboardModel? get dashboard => _dashboard;

  // Fees (match your PHP fee settings)
  static const double principalFee = 30.0;
  static const double memberFee = 15.0;
  static const double spouseFee = 15.0;

  Future<void> loadDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Load dashboard base data
      final dashResponse = await ApiClient().get('dashboard');

      if (dashResponse.data['success'] != true) {
        _errorMessage =
            dashResponse.data['message']?.toString() ??
            'Failed to load dashboard';
        return;
      }

      final data = Map<String, dynamic>.from(dashResponse.data['data'] as Map);

      // 2. Load beneficiaries (needed for correct calculation)
      final benResponse = await ApiClient().get('beneficiaries');
      List<BeneficiaryModel> beneficiaries = [];

      if (benResponse.data['success'] == true) {
        final list = benResponse.data['data'];
        if (list is List) {
          beneficiaries = list
              .map(
                (e) => BeneficiaryModel.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList();
        }
      }

      // 3. Calculate monthly contribution the correct way
      _dashboard = DashboardModel.calculate(
        claims: data['claims'] ?? 0,
        policyStatus: data['policy_status'] ?? 'Active',
        coverageAmount:
            double.tryParse(data['coverage_amount'].toString()) ?? 15000.0,
        beneficiaries: beneficiaries,
        principalFee: principalFee,
        memberFee: memberFee,
        spouseFee: spouseFee,
      );
    } catch (e, stackTrace) {
      _errorMessage = ApiClient.errorMessage(e);
      debugPrint('DashboardProvider exception: $e');
      debugPrint('StackTrace: $stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
