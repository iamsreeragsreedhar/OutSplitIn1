import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:out_split_in/core/service_locator/di.dart';
import 'package:out_split_in/core/services/network_service.dart';
import 'package:out_split_in/core/shared_widgets/app_fade_slide.dart';
import 'package:out_split_in/core/shared_widgets/receipt_viewer_dialog.dart';

import 'package:out_split_in/core/shared_widgets/extensions/date_ext.dart';
import 'package:out_split_in/core/shared_widgets/snackbar.dart';
import 'package:out_split_in/feature/add_transaction/view_model/addtrans/addtrans_bloc.dart';
import 'package:out_split_in/feature/add_transaction/widgets/date_fieild.dart';
import 'package:out_split_in/feature/add_transaction/widgets/offline_notice_banner.dart';
import 'package:out_split_in/feature/category/model/category_item_model.dart';
import 'package:out_split_in/feature/category/view_model/category/category_bloc.dart';
import 'package:out_split_in/feature/category/view_model/category/category_event.dart';
import 'package:out_split_in/feature/category/view_model/category/category_state.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart'
    show TransactionModel, TransactionType;
import 'package:out_split_in/feature/home/widgets/functions/function.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  static const Color primary = Color(0xFF0BA874);
  static const Color darkGreen = Color(0xFF087F59);
  static const Color lightGreen = Color(0xFFE8F8F2);
  static const Color background = Color(0xFFF7F9F8);
  static const Color textDark = Color(0xFF18231F);
  static const Color textMuted = Color(0xFF84918B);

  bool isExpense = true;
  String selectedCategory = 'Food';
  final formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  final amountController = TextEditingController();
  final noteController = TextEditingController();
  File? _receiptFile;

  late final NetworkService _networkService;
  StreamSubscription<bool>? _networkSubscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(const LoadCategoriesEvent());
    _networkService = sl<NetworkService>();
    _isConnected = _networkService.isConnected;
    _networkSubscription =
        _networkService.onConnectivityChanged.listen((connected) {
      if (mounted) {
        setState(() {
          _isConnected = connected;
        });
      }
    });
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    final connected = await _networkService.checkIsConnected();
    if (mounted) {
      setState(() {
        _isConnected = connected;
      });
    }
  }

  @override
  void dispose() {
    _networkSubscription?.cancel();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  String? validateAmount(String value) {
    final input = value.trim();

    if (input.isEmpty) return 'Please enter an amount';

    final normalized = input.replaceAll(',', '.');
    final amount = double.tryParse(normalized);

    if (amount == null || !amount.isFinite) {
      return 'Please enter a valid amount';
    }

    if (amount <= 0) return 'Amount must be greater than zero';

    if (amount > 100000000) {
      return 'Amount cannot exceed ₹100,000,000';
    }

    final dotIndex = normalized.indexOf('.');
    if (dotIndex != -1 && (normalized.length - dotIndex - 1) > 2) {
      return 'Amount can have at most 2 decimal places';
    }

    return null;
  }

  Future<void> pickDate() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: primary,
                    onPrimary: Colors.white,
                    surface: Color(0xFF1E2824),
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: primary,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: textDark,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> _pickReceipt(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (picked == null) return;

      final appDir = await getApplicationDocumentsDirectory();
      final receiptsDir = Directory('${appDir.path}/receipts');
      if (!await receiptsDir.exists()) {
        await receiptsDir.create(recursive: true);
      }

      final fileName = 'receipt_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedFile =
          await File(picked.path).copy('${receiptsDir.path}/$fileName');

      if (mounted) {
        setState(() {
          _receiptFile = savedFile;
        });
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.error(context, 'Failed to attach image: $e');
      }
    }
  }

  void _showImageSourceSheet(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E2824) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Attach Bill / Receipt',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : textDark,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: primary),
                  ),
                  title: Text(
                    'Take a Photo',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : textDark,
                    ),
                  ),
                  subtitle: Text(
                    'Use device camera to snap receipt',
                    style: TextStyle(
                      color: isDark ? Colors.white60 : textMuted,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickReceipt(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: primary),
                  ),
                  title: Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : textDark,
                    ),
                  ),
                  subtitle: Text(
                    'Select existing bill from device photos',
                    style: TextStyle(
                      color: isDark ? Colors.white60 : textMuted,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickReceipt(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void saveTransaction() {
    if (!formKey.currentState!.validate()) return;

    final sanitized = amountController.text.trim().replaceAll(',', '.');
    final amount = double.tryParse(sanitized);
    if (amount == null || amount <= 0) return;

    FocusScope.of(context).unfocus();

    context.read<AddtransBloc>().add(
      addTransaction(
        TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          smsId: '',
          type: isExpense ? TransactionType.expense : TransactionType.income,
          amount: amount,
          title: noteController.text.trim().isEmpty
              ? selectedCategory
              : noteController.text.trim(),
          source: '',
          sender: '',
          date: selectedDate,
          autoDetected: false,
          category: stringToCategory(selectedCategory),
          receiptPath: _receiptFile?.path,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: BlocConsumer<AddtransBloc, AddtransState>(
        listener: (context, state) {
          if (state.loadingStatus == LoadingStatus.success) {
            final isOffline = state.msg.toLowerCase().contains('offline');
            if (isOffline) {
              AppSnackbar.offline(context, state.msg);
            } else {
              AppSnackbar.success(context, state.msg);
            }

            amountController.clear();
            noteController.clear();

            setState(() {
              isExpense = true;
              selectedCategory = '';
              selectedDate = DateTime.now();
              _receiptFile = null;
            });

            context.go('/home');
          } else if (state.loadingStatus == LoadingStatus.error) {
            AppSnackbar.error(context, state.msg);
          }
        },
        builder: (context, state) {
          final isLoading = state.loadingStatus == LoadingStatus.loading;

          return LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth > 640
                  ? 600.0
                  : double.infinity;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppFadeSlide(
                            direction: SlideDirection.fromTop,
                            child: _buildHeader(isDark),
                          ),
                          const SizedBox(height: 18),

                          OfflineNoticeBanner(
                            isConnected: _isConnected,
                            onRetry: _checkConnection,
                          ),

                          _sectionLabel('TRANSACTION TYPE', isDark),
                          const SizedBox(height: 10),
                          AppFadeSlide(
                            delay: const Duration(milliseconds: 60),
                            child: _buildTypeSelector(isDark),
                          ),

                          const SizedBox(height: 24),
                          _sectionLabel('AMOUNT', isDark),
                          const SizedBox(height: 10),
                          AppFadeSlide(
                            delay: const Duration(milliseconds: 120),
                            child: _buildAmountCard(),
                          ),

                          const SizedBox(height: 26),
                          _sectionLabel('CHOOSE CATEGORY', isDark),
                          const SizedBox(height: 12),
                          AppFadeSlide(
                            delay: const Duration(milliseconds: 180),
                            child: _buildCategoryGrid(constraints.maxWidth, isDark),
                          ),

                          const SizedBox(height: 26),
                          _sectionLabel('DATE', isDark),
                          const SizedBox(height: 10),
                          AppFadeSlide(
                            delay: const Duration(milliseconds: 240),
                            child: _buildDateField(),
                          ),

                          const SizedBox(height: 24),
                          _sectionLabel('NOTE (OPTIONAL)', isDark),
                          const SizedBox(height: 10),
                          AppFadeSlide(
                            delay: const Duration(milliseconds: 280),
                            child: _buildNoteField(isDark),
                          ),

                          const SizedBox(height: 24),
                          _sectionLabel('ATTACH RECEIPT / BILL (OPTIONAL)', isDark),
                          const SizedBox(height: 10),
                          AppFadeSlide(
                            delay: const Duration(milliseconds: 300),
                            child: _buildReceiptPicker(isDark),
                          ),

                          const SizedBox(height: 30),
                          AppFadeSlide(
                            delay: const Duration(milliseconds: 320),
                            child: _buildSaveButton(isLoading),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E352C) : lightGreen,
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Icon(Icons.add_card_rounded, color: primary, size: 27),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Transaction',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                  color: isDark ? Colors.white : textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Track where your money goes.',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? const Color(0xFFA1AFA9) : textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
        color: isDark ? const Color(0xFFA1AFA9) : textMuted,
      ),
    );
  }

  Widget _buildTypeSelector(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2824) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _typeButton(
              label: 'Expense',
              icon: Icons.arrow_downward_rounded,
              selected: isExpense,
              color: const Color(0xFFE05D5D),
              isDark: isDark,
              onTap: () => setState(() {
                isExpense = true;
                selectedCategory = '';
              }),
            ),
          ),
          Expanded(
            child: _typeButton(
              label: 'Income',
              icon: Icons.arrow_upward_rounded,
              selected: !isExpense,
              color: primary,
              isDark: isDark,
              onTap: () => setState(() {
                isExpense = false;
                selectedCategory = '';
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeButton({
    required String label,
    required IconData icon,
    required bool selected,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected
                      ? Colors.white
                      : (isDark ? const Color(0xFFA1AFA9) : textMuted),
                ),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : (isDark ? const Color(0xFFA1AFA9) : textMuted),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primary, darkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            isExpense ? 'Expense amount' : 'Income amount',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '₹',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: amountController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) => validateAmount(value ?? ''),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorStyle: TextStyle(
                      color: Color(0xFFFFD6D6),
                      fontSize: 12,
                    ),
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Enter the exact transaction amount',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(double availableWidth, bool isDark) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 700
        ? 4
        : width >= 420
        ? 4
        : 3;

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, catState) {
        final targetType =
            isExpense ? TransactionType.expense : TransactionType.income;
        final list = catState.allCategories
            .where((c) => c.type == targetType)
            .toList();

        final activeCategories = list.isNotEmpty
            ? list
            : CategoryItemModel.defaultCategories
                .where((c) => c.type == targetType)
                .toList();

        if (selectedCategory.isEmpty ||
            !activeCategories.any((c) => c.name == selectedCategory)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && activeCategories.isNotEmpty) {
              setState(() {
                selectedCategory = activeCategories.first.name;
              });
            }
          });
        }

        final totalCount = activeCategories.length + 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: width < 360 ? 0.95 : 1.05,
          ),
          itemBuilder: (context, index) {
            if (index == activeCategories.length) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => context.push('/categories'),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2824) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF283631)
                            : const Color(0xFFE9EFEC),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color:
                                isDark ? const Color(0xFF25332E) : background,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Flexible(
                          child: Text(
                            '+ Add New',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final category = activeCategories[index];
            final selected = selectedCategory == category.name;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  setState(() => selectedCategory = category.name);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? (isDark ? const Color(0xFF1E352C) : lightGreen)
                        : (isDark ? const Color(0xFF1E2824) : Colors.white),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selected
                          ? primary
                          : (isDark
                              ? const Color(0xFF283631)
                              : const Color(0xFFE9EFEC)),
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: selected
                              ? primary.withValues(alpha: 0.15)
                              : (isDark ? const Color(0xFF25332E) : background),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          category.icon,
                          color: selected
                              ? primary
                              : (isDark ? const Color(0xFFA1AFA9) : textMuted),
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: Text(
                          category.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                selected ? FontWeight.w800 : FontWeight.w600,
                            color: selected
                                ? (isDark ? const Color(0xFF5BE2B5) : darkGreen)
                                : (isDark ? Colors.white : textDark),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDateField() {
    return DateField(
      text: formatDate(selectedDate).split(' ')[0],
      icon: Icons.calendar_month_rounded,
      onpresss: pickDate,
    );
  }

  Widget _buildNoteField(bool isDark) {
    return TextField(
      controller: noteController,
      maxLength: 120,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(
        color: isDark ? Colors.white : textDark,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: 'e.g. Lunch with friends',
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFFA1AFA9) : textMuted,
          fontSize: 13,
        ),
        prefixIcon: Icon(
          Icons.edit_note_rounded,
          color: isDark ? const Color(0xFFA1AFA9) : textMuted,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E2824) : Colors.white,
        counterStyle: TextStyle(
          color: isDark ? const Color(0xFFA1AFA9) : textMuted,
          fontSize: 10,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: primary, width: 1.4),
        ),
      ),
    );
  }

  Widget _buildReceiptPicker(bool isDark) {
    if (_receiptFile != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2824) : Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: primary.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Thumbnail preview
            GestureDetector(
              onTap: () {
                ReceiptViewerDialog.show(
                  context,
                  receiptPath: _receiptFile!.path,
                  title: noteController.text.trim().isNotEmpty
                      ? noteController.text.trim()
                      : 'Attached Receipt',
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.file(
                      _receiptFile!,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      color: Colors.black.withValues(alpha: 0.25),
                      child: const Icon(
                        Icons.fullscreen_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: primary,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Receipt Attached',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: isDark ? Colors.white : textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap thumbnail to preview / zoom',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? const Color(0xFFA1AFA9) : textMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Change or Remove
            IconButton(
              tooltip: 'Remove receipt',
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              onPressed: () {
                setState(() {
                  _receiptFile = null;
                });
              },
            ),
          ],
        ),
      );
    }

    // Unselected state
    return InkWell(
      onTap: () => _showImageSourceSheet(isDark),
      borderRadius: BorderRadius.circular(17),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2824) : Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: isDark ? const Color(0xFF283631) : const Color(0xFFE0E7E3),
            style: BorderStyle.solid,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF24332D) : lightGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_a_photo_outlined,
                color: primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload Bill / Receipt Photo',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: isDark ? Colors.white : textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Take photo or choose from gallery',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFFA1AFA9) : textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : saveTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          disabledBackgroundColor: primary.withValues(alpha: 0.6),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: isLoading
            ? LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 28,
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 21),
                  SizedBox(width: 10),
                  Text(
                    'Save Transaction',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
      ),
    );
  }
}
