import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com/products';
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'products.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY,
            title TEXT,
            price REAL,
            description TEXT,
            category TEXT,
            image TEXT,
            rating REAL
          )
        ''');
      },
    );
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        final products = data.map((item) => Product.fromJson(item)).toList();

        final db = await database;
        await db.transaction((txn) async {
          await txn.delete('products');
          for (var item in data) {
            await txn.insert('products', item);
          }
        });

        return products.cast<Product>();
      } else {
        throw Exception('Failed to load');
      }
    } catch (_) {
      final db = await database;
      final cached = await db.query('products');
      if (cached.isNotEmpty) {
        return cached.map((e) => Product.fromJson(e)).toList();
      }
      rethrow;
    }
  }
}