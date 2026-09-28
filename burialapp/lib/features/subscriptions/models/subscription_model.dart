class SubscriptionModel {
  final String id;
  final String date;
  final String description;
  final double amount;
  final String type;
  final String status;

  SubscriptionModel.fromJson(Map<String, dynamic> json)
    : id = json['id'].toString(),
      date = json['date'] ?? '',
      description = json['description'] ?? '',
      amount = double.tryParse(json['amount'].toString()) ?? 0.0,
      type = json['type'] ?? '',
      status = json['status'] ?? '';
}
