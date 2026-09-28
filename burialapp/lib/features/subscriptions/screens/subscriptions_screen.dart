import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/helpers.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../providers/subscription_provider.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionProvider>().loadStatements();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.statements.isEmpty) {
          return const LoadingWidget(message: 'Loading statements...');
        }
        if (provider.errorMessage != null && provider.statements.isEmpty) {
          return AppErrorWidget(
            message: provider.errorMessage!,
            onRetry: provider.loadStatements,
          );
        }
        if (provider.statements.isEmpty) {
          return const Center(child: Text('No statements found'));
        }

        return RefreshIndicator(
          onRefresh: provider.loadStatements,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.statements.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final s = provider.statements[index];
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
                    Icon(
                      s.type.toLowerCase() == 'contribution'
                          ? Icons.arrow_upward
                          : Icons.receipt_long,
                      color: Colors.blue[700],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.description.isNotEmpty ? s.description : s.type,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Helpers.formatDate(s.date),
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                          if (s.source != null && s.source!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              s.source!,
                              style: TextStyle(color: Colors.grey[500], fontSize: 12),
                            ),
                          ],
                          const SizedBox(height: 6),
                          Text(
                            s.status,
                            style: TextStyle(
                              color: Helpers.statusColor(s.status),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      Helpers.formatCurrency(s.amount),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
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
