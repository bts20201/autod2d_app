import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/vehicle.dart';
import '../models/product.dart';

class ApiService {
  static const String wpBase = 'https://yourdomain.com/wp-json/wp/v2';
  static const String wcBase = 'https://yourdomain.com/wp-json/wc/v3';

  static Future<List<Vehicle>> fetchVehicles() async {
    final response = await http.get(Uri.parse('$wpBase/listings'));

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((item) => Vehicle.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  static Future<List<Product>> fetchProducts() async {
    final key = dotenv.env['WC_CONSUMER_KEY'];
    final secret = dotenv.env['WC_CONSUMER_SECRET'];

    final url = '$wcBase/products?consumer_key=$key&consumer_secret=$secret';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      print('Failed to load produ
