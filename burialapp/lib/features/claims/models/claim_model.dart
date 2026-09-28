class ClaimModel {
  final String id;
  final String beneficiary;
  final double amount;
  final String claimDate;
  final String status;
  final String? approvedDate;
  final String? paymentDate;

  ClaimModel.fromJson(Map<String, dynamic> json)
    : id = json['id'].toString(),
      beneficiary = json['beneficiary'] ?? 'N/A',
      amount = double.tryParse(json['amount'].toString()) ?? 0.0,
      claimDate = json['claim_date'] ?? '',
      status = json['status'] ?? 'Pending',
      approvedDate = json['approved_date'],
      paymentDate = json['payment_date'];
}
