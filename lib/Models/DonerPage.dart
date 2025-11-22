import 'package:Afghan_Donors/Models/DonorInfo.dart';
import 'package:Afghan_Donors/api_service.dart';
import 'package:flutter/material.dart';

class DonorPage extends StatefulWidget {
  const DonorPage({super.key});

  @override
  State<DonorPage> createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> {
  late Future<List<dynamic>> _donorsFuture;
  List<dynamic> _allDonors = [];
  List<dynamic> _filteredDonors = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _donorsFuture = ApiService().getData();
    _donorsFuture.then((value) {
      setState(() {
        _allDonors = value;
        _filteredDonors = value; // initially show all
      });
    });

    _searchController.addListener(() {
      _filterDonors();
    });
  }

  void _filterDonors() {
    final query = _searchController.text.trim().toUpperCase();
    if (query.isEmpty) {
      setState(() {
        _filteredDonors = _allDonors;
      });
    } else {
      setState(() {
        _filteredDonors = _allDonors
            .where((donor) =>
        (donor['bloodgroup'] ?? "").toString().toUpperCase() == query)
            .toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE53935),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: const Icon(Icons.search_outlined),
                  hintText: 'Blood Group ...',
                  hintStyle: const TextStyle(fontFamily: 'bahij'),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Container(
                color: const Color(0xFFE53935),
                child: _filteredDonors.isEmpty
                    ? const Center(
                  child: Text(
                    "No donors found",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
                    : ListView.builder(
                  itemCount: _filteredDonors.length,
                  itemBuilder: (context, index) {
                    var donor = _filteredDonors[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DonorInfo(
                                donorName: donor['name'] ?? "NA",
                                donorPhonrNumber:
                                donor['phonenumber'] ?? "NA",
                                donorBloodGroup:
                                donor['bloodgroup'] ?? "NA",
                                donorLocation:
                                donor['location'] ?? "NA",
                              )));
                        },
                        child: Material(
                          elevation: 0.2,
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 70.0,
                            child: ListTile(
                              trailing: Column(
                                children: [
                                  Text(
                                    donor['bloodgroup'] ?? "NA",
                                    style: const TextStyle(
                                        fontFamily: 'bahij',
                                        color: Colors.red,
                                        fontSize: 14.0),
                                  ),
                                  const Icon(
                                    Icons.bloodtype_sharp,
                                    size: 28,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              title: Text(donor['name'] ?? "NA",
                                  textAlign: TextAlign.right),
                              subtitle: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Text(
                                    donor['location'] ?? "NA",
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                        fontFamily: 'bahij',
                                        fontSize: 16),
                                  ),
                                  const Icon(Icons.location_pin),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
