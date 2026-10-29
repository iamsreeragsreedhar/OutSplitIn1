import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';

class CategoryItemModel extends Equatable {
  final String id;
  final String name;
  final int iconCodePoint;
  final String? iconFontFamily;
  final int colorValue;
  final TransactionType type;
  final bool isCustom;

  const CategoryItemModel({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    this.iconFontFamily = 'MaterialIcons',
    required this.colorValue,
    required this.type,
    this.isCustom = false,
  });

  static final Map<int, IconData> _iconMap = {
    Icons.restaurant_rounded.codePoint: Icons.restaurant_rounded,
    Icons.shopping_bag_outlined.codePoint: Icons.shopping_bag_outlined,
    Icons.directions_bus_rounded.codePoint: Icons.directions_bus_rounded,
    Icons.receipt_long_rounded.codePoint: Icons.receipt_long_rounded,
    Icons.sports_esports_rounded.codePoint: Icons.sports_esports_rounded,
    Icons.favorite_rounded.codePoint: Icons.favorite_rounded,
    Icons.local_grocery_store_rounded.codePoint: Icons.local_grocery_store_rounded,
    Icons.flight_takeoff_rounded.codePoint: Icons.flight_takeoff_rounded,
    Icons.more_horiz_rounded.codePoint: Icons.more_horiz_rounded,
    Icons.account_balance_wallet_rounded.codePoint: Icons.account_balance_wallet_rounded,
    Icons.laptop_mac_rounded.codePoint: Icons.laptop_mac_rounded,
    Icons.trending_up_rounded.codePoint: Icons.trending_up_rounded,
    Icons.swap_horiz_rounded.codePoint: Icons.swap_horiz_rounded,
    Icons.savings_rounded.codePoint: Icons.savings_rounded,
    Icons.local_cafe_rounded.codePoint: Icons.local_cafe_rounded,
    Icons.movie_rounded.codePoint: Icons.movie_rounded,
    Icons.pets_rounded.codePoint: Icons.pets_rounded,
    Icons.fitness_center_rounded.codePoint: Icons.fitness_center_rounded,
    Icons.school_rounded.codePoint: Icons.school_rounded,
    Icons.work_rounded.codePoint: Icons.work_rounded,
    Icons.card_giftcard_rounded.codePoint: Icons.card_giftcard_rounded,
    Icons.home_rounded.codePoint: Icons.home_rounded,
    Icons.fastfood_rounded.codePoint: Icons.fastfood_rounded,
    Icons.local_dining_rounded.codePoint: Icons.local_dining_rounded,
    Icons.medical_services_rounded.codePoint: Icons.medical_services_rounded,
    Icons.directions_car_rounded.codePoint: Icons.directions_car_rounded,
    Icons.electric_bolt_rounded.codePoint: Icons.electric_bolt_rounded,
    Icons.phone_android_rounded.codePoint: Icons.phone_android_rounded,
    Icons.wifi_rounded.codePoint: Icons.wifi_rounded,
    Icons.shopping_cart_rounded.codePoint: Icons.shopping_cart_rounded,
    Icons.credit_card_rounded.codePoint: Icons.credit_card_rounded,
    Icons.paid_rounded.codePoint: Icons.paid_rounded,
    Icons.attach_money_rounded.codePoint: Icons.attach_money_rounded,
    Icons.currency_exchange_rounded.codePoint: Icons.currency_exchange_rounded,
    Icons.category_rounded.codePoint: Icons.category_rounded,
  };

  IconData get icon => _iconMap[iconCodePoint] ?? Icons.category_rounded;

