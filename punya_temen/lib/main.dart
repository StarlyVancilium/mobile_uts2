import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/waiting_approval_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/order_list_screen.dart';
import 'screens/order_detail_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Toko Telur Gulung',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/waiting-approval': (context) => WaitingApprovalScreen(),
        '/products': (context) => ProductListScreen(),
        '/orders': (context) => OrderListScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/product-detail') {
          final productId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: productId),
          );
        }

        if (settings.name == '/order-detail') {
          final orderId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (_) => OrderDetailScreen(orderId: orderId),
          );
        }

        return null;
      },
    );
  }
}
