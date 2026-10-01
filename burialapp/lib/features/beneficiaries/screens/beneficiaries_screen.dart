import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/helpers.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../providers/beneficiary_provider.dart';
import '../models/beneficiary_model.dart';

class BeneficiariesScreen extends StatefulWidget {
  const BeneficiariesScreen({super.key});

  @override
  State<BeneficiariesScreen> createState() => _BeneficiariesScreenState();
}

class _BeneficiariesScreenState extends State<BeneficiariesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BeneficiaryProvider>().loadBeneficiaries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BeneficiaryProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.beneficiaries.isEmpty) {
          return const LoadingWidget(message: 'Loading beneficiaries...');
        }

        if (provider.errorMessage != null && provider.beneficiaries.isEmpty) {
          return AppErrorWidget(
            message: provider.errorMessage!,
            onRetry: provider.loadBeneficiaries,
          );
        }

        if (provider.beneficiaries.isEmpty) {
          return const Center(child: Text('No beneficiaries found'));
        }

        return RefreshIndicator(
          onRefresh: provider.loadBeneficiaries,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.beneficiaries.length + 1, // +1 for summary
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              // ===== SUMMARY AT THE END =====
              if (index == provider.beneficiaries.length) {
                // TODO: ideally fetch these from API (get_fee_settings)
                const principalFee = 30.0;
                const memberFee = 15.0;
                const spouseFee = 23.0; // change if different

                final membersCount = provider.payableMembersCount;
                final spousesCount = provider.payableSpousesCount;

                final membersTotal = membersCount * memberFee;
                final spousesTotal = spousesCount * spouseFee;
                final totalMonthly = principalFee + membersTotal + spousesTotal;

                return _PolicySummary(
                  principalFee: principalFee,
                  memberFee: memberFee,
                  spouseFee: spouseFee,
                  payableMembersCount: membersCount,
                  payableSpousesCount: spousesCount,
                  totalMonthly: totalMonthly,
                );
              }

              final b = provider.beneficiaries[index];
              return _BeneficiaryCard(
                beneficiary: b,
                maturity: provider.maturityOf(b),
              );
            },
          ),
        );
      },
    );
  }
}

// ===================== CARD =====================
class _BeneficiaryCard extends StatelessWidget {
  final BeneficiaryModel beneficiary;
  final String maturity;

  const _BeneficiaryCard({required this.beneficiary, required this.maturity});

  Color _maturityColor(String value) {
    switch (value.toUpperCase()) {
      case 'MATURED':
        return Colors.green;
      case 'WAITING':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(
            beneficiary.fullName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),

          // Submission Date + Status
          _InfoItem(
            label: 'Submission Date (${beneficiary.status})',
            value: Helpers.formatDate(beneficiary.submissionDate),
          ),
          const SizedBox(height: 12),

          // Maturity Status only (+ Spouse)
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (maturity.isNotEmpty)
                _Chip(label: maturity, color: _maturityColor(maturity)),
              if (beneficiary.isSpouse)
                _Chip(label: 'Spouse', color: Colors.blue.shade700),
            ],
          ),
        ],
      ),
    );
  }
}

// ===================== SUMMARY =====================
class _PolicySummary extends StatelessWidget {
  final double principalFee;
  final double memberFee;
  final double spouseFee;
  final int payableMembersCount;
  final int payableSpousesCount;
  final double totalMonthly;

  const _PolicySummary({
    required this.principalFee,
    required this.memberFee,
    required this.spouseFee,
    required this.payableMembersCount,
    required this.payableSpousesCount,
    required this.totalMonthly,
  });

  @override
  Widget build(BuildContext context) {
    final membersTotal = payableMembersCount * memberFee;
    final spousesTotal = payableSpousesCount * spouseFee;

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monthly Policy Breakdown',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Principal Member: E${principalFee.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                Text(
                  'Payable Beneficiaries ($payableMembersCount × E${memberFee.toStringAsFixed(2)}): '
                  'E${membersTotal.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                Text(
                  'Payable Spouses ($payableSpousesCount × E${spouseFee.toStringAsFixed(2)}): '
                  'E${spousesTotal.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          Text(
            'E${totalMonthly.toStringAsFixed(2)} / month',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D6EFD),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== HELPERS =====================
class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 2),
        Text(
          value.isEmpty ? '—' : value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
