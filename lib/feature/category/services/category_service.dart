import 'dart:convert';
import 'package:out_split_in/feature/category/model/category_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  static const String _categoriesKey = 'app_custom_categories_v1';

  Future<List<CategoryItemModel>> getAllCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customJson = prefs.getString(_categoriesKey);

      final customList = <CategoryItemModel>[];
      if (customJson != null && customJson.isNotEmpty) {
        final decoded = jsonDecode(customJson) as List<dynamic>;
        for (final item in decoded) {
          customList.add(CategoryItemModel.fromMap(item as Map<String, dynamic>));
        }
      }

      return [...CategoryItemModel.defaultCategories, ...customList];
    } catch (_) {
      return CategoryItemModel.defaultCategories;
    }
  }

  Future<void> saveCustomCategory(CategoryItemModel category) async {
    final prefs = await SharedPreferences.getInstance();
    final customJson = prefs.getString(_categoriesKey);

    final customList = <CategoryItemModel>[];
    if (customJson != null && customJson.isNotEmpty) {
      final decoded = jsonDecode(customJson) as List<dynamic>;
      for (final item in decoded) {
        customList.add(CategoryItemModel.fromMap(item as Map<String, dynamic>));
      }
    }

    customList.removeWhere((c) => c.id == category.id);
    customList.add(category);

    final encoded = jsonEncode(customList.map((c) => c.toMap()).toList());
    await prefs.setString(_categoriesKey, encoded);
  }

  Future<void> deleteCustomCategory(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final customJson = prefs.getString(_categoriesKey);

    if (customJson != null && customJson.isNotEmpty) {
      final decoded = jsonDecode(customJson) as List<dynamic>;
      final customList = decoded
          .map((item) => CategoryItemModel.fromMap(item as Map<String, dynamic>))
          .where((c) => c.id != id)
          .map((c) => c.toMap())
          .toList();

      await prefs.setString(_categoriesKey, jsonEncode(customList));
    }
  }
}
