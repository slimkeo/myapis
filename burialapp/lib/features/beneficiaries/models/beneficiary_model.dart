class BeneficiaryModel {
  final String id;
  final String fullName;
  final String gender;
  final String dob;
  final String status;
  final bool isSpouse;
  final String? submissionDate;
  final String? statusDate;

  BeneficiaryModel.fromJson(Map<String, dynamic> json)
    : id = json['id'].toString(),
      fullName = (json['full_name'] ?? json['nameof'] ?? '').toString(),
      gender = (json['gender'] ?? '').toString(),
      dob = (json['dob'] ?? '').toString(),
      status = (json['status'] ?? '').toString(),
      isSpouse = json['is_spouse'] == true ||
          json['is_spouse'] == 1 ||
          json['is_spouse']?.toString() == '1',
      submissionDate = json['submission_date']?.toString(),
      statusDate = json['status_date']?.toString();
}
