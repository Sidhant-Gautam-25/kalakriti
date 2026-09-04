import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  static String? token;
  static Map<String, dynamic>? currentUser;

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  /// Register a new user
  static Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/auth/register');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'password': password,
        'role': role,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201 && data['success'] == true) {
      token = data['token'];
      currentUser = data['user'];
      return data;
    } else {
      throw Exception(data['message'] ?? 'Failed to register.');
    }
  }

  /// Login an existing user
  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/auth/login');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        'phone': phone,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      token = data['token'];
      currentUser = data['user'];
      return data;
    } else {
      throw Exception(data['message'] ?? 'Failed to log in.');
    }
  }

  /// Send OTP code
  static Future<Map<String, dynamic>> sendOtp({
    required String phone,
    String? name,
    String? role,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/auth/send-otp');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        'phone': phone,
        'name': ?name,
        'role': ?role,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Failed to send OTP.');
    }
  }

  /// Verify OTP code
  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/auth/verify-otp');
    final response = await http.post(
      url,
      body: jsonEncode({
        'phone': phone,
        'otp': otp,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      token = data['token'];
      currentUser = data['user'];
      return data;
    } else {
      throw Exception(data['message'] ?? 'Failed to verify OTP.');
    }
  }

  /// Smart Cataloging using image upload
  static Future<Map<String, dynamic>> uploadSmartCatalog(File imageFile) async {
    final url = Uri.parse('${AppConstants.baseUrl}/catalog/smart-catalog');
    
    final request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        if (token != null) 'Authorization': 'Bearer $token',
      })
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Failed to run AI smart cataloging.');
    }
  }

  /// Confirm & Publish Product with Fair Price Protection Shield
  static Future<Map<String, dynamic>> confirmCatalog({
    required String catalogDraftToken,
    required double sellingPrice,
    required bool underpriceWarningDismissed,
    required List<String> imageUrls,
    Map<String, dynamic>? giTag,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/catalog/confirm');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        'catalogDraftToken': catalogDraftToken,
        'sellingPrice': sellingPrice,
        'underpriceWarningDismissed': underpriceWarningDismissed,
        'images': imageUrls,
        'giTag': ?giTag,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201 && data['success'] == true) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Failed to confirm product listing.');
    }
  }

  /// Fetch products uploaded by the logged-in artisan
  static Future<List<dynamic>> getMyProducts() async {
    final url = Uri.parse('${AppConstants.baseUrl}/products/artisan/my-products');
    final response = await http.get(url, headers: _headers);

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return data['products'] ?? [];
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch your products.');
    }
  }

  /// Fetch all active marketplace products
  static Future<List<dynamic>> getAllProducts({
    String? category,
    String? search,
    double? minPrice,
    double? maxPrice,
  }) async {
    final queryParams = {
      'category': ?category,
      'search': ?search,
      if (minPrice != null) 'minPrice': minPrice.toString(),
      if (maxPrice != null) 'maxPrice': maxPrice.toString(),
    };

    final uri = Uri.parse('${AppConstants.baseUrl}/products').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: _headers);

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return data['products'] ?? [];
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch marketplace products.');
    }
  }
}
