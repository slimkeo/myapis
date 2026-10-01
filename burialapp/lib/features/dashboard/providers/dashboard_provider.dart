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

  // Must match beneficiaries_screen.dart fee constants
  static const double principalFee = 30.0;
  static const double memberFee = 15.0;
  static const double spouseFee = 23.0;

  Future<void> loadDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final dashResponse = await ApiClient().get('dashboard');

      if (dashResponse.data['success'] != true) {
        _errorMessage =
            dashResponse.data['message']?.toString() ??
            'Failed to load dashboard';
        return;
      }

      final rawData = dashResponse.data['data'];
      if (rawData is! Map) {
        _errorMessage = 'Invalid dashboard response';
        return;
      }

      final data = Map<String, dynamic>.from(rawData);

      // Load beneficiaries so monthly contribution uses the same
      // payable-member / payable-spouse rules as Beneficiaries screen.
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

      _dashboard = DashboardModel.calculate(
        claims: int.tryParse(data['claims'].toString()) ?? 0,
        policyStatus: data['policy_status']?.toString() ?? 'Active',
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
