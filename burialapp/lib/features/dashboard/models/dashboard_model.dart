class DashboardModel {
  final int claims;
  final double monthlyContribution;
  final int beneficiaries;
  final String policyStatus;
  final double coverageAmount;

  DashboardModel.fromJson(Map<String, dynamic> json)
    : claims = json['claims'] ?? 0,
      monthlyContribution =
          double.tryParse(json['monthly_contribution'].toString()) ?? 150.0,
      beneficiaries = json['beneficiaries'] ?? 0,
      policyStatus = json['policy_status'] ?? 'Active',
      coverageAmount =
          double.tryParse(json['coverage_amount'].toString()) ?? 15000.0;
}
