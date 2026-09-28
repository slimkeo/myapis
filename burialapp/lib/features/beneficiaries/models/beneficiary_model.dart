class BeneficiaryModel {
  final String id;
  final String fullName;
  final String gender;
  final String dob;
  final String status;
  final String maturityStatus;

  BeneficiaryModel.fromJson(Map<String, dynamic> json)
    : id = json['id'].toString(),
      fullName = json['full_name'] ?? '',
      gender = json['gender'] ?? '',
      dob = json['dob'] ?? '',
      status = json['status'] ?? '',
      maturityStatus = json['maturity_status'] ?? 'Waiting';
}
