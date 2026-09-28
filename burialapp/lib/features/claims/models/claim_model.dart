class ClaimModel {
  final String id;
  final String? claimType;
  final String beneficiary;
  final double amount;
  final String claimDate;
  final String status;
  final String? approvedDate;
  final String? paymentDate;

  ClaimModel.fromJson(Map<String, dynamic> json)
    : id = json['id'].toString(),
      claimType = json['claim_type']?.toString(),
      beneficiary = (json['beneficiary'] ?? 'N/A').toString(),
      amount = double.tryParse(json['amount'].toString()) ?? 0.0,
      claimDate = (json['claim_date'] ?? '').toString(),
      status = (json['status'] ?? 'Pending').toString(),
      approvedDate = json['approved_date']?.toString(),
      paymentDate = json['payment_date']?.toString();
}
