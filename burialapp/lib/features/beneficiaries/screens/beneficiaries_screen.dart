import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/helpers.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../providers/beneficiary_provider.dart';

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
            itemCount: provider.beneficiaries.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final b = provider.beneficiaries[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue[50],
                      child: Text(
                        b.fullName.isNotEmpty ? b.fullName[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            b.fullName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${b.gender} · DOB ${Helpers.formatDate(b.dob)}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              _Chip(
                                label: b.status.isNotEmpty ? b.status : 'Unknown',
                                color: Helpers.statusColor(b.status),
                              ),
                              if (b.isSpouse)
                                _Chip(
                                  label: 'Spouse',
                                  color: Colors.blue[700]!,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
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
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
