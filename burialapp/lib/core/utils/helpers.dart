import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  static String formatDate(String? dateString, {String format = 'dd MMM yyyy'}) {
    if (dateString == null || dateString.isEmpty) return '—';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat(format).format(date);
    } catch (_) {
      return dateString;
    }
  }

  static String formatCurrency(double amount, {String symbol = 'E'}) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return '$symbol${formatter.format(amount)}';
  }

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'approved':
      case 'paid':
      case 'success':
        return Colors.green;
      case 'pending':
      case 'waiting':
        return Colors.orange;
      case 'rejected':
      case 'cancelled':
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
