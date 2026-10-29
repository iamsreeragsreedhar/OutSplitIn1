import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:out_split_in/core/shared_widgets/snackbar.dart';
import 'package:out_split_in/feature/category/model/category_item_model.dart';
import 'package:out_split_in/feature/category/view_model/category/category_bloc.dart';
import 'package:out_split_in/feature/category/view_model/category/category_event.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';

class AddCategoryModal extends StatefulWidget {
  final TransactionType initialType;

  const AddCategoryModal({
    super.key,
    required this.initialType,
  });

  static void show(BuildContext context, {required TransactionType type}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CategoryBloc>(),
        child: AddCategoryModal(initialType: type),
      ),
    );
  }

  @override
  State<AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late TransactionType _selectedType;
  late int _selectedColor;
  late int _selectedIcon;

  static const List<int> _availableColors = [
    0xFF0BA874, // Emerald
    0xFFF47A45, // Orange
    0xFF4A89DC, // Blue
    0xFF967ADC, // Purple
    0xFFE9573F, // Red
    0xFF3BAFDA, // Teal
    0xFFF6BB42, // Yellow
    0xFFD770AD, // Pink
    0xFF8CC152, // Lime
    0xFF434A54, // Slate
  ];

  static final List<IconData> _availableIcons = [
    Icons.restaurant_rounded,
    Icons.shopping_bag_outlined,
    Icons.directions_bus_rounded,
    Icons.receipt_long_rounded,
    Icons.sports_esports_rounded,
    Icons.favorite_rounded,
    Icons.local_grocery_store_rounded,
    Icons.flight_takeoff_rounded,
    Icons.local_cafe_rounded,
    Icons.movie_rounded,
    Icons.pets_rounded,
    Icons.fitness_center_rounded,
    Icons.school_rounded,
    Icons.work_rounded,
    Icons.laptop_mac_rounded,
    Icons.account_balance_wallet_rounded,
    Icons.trending_up_rounded,
    Icons.savings_rounded,
    Icons.card_giftcard_rounded,
    Icons.home_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _selectedColor = _availableColors[0];
    _selectedIcon = _availableIcons[0].codePoint;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final trimmedName = _nameController.text.trim();
    final existingCategories =
        context.read<CategoryBloc>().state.allCategories;
    final isDuplicate = existingCategories.any(
      (c) =>
          c.name.toLowerCase() == trimmedName.toLowerCase() &&
          c.type == _selectedType,
    );

    if (isDuplicate) {
      AppSnackbar.error(
        context,
        'Category "$trimmedName" already exists for this type',
      );
      return;
    }

    final newCategory = CategoryItemModel(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: trimmedName,
      iconCodePoint: _selectedIcon,
      colorValue: _selectedColor,
      type: _selectedType,
      isCustom: true,
    );

    context.read<CategoryBloc>().add(AddCustomCategoryEvent(newCategory));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(bottom: bottomInset),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2824) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Add Custom Category',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF18231F),
                  ),
                ),
                const SizedBox(height: 16),

                // Type Toggle
                Row(
                  children: [
                    _typeChip('Expense', TransactionType.expense),
                    const SizedBox(width: 10),
                    _typeChip('Income', TransactionType.income),
                  ],
                ),
                const SizedBox(height: 16),

                // Category Name Field
                TextFormField(
                  controller: _nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 30,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) {
                      return 'Please enter category name';
                    }
                    if (trimmed.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    if (trimmed.length > 30) {
                      return 'Name cannot exceed 30 characters';
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF18231F),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    hintText: 'e.g. Subscriptions, Freelance',
                    filled: true,
                    fillColor: isDark
                        ? const Color(0xFF161F1C)
                        : const Color(0xFFF7F9F8),
                    counterStyle: TextStyle(
                      color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF78837F),
                      fontSize: 11,
                    ),
                    errorStyle: const TextStyle(
                      color: Color(0xFFE05A62),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: isDark
                            ? const Color(0xFF283631)
                            : const Color(0xFFE9EFEC),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: isDark
                            ? const Color(0xFF283631)
                            : const Color(0xFFE9EFEC),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF0BA874),
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFFE05A62),
                        width: 1.2,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFFE05A62),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Color Picker
                const Text(
                  'Color Theme',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _availableColors.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final c = _availableColors[index];
                      final isSelected = c == _selectedColor;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = c),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Color(c),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.transparent,
                              width: 2.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Color(c).withValues(alpha: 0.5),
                                      blurRadius: 8,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 18, color: Colors.white)
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),

                // Icon Picker
                const Text(
                  'Choose Icon',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 110,
                  child: GridView.builder(
                    itemCount: _availableIcons.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final ic = _availableIcons[index];
                      final isSelected = ic.codePoint == _selectedIcon;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedIcon = ic.codePoint),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(_selectedColor).withValues(alpha: 0.2)
                                : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04)),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? Color(_selectedColor)
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            ic,
                            size: 20,
                            color: isSelected
                                ? Color(_selectedColor)
                                : (isDark ? Colors.white70 : const Color(0xFF5F6E69)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 22),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0BA874),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save Category',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _typeChip(String label, TransactionType type) {
    final isSelected = _selectedType == type;
    const activeColor = Color(0xFF0BA874);

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor
                : (Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF161F1C)
                    : const Color(0xFFF7F9F8)),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : const Color(0xFF78837F),
            ),
          ),
        ),
      ),
    );
  }
}