  Color get color => Color(colorValue);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': iconCodePoint,
      'iconFontFamily': iconFontFamily,
      'colorValue': colorValue,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'isCustom': isCustom,
    };
  }

  factory CategoryItemModel.fromMap(Map<String, dynamic> map) {
    return CategoryItemModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      iconCodePoint: map['iconCodePoint'] ?? Icons.category_rounded.codePoint,
      iconFontFamily: map['iconFontFamily'] ?? 'MaterialIcons',
      colorValue: map['colorValue'] ?? 0xFF0BA874,
      type: map['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      isCustom: map['isCustom'] ?? false,
    );
  }

  static List<CategoryItemModel> defaultCategories = [
    // Expenses
    CategoryItemModel(
      id: 'cat_food',
      name: 'Food & Dining',
      iconCodePoint: Icons.restaurant_rounded.codePoint,
      colorValue: 0xFFF47A45,
      type: TransactionType.expense,
    ),
    CategoryItemModel(
      id: 'cat_shopping',
      name: 'Shopping',
      iconCodePoint: Icons.shopping_bag_outlined.codePoint,
      colorValue: 0xFF967ADC,
      type: TransactionType.expense,
    ),
    CategoryItemModel(
      id: 'cat_transport',
      name: 'Transport',
      iconCodePoint: Icons.directions_bus_rounded.codePoint,
      colorValue: 0xFF4A89DC,
      type: TransactionType.expense,
    ),
    CategoryItemModel(
      id: 'cat_bills',
      name: 'Bills & Utilities',
      iconCodePoint: Icons.receipt_long_rounded.codePoint,
      colorValue: 0xFFE9573F,
      type: TransactionType.expense,
    ),
    CategoryItemModel(
      id: 'cat_entertainment',
      name: 'Entertainment',
      iconCodePoint: Icons.sports_esports_rounded.codePoint,
      colorValue: 0xFFD770AD,
      type: TransactionType.expense,
    ),
    CategoryItemModel(
      id: 'cat_health',
      name: 'Health & Fitness',
      iconCodePoint: Icons.favorite_rounded.codePoint,
      colorValue: 0xFFDA4453,
      type: TransactionType.expense,
    ),
    CategoryItemModel(
      id: 'cat_grocery',
      name: 'Grocery',
      iconCodePoint: Icons.local_grocery_store_rounded.codePoint,
      colorValue: 0xFF8CC152,
      type: TransactionType.expense,
    ),
    CategoryItemModel(
      id: 'cat_travel',
      name: 'Travel & Trips',
      iconCodePoint: Icons.flight_takeoff_rounded.codePoint,
      colorValue: 0xFF3BAFDA,
      type: TransactionType.expense,
    ),
    CategoryItemModel(
      id: 'cat_other_exp',
      name: 'Other Expense',
      iconCodePoint: Icons.more_horiz_rounded.codePoint,
      colorValue: 0xFF656D78,
      type: TransactionType.expense,
    ),

    // Incomes
    CategoryItemModel(
      id: 'cat_salary',
      name: 'Salary',
      iconCodePoint: Icons.account_balance_wallet_rounded.codePoint,
      colorValue: 0xFF0BA874,
      type: TransactionType.income,
    ),
    CategoryItemModel(
      id: 'cat_freelance',
      name: 'Freelance & Side Gig',
      iconCodePoint: Icons.laptop_mac_rounded.codePoint,
      colorValue: 0xFF37BC9B,
      type: TransactionType.income,
    ),
    CategoryItemModel(
      id: 'cat_investments',
      name: 'Investments & Returns',
      iconCodePoint: Icons.trending_up_rounded.codePoint,
      colorValue: 0xFF4A89DC,
      type: TransactionType.income,
    ),
    CategoryItemModel(
      id: 'cat_transfer',
      name: 'Transfers & Refunds',
      iconCodePoint: Icons.swap_horiz_rounded.codePoint,
      colorValue: 0xFFF6BB42,
      type: TransactionType.income,
    ),
    CategoryItemModel(
      id: 'cat_other_inc',
      name: 'Other Income',
      iconCodePoint: Icons.savings_rounded.codePoint,
      colorValue: 0xFF087F59,
      type: TransactionType.income,
    ),
  ];

  @override
  List<Object?> get props => [
        id,
        name,
        iconCodePoint,
        iconFontFamily,
        colorValue,
        type,
        isCustom,
      ];
}
