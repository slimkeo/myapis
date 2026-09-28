import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/helpers.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../providers/claim_provider.dart';

class ClaimsScreen extends StatefulWidget {
  const ClaimsScreen({super.key});

  @override
  State<ClaimsScreen> createState() => _ClaimsScreenState();
}

class _ClaimsScreenState extends State<ClaimsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClaimProvider>().loadClaims();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClaimProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.claims.isEmpty) {
          return const LoadingWidget(message: 'Loading claims...');
        }
        if (provider.errorMessage != null && provider.claims.isEmpty) {
          return AppErrorWidget(
            message: provider.errorMessage!,
            onRetry: provider.loadClaims,
          );
        }
        if (provider.claims.isEmpty) {
          return const Center(child: Text('No claims found'));
        }

        return RefreshIndicator(
          onRefresh: provider.loadClaims,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.claims.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final claim = provider.claims[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            claim.beneficiary,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Helpers.statusColor(claim.status).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            claim.status,
                            style: TextStyle(
                              color: Helpers.statusColor(claim.status),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (claim.claimType != null && claim.claimType!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        claim.claimType!,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Text(
                      Helpers.formatCurrency(claim.amount),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Claimed: ${Helpers.formatDate(claim.claimDate)}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    if (claim.approvedDate != null && claim.approvedDate!.isNotEmpty)
                      Text(
                        'Approved: ${Helpers.formatDate(claim.approvedDate)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    if (claim.paymentDate != null && claim.paymentDate!.isNotEmpty)
                      Text(
                        'Paid: ${Helpers.formatDate(claim.paymentDate)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
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
