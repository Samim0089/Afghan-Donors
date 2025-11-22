import 'package:Afghan_Donors/Models/homePage.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Color(0xFFE53935)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1,
                  height: MediaQuery.of(context).size.height / 2.2,
                  child: Icon(Icons.bloodtype_sharp, size: 230,color: Colors.white,)
                ),
              ),
              SizedBox(height: 80),
              Text('Afghan \n Donors', style: TextStyle(fontFamily: 'Bahij', fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,),
              SizedBox(height: 60),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
