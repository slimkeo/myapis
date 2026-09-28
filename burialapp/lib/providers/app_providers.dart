import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/dashboard/providers/dashboard_provider.dart';
import '../features/claims/providers/claim_provider.dart';
import '../features/beneficiaries/providers/beneficiary_provider.dart';
import '../features/subscriptions/providers/subscription_provider.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => DashboardProvider()),
    ChangeNotifierProvider(create: (_) => ClaimProvider()),
    ChangeNotifierProvider(create: (_) => BeneficiaryProvider()),
    ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
  ];
}
