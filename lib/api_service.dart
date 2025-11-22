// main.dart
import 'dart:convert';
import 'dart:io';
import 'package:Afghan_Donors/Models/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'Models/signUp.dart';

// -----------------------------
// Local storage (stores phone)
// -----------------------------
class LocalStorage {
  static Future<String> _getPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<void> saveUserPhone(String phone) async {
    final path = await _getPath();
    final file = File('$path/user_phone.txt');
    await file.writeAsString(phone);
  }

  static Future<String?> getUserPhone() async {
    try {
      final path = await _getPath();
      final file = File('$path/user_phone.txt');
      if (await file.exists()) {
        final s = await file.readAsString();
        return s.trim().isEmpty ? null : s.trim();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> deleteUserPhone() async {
    final path = await _getPath();
    final file = File('$path/user_phone.txt');
    if (await file.exists()) await file.delete();
  }
}

// -----------------------------
// ApiService (your provided API)
// NOTE: I adjusted some endpoints and added getUserByPhone
// -----------------------------
class ApiService {
  // Use your exact base URL here
  final String baseUrl = "https://web-production-243ba.up.railway.app/api/mytable";

  Future<List<dynamic>> getData() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> addData(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(body),
    );

    // Useful logs while debugging
    debugPrint("POST status: ${response.statusCode}");
    debugPrint("Response body: ${response.body}");

    // Return true on success codes
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // Corrected: use baseUrl?phonenumber=... (not baseUrl/mytable?...)
  Future<bool> checkPhoneExists(String phone) async {
    final uri = Uri.parse('$baseUrl?phonenumber=$phone');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // adapt depending on your API structure:
      // if it returns {"count":..., "data":[...]} or {"data":[...]}
      if (data is Map && data.containsKey('count')) {
        return data['count'] > 0;
      } else if (data is Map && data.containsKey('data')) {
        return (data['data'] as List).isNotEmpty;
      }
    }
    return false;
  }

  // Fetch the first user object by phone (returns null if not found)
  Future<Map<String, dynamic>?> getUserByPhone(String phone) async {
    final uri = Uri.parse('$baseUrl?phonenumber=$phone');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey('data')) {
        final list = data['data'] as List;
        if (list.isNotEmpty) {
          // Return first matched user object
          final item = list.first;
          if (item is Map<String, dynamic>) return item;
          return Map<String, dynamic>.from(item);
        }
      }
    }
    return null;
  }

  Future<bool> updateData(int id, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteData(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    return response.statusCode == 200;
  }
}