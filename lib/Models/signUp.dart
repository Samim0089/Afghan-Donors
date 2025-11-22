import 'package:Afghan_Donors/Models/homePage.dart';
import 'package:Afghan_Donors/Models/profile.dart';
import 'package:Afghan_Donors/hive_flutter.dart' hide LocalStorage;
import 'package:flutter/material.dart';
import 'package:Afghan_Donors/api_service.dart' hide ProfilePage;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final ApiService api = ApiService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _checkExistingUser();
  }

  Future<void> _checkExistingUser() async {
    final phone = await LocalStorage.getUserPhone();
    if (phone != null) {
      setState(() => loading = true);
      final user = await api.getUserByPhone(phone);
      setState(() => loading = false);
      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      } else {
        await LocalStorage.deleteUserPhone();
      }
    }
  }

  void _submitData() async {
    final name = nameController.text.trim();
    final bloodGroup = bloodGroupController.text.trim().toUpperCase();
    final location = locationController.text.trim();
    final phone = phoneNumberController.text.trim();

    const validBloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text("مهرباني وكړۍ نوم ولیکۍ", style: TextStyle(color: Colors.black, fontSize: 16.0),textDirection: TextDirection.rtl,))),
      );
      return;
    }

    if (!validBloodGroups.contains(bloodGroup)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
            content: Center(child: Text("مهربانې وکړۍ د ویني صحبح ګروپ ولیکۍ", style: TextStyle(color: Colors.black, fontSize: 16.0),))),
      );
      return;
    }

    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text("مهربانې وکړۍ موقعیت ولیکۍ", style: TextStyle(color: Colors.black, fontSize: 16.0),))),
      );
      return;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text("۱۰ عدده موبایل شمیره ولیکۍ", style: TextStyle(color: Colors.black, fontSize: 16.0),textDirection: TextDirection.rtl,))),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final exists = await api.checkPhoneExists(phone);
      if (exists) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("دا شمیره مخکې ثبت شوې ده")),
        );
        return;
      }

      // Prepare data
      final body = {
        "name": name,
        "bloodgroup": bloodGroup,
        "location": location,
        "phonenumber": phone,
      };

      final success = await api.addData(body);

      if (!mounted) return;

      if (success) {
        await LocalStorage.saveUserPhone(phone);
        final user = await api.getUserByPhone(phone);

        // Show success message in the center
        setState(() {
          loading = false;
        });
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.done, size: 60.0, color: Colors.white),
                ),
                const SizedBox(height: 10.0),
                const Center(
                  child: Text(
                    'معلومات ثبت شول',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      } else {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to submit data")),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }



  @override
  void dispose() {
    nameController.dispose();
    bloodGroupController.dispose();
    locationController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFE53935),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 1.4,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFCDD8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'ځان ثبت\nاو وینه ورکړئ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'bahij', fontSize: 20.0),
                      ),
                      const SizedBox(height: 30),
                      // Name
                      TextField(
                        controller: nameController,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(fontFamily: 'Bahij'),
                        decoration: const InputDecoration(
                          hintText: 'نوم',
                          hintTextDirection: TextDirection.rtl,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Blood Group
                      TextField(
                        controller: bloodGroupController,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(fontFamily: 'Bahij'),
                        decoration: const InputDecoration(
                          hintText: '( A+, A-) وینې ګروب',
                          hintTextDirection: TextDirection.ltr,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Location
                      TextField(
                        controller: locationController,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(fontFamily: 'Bahij'),
                        decoration: const InputDecoration(
                          hintText: 'موقعیت (ولایت، ولسوالی (ناحیه))',
                          hintTextDirection: TextDirection.rtl,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Phone Number
                      TextField(
                        controller: phoneNumberController,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(fontFamily: 'Bahij'),
                        decoration: const InputDecoration(
                          hintText: 'موبایل شمیره',
                          hintTextDirection: TextDirection.rtl,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: _submitData,
                        child: const Text(
                          'ثبت کړئ',
                          style: TextStyle(fontFamily: 'Bahij'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
