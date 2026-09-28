class SubscriptionModel {
  final String id;
  final String date;
  final String description;
  final double amount;
  final String type;
  final String status;
  final String? source;

  SubscriptionModel.fromJson(Map<String, dynamic> json)
    : id = json['id'].toString(),
      date = (json['date'] ?? '').toString(),
      description = (json['description'] ?? '').toString(),
      amount = double.tryParse(json['amount'].toString()) ?? 0.0,
      type = (json['type'] ?? '').toString(),
      status = (json['status'] ?? '').toString(),
      source = json['source']?.toString();
}
