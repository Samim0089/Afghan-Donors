import 'package:Afghan_Donors/Models/homePage.dart';
import 'package:Afghan_Donors/Models/signUp.dart';
import 'package:Afghan_Donors/api_service.dart';
import 'package:Afghan_Donors/profile.dart';
import 'package:flutter/material.dart';
import 'package:Afghan_Donors/Models/profile.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> user;
  const ProfilePage({super.key, required this.user});

  void _logout(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تصدیق", textAlign: TextAlign.center),
        content: const Text("ایا تاسو ډاډه یاست چې حساب ړنګ کړۍ؟", textAlign: TextAlign.right,),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("نه"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("هو"),
          ),
        ],
      ),
    );

    if (confirm) {
      await LocalStorage.deleteUserPhone();
      await ApiService().deleteData(user['id']);
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Center(child: Text("ستاسو حساب ډیلیټ شو")),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE53935),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("ستاسې حساب"),
        backgroundColor: const Color(0xFFE53935),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.2,
          height: MediaQuery.of(context).size.height / 1.4,
          decoration: BoxDecoration(
            color: const Color(0xFFFFCDD8),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              SizedBox(height: 40.0),
              CircleAvatar(
                backgroundColor: Colors.redAccent,
                radius: 60.0,
                  child: Text("${user['name'][0]}", style: TextStyle(fontSize: 40.0, color: Colors.white),),
              ),
              const SizedBox(height: 70),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    children: [
                      Text(
                        'نوم : ${user['name']}',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Divider(color: Colors.white),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("${user['bloodgroup']}", textDirection: TextDirection.ltr, textAlign: TextAlign.left,),
                          SizedBox(width: 5.0),
                          Text(
                            "وینې ګروپ :",
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                      Divider(color: Colors.white),
                      Text(
                        "موقعیت : ${user['location']}",
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Divider(color: Colors.white),
                      Text(
                        "موبایل شمیره : ${user['phonenumber'] ?? ''}",
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 80.0),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0),
                        child: InkWell(
                          onTap: () {
                            _logout(context);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Center(
                              child: Text('حساب ړنګول', style: TextStyle(fontSize: 15.0, color: Colors.white),),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'Bahij',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              value,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontFamily: 'Bahij', fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
