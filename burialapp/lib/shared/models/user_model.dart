class UserModel {
  final int id;
  final String surname;
  final String name;
  final String? cellnumber;
  final String? idnumber;
  final String? passbookNo;

  UserModel.fromJson(Map<String, dynamic> json)
    : id = int.tryParse(json['id'].toString()) ?? 0,
      surname = json['surname']?.toString() ?? '',
      name = json['name']?.toString() ?? '',
      cellnumber = json['cellnumber']?.toString(),
      idnumber = json['idnumber']?.toString(),
      passbookNo = json['passbook_no']?.toString();

  String get fullName {
    final parts = [name, surname].where((p) => p.trim().isNotEmpty);
    return parts.isEmpty ? 'Member' : parts.join(' ');
  }
}
