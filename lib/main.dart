import 'package:Afghan_Donors/api_service.dart';
import 'package:flutter/material.dart';
import 'Models/welcomePage.dart';

void main() async {
  runApp(BloodDonate());
  WidgetsFlutterBinding.ensureInitialized();
  var data = ApiService().getData();
  print(data);
}

class BloodDonate extends StatelessWidget {
  const BloodDonate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}




