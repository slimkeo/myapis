import '../../beneficiaries/models/beneficiary_model.dart';

class DashboardModel {
  final int claims;
  final double monthlyContribution;
  final int beneficiaries;
  final String policyStatus;
  final double coverageAmount;
  final int payableMembers;
  final int payableSpouses;

  DashboardModel({
    required this.claims,
    required this.monthlyContribution,
    required this.beneficiaries,
    required this.policyStatus,
    required this.coverageAmount,
    this.payableMembers = 0,
    this.payableSpouses = 0,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      claims: int.tryParse(json['claims'].toString()) ?? 0,
      monthlyContribution:
          double.tryParse(json['monthly_contribution'].toString()) ?? 0.0,
      beneficiaries: int.tryParse(json['beneficiaries'].toString()) ?? 0,
      policyStatus: json['policy_status']?.toString() ?? 'Active',
      coverageAmount:
          double.tryParse(json['coverage_amount'].toString()) ?? 15000.0,
    );
  }

  /// Same formula as BeneficiariesScreen:
  /// principal + (payable members × memberFee) + (payable spouses × spouseFee)
  factory DashboardModel.calculate({
    required int claims,
    required String policyStatus,
    required double coverageAmount,
    required List<BeneficiaryModel> beneficiaries,
    required double principalFee,
    required double memberFee,
    required double spouseFee,
  }) {
    final payableMembers = beneficiaries
        .where((b) => b.isPayable && !b.isSpouse)
        .length;
    final payableSpouses = beneficiaries
        .where((b) => b.isPayable && b.isSpouse)
        .length;

    final total =
        principalFee +
        (payableMembers * memberFee) +
        (payableSpouses * spouseFee);

    return DashboardModel(
      claims: claims,
      monthlyContribution: total,
      beneficiaries: beneficiaries.length,
      policyStatus: policyStatus,
      coverageAmount: coverageAmount,
      payableMembers: payableMembers,
      payableSpouses: payableSpouses,
    );
  }
}
