import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  static const String notesUrl = '$baseUrl/notes';
  static const String authUrl = '$baseUrl/auth';


  // AUTH SECTION


  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$authUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data.containsKey('token')) {
        return {'token': data['token'], 'msg': 'Login successful'};
      } else {
        return {'error': data['error'] ?? 'Invalid credentials'};
      }
    } catch (e) {
      print('Login error: $e');
      return {'error': 'Unable to connect to server'};
    }
  }

  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$authUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'msg': data['msg'] ?? 'Registered successfully',
          'token': data['token'] ?? ''
        };
      } else {
        return {'error': data['error'] ?? 'Registration failed'};
      }
    } catch (e) {
      print('Register error: $e');
      return {'error': 'Unable to connect to server'};
    }
  }

  // 🔹 Save / Load / Clear token using SharedPreferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }


  // NOTES SECTION


  static Future<bool> createNote(Note note) async {
    try {
      final token = await getToken();
      final response = await http.post(
        Uri.parse('$notesUrl/create'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(note.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error creating note: $e');
      return false;
    }
  }

  static Future<List<Note>> getNotes() async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('$notesUrl/all'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((n) => Note.fromJson(n)).toList();
      }
    } catch (e) {
      print('Error getting notes: $e');
    }
    return [];
  }

  static Future<bool> updateNote(String id, Note note) async {
    try {
      final token = await getToken();
      final response = await http.put(
        Uri.parse('$notesUrl/update/$id'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(note.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating note: $e');
      return false;
    }
  }

  static Future<bool> deleteNote(String id) async {
    try {
      final token = await getToken();
      final response = await http.delete(
        Uri.parse('$notesUrl/delete/$id'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting note: $e');
      return false;
    }
  }

  static Future<bool> toggleListItem(String noteId, int itemIndex) async {
    try {
      final token = await getToken();
      final response = await http.put(
        Uri.parse('$notesUrl/toggle-item/$noteId/$itemIndex'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error toggling list item: $e');
      return false;
    }
  }
}
