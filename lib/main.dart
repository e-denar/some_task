import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:some_task/resources/routes.dart';
import 'package:some_task/ui/dashboard_page.dart';
import 'package:some_task/ui/login_page.dart';
import 'package:some_task/ui/register_details_page.dart';
import 'package:some_task/ui/registration_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        Routes.HOME: (context) => LoginPage(),
        Routes.REGISTER: (context) => RegistrationPage(),
        Routes.DASHBOARD: (context) => DashboardPage(),
      },
      onGenerateRoute: (settings) {
        WidgetBuilder _builder;
        Map<String, dynamic> args = settings.arguments;
        switch (settings.name) {
          case Routes.REGISTER_DETAILS:
            _builder = (context) => RegistrationDetailsPage(
                  user: args['user'],
                );
            break;
        }
        return MaterialPageRoute(builder: _builder);
      },
    );
  }
}
