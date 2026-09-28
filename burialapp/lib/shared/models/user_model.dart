class UserModel {
  final int id;
  final String surname;
  final String name;
  final String? cellnumber;
  final String? idnumber;
  final String? passbookNo;

  UserModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      surname = json['surname'] ?? '',
      name = json['name'] ?? '',
      cellnumber = json['cellnumber'],
      idnumber = json['idnumber'],
      passbookNo = json['passbook_no'];
}
