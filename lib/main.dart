import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mallu_smart/providers/cart_provider.dart';
import 'package:mallu_smart/providers/favorites_provider.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:mallu_smart/providers/connectivity_provider.dart';
import 'package:mallu_smart/widgets/connectivity_dialog.dart';
import 'package:mallu_smart/screens/onboarding_screen.dart';
import 'package:mallu_smart/widgets/main_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mallu_smart/providers/theme_provider.dart';
import 'package:mallu_smart/providers/language_provider.dart';
import 'package:mallu_smart/providers/product_provider.dart';
import 'package:mallu_smart/providers/order_provider.dart';
import 'package:mallu_smart/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MalluSmartApp(),
    ),
  );
}


class MalluSmartApp extends StatelessWidget {
  const MalluSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mallu Smart',
      debugShowCheckedModeBanner: false,
      theme: CuratorDesign.getTheme(false),
      darkTheme: CuratorDesign.getTheme(true),
      themeMode: ThemeMode.light,
      home: ConnectivityGate(child: SplashScreen()),
    );
  }
}



class ConnectivityGate extends StatefulWidget {
  final Widget child;
  const ConnectivityGate({super.key, required this.child});

  @override
  State<ConnectivityGate> createState() => _ConnectivityGateState();
}

class _ConnectivityGateState extends State<ConnectivityGate> {
  late ConnectivityProvider _connectivityProvider;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
      _connectivityProvider.addListener(_handleConnectivityChange);
      
      if (!_connectivityProvider.isConnected) {
        showConnectivityDialog(context);
      }
    });
  }

  @override
  void dispose() {
    _connectivityProvider.removeListener(_handleConnectivityChange);
    super.dispose();
  }

  void _handleConnectivityChange() {
    if (!_connectivityProvider.isConnected) {
      showConnectivityDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
