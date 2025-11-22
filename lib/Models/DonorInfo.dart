import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DonorInfo extends StatefulWidget {
  var donorName;
  var donorBloodGroup;
  var donorLocation;
  var donorPhonrNumber;
  DonorInfo({
    required this.donorName,
    required this.donorBloodGroup,
    required this.donorLocation,
    required this.donorPhonrNumber,
  });

  @override
  State<DonorInfo> createState() => _DonorInfoState();
}

class _DonorInfoState extends State<DonorInfo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFE53935),
        appBar: AppBar(
          backgroundColor: Color(0xFFE53935),
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height / 1.4,
            decoration: BoxDecoration(
              color: Color(0xFFFFCDD8),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFFCFFDD8),
                    child: Center(
                      child: Text(widget.donorName[0], style: TextStyle(fontSize: 40.0),),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: ListView.builder(
                      itemCount: info.length,
                      itemBuilder: (context, index) {
                        List<dynamic> donorInfo = [
                          widget.donorName,
                          widget.donorPhonrNumber,
                          widget.donorBloodGroup,
                          widget.donorLocation,
                        ];
                        return ListTile(
                          title: Text(
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            "${info[index]} : ",
                            style: TextStyle(fontFamily: 'bahij', fontSize: 20.0),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text(
                                donorInfo[index],
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.right,
                                style: TextStyle(fontFamily: 'bahij', fontSize: 18.0),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20.0,
                    right: 20.0,
                    left: 20.0,
                  ),
                  child: FilledButton(
                    onPressed: () async {
                      try {
                        final Uri callUri = Uri(scheme: 'tel', path: widget.donorPhonrNumber);
                        await launchUrl(
                          callUri,
                          mode: LaunchMode.externalApplication,
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Dialer cannot be opened: $e")),
                        );
                      }
                    },
                    child: const Text('اړیکه نیول'),
                  ),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<String> info = ["نوم", "موبایل شمیره", "وینې ګروپ", "موقعیت"];
