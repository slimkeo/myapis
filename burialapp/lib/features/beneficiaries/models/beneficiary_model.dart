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
    : id = (json['id'] ?? '').toString(),
      fullName = (json['fullname'] ?? '').toString(),
      gender = (json['gender'] ?? '').toString(),
      dob = (json['dob'] ?? '').toString(),
      status = (json['status'] ?? '').toString(),
      isSpouse =
          json['is_spouse'] == true ||
          json['is_spouse'] == 1 ||
          json['is_spouse']?.toString() == '1',
      submissionDate = json['submission_date']?.toString(),
      statusDate = json['status_date']?.toString();

  // ========== EXACT PHP LOGIC ==========

  static const List<String> nonPayableStatuses = [
    'BENEFITTED - REPLACED',
    'DECEASED - REPLACED',
    'DELETED',
    'LATE NOT BENEFITTED',
    'PASSBOOK REPLACEMENT',
    'LATE NOT BENEFITTED - REPLACED',
  ];

  bool get isPayable {
    final s = status.trim();
    return !nonPayableStatuses.contains(s);
  }

  String get maturityStatus {
    final s = status.toUpperCase().trim().replaceAll(' ', '');

    if (s == 'BENEFITTED' || s == 'BENEFITTED-REPLACED') {
      return '';
    }

    if (submissionDate == null || submissionDate!.isEmpty) {
      return 'Waiting';
    }

    final submitted = DateTime.tryParse(submissionDate!);
    if (submitted == null) return 'Waiting';

    final maturityDate = DateTime(
      submitted.year + 1,
      submitted.month,
      submitted.day,
    );

    final now = DateTime.now();
    return (now.isAfter(maturityDate) || now.isAtSameMomentAs(maturityDate))
        ? 'Matured'
        : 'Waiting';
  }

  bool get isReplacee =>
      status.toUpperCase().trim().replaceAll(' ', '') == 'REPLACEE';
}
