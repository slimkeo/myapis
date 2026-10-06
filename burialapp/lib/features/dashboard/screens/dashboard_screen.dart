import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/helpers.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final member = context.watch<AuthProvider>().member;

    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.dashboard == null) {
          return const LoadingWidget(message: 'Loading dashboard...');
        }

        if (provider.errorMessage != null && provider.dashboard == null) {
          return AppErrorWidget(
            message: provider.errorMessage!,
            onRetry: provider.loadDashboard,
          );
        }

        final data = provider.dashboard;

        // Same formula as BeneficiariesScreen:
        // Total = E30 + (members × E15) + (spouses × E23)
        const principalFee = DashboardProvider.principalFee;
        const memberFee = DashboardProvider.memberFee;
        const spouseFee = DashboardProvider.spouseFee;
        final membersTotal = (data?.payableMembers ?? 0) * memberFee;
        final spousesTotal = (data?.payableSpouses ?? 0) * spouseFee;
        final totalMonthly = principalFee + membersTotal + spousesTotal;

        return RefreshIndicator(
          onRefresh: provider.loadDashboard,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Hello, ${member?.fullName ?? 'Member'} (No: ${member?.id ?? 'N/A'})',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Nominee: ${context.watch<AuthProvider>().nominee ?? 'N/A'}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 20),
              if (data != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        label: 'Claims',
                        value: data.claims.toString(),
                        icon: Icons.assignment,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatTile(
                        label: 'Beneficiaries',
                        value: data.beneficiaries.toString(),
                        icon: Icons.people,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  title: 'Monthly contribution',
                  value: Helpers.formatCurrency(totalMonthly),
                  icon: Icons.payments_outlined,
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  title: 'Coverage amount',
                  value: Helpers.formatCurrency(data.coverageAmount),
                  icon: Icons.shield_outlined,
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  title: 'Policy status',
                  value: data.policyStatus,
                  icon: Icons.verified_outlined,
                  valueColor: Helpers.statusColor(data.policyStatus),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
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
          Icon(icon, color: Colors.blue[700], size: 22),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[700]),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
