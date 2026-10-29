import 'dart:io';
import 'package:out_split_in/core/config/app_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:out_split_in/core/localization/app_localizations.dart';
import 'package:out_split_in/core/localization/locale_controller.dart';
import 'package:out_split_in/core/service_locator/di.dart';
import 'package:out_split_in/core/services/budget_service.dart';
import 'package:out_split_in/core/services/excel_export_service.dart';
import 'package:out_split_in/core/services/firebase_services.dart';
import 'package:out_split_in/core/services/upi_notification_service.dart';
import 'package:out_split_in/core/shared_widgets/app_fade_slide.dart';
import 'package:out_split_in/core/shared_widgets/language_selector_modal.dart';
import 'package:out_split_in/core/shared_widgets/monthly_budget_dialog.dart';
import 'package:out_split_in/core/shared_widgets/snackbar.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';
import 'package:out_split_in/feature/home/view_model/home/home_bloc.dart';
import 'package:out_split_in/feature/profile/widgets/settings_listtile.dart';
import 'package:out_split_in/feature/profile/widgets/theme_selector_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color primary = Color(0xFF0BA874);
  static const Color darkGreen = Color(0xFF087F59);
  static const Color textDark = Color(0xFF18231F);
  static const Color muted = Color(0xFF84918B);

  bool isselected = false;
  String? _customAvatarPath;
  String? _selectedAvatarPreset;

  @override
  void initState() {
    super.initState();
    _checkUpiStatus();
    _loadCustomAvatar();
  }

  Future<void> _loadCustomAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final localPath = prefs.getString('user_avatar_path_${user.uid}');
      final preset = prefs.getString('user_avatar_preset_${user.uid}');
      if (mounted) {
        setState(() {
          _customAvatarPath = localPath;
          _selectedAvatarPreset = preset;
        });
      }
    } catch (_) {}
  }

  Future<void> _pickImage(ImageSource source) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_avatar_path_${user.uid}', pickedFile.path);
        await prefs.remove('user_avatar_preset_${user.uid}');
        if (mounted) {
          setState(() {
            _customAvatarPath = pickedFile.path;
            _selectedAvatarPreset = null;
          });
          AppSnackbar.success(context, 'Profile picture updated successfully!');
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.error(context, 'Failed to pick image: $e');
      }
    }
  }

  Future<void> _selectAvatarPreset(String emoji) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_avatar_preset_${user.uid}', emoji);
      await prefs.remove('user_avatar_path_${user.uid}');
      if (mounted) {
        setState(() {
          _selectedAvatarPreset = emoji;
          _customAvatarPath = null;
        });
        AppSnackbar.success(context, 'Avatar selected!');
      }
    } catch (_) {}
  }

  Future<void> _removeProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_avatar_path_${user.uid}');
      await prefs.remove('user_avatar_preset_${user.uid}');
      if (mounted) {
        setState(() {
          _customAvatarPath = null;
          _selectedAvatarPreset = null;
        });
        AppSnackbar.info(context, 'Profile picture reset');
      }
    } catch (_) {}
  }

  void _showAvatarOptionsBottomSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E2824) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF33423C) : const Color(0xFFE0E5E2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Profile Picture',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : textDark,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: primary),
                  ),
                  title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: primary),
                  ),
                  title: const Text('Take a Photo', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A89DC).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.face_rounded, color: Color(0xFF4A89DC)),
                  ),
                  title: const Text('Choose Avatar Style', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showPresetAvatarsDialog();
                  },
                ),
                if (_customAvatarPath != null || _selectedAvatarPreset != null)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE05A62).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE05A62)),
                    ),
                    title: const Text('Remove Picture', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE05A62))),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _removeProfilePicture();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPresetAvatarsDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final presets = ['🦊', '🦁', '🚀', '👑', '⚡', '💎', '🐼', '🌟'];

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E2824) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            'Choose an Avatar',
            style: TextStyle(
              color: isDark ? Colors.white : textDark,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: presets.map((emoji) {
              final isSelected = _selectedAvatarPreset == emoji;
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.pop(dialogCtx);
                  _selectAvatarPreset(emoji);
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primary.withValues(alpha: 0.2)
                        : (isDark ? const Color(0xFF283631) : const Color(0xFFF0F4F2)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 28)),
                  ),
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAvatarImage(User? user) {
    if (_customAvatarPath != null && _customAvatarPath!.isNotEmpty) {
      final file = File(_customAvatarPath!);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      }
    }

    if (_selectedAvatarPreset != null && _selectedAvatarPreset!.isNotEmpty) {
      return Center(
        child: Text(
          _selectedAvatarPreset!,
          style: const TextStyle(fontSize: 34),
        ),
      );
    }

    if (user?.photoURL != null && user!.photoURL!.isNotEmpty) {
      return Image.network(
        user.photoURL!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.person_rounded,
          size: 38,
          color: Colors.white,
        ),
      );
    }

    return const Icon(
      Icons.person_rounded,
      size: 38,
      color: Colors.white,
    );
  }

  Future<void> _checkUpiStatus() async {
    final upi = sl<UpiNotificationService>();
    final granted = await upi.isPermissionGranted();
    if (mounted) {
      setState(() {
        isselected = granted && upi.isListening;
      });
    }
  }

  Future<void> _toggleUpiSync(bool enable) async {
    final upi = sl<UpiNotificationService>();
    if (enable) {
      final granted = await upi.isPermissionGranted();
      if (!granted) {
        final requested = await upi.requestPermission();
        if (!requested) {
          if (mounted) {
            setState(() => isselected = false);
            AppSnackbar.info(
              context,
              'Notification listener permission is required',
            );
          }
          return;
        }
      }
      final started = await upi.startListening();
      if (mounted) {
        setState(() => isselected = started);
        if (started) {
          AppSnackbar.success(context, 'UPI Auto-detection enabled');
        }
      }
    } else {
      await upi.stopListening();
      if (mounted) {
        setState(() => isselected = false);
        AppSnackbar.info(context, 'UPI Auto-detection paused');
      }
    }
  }

  Future<void> _showEditProfileDialog(
    String currentName,
  ) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: currentName);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final updated = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool isUpdating = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E2824) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              title: Text(
                'Edit Profile Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : textDark,
                ),
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your new display name',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFFA1AFA9) : muted,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: controller,
                      enabled: !isUpdating,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLength: 50,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        final trimmed = value?.trim() ?? '';
                        if (trimmed.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (trimmed.length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        if (trimmed.length > 50) {
                          return 'Name cannot exceed 50 characters';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: isDark ? Colors.white : textDark,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Display Name',
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF161F1C)
                            : const Color(0xFFF7F9F8),
                        counterStyle: TextStyle(
                          color: isDark ? const Color(0xFFA1AFA9) : muted,
                          fontSize: 11,
                        ),
                        errorStyle: const TextStyle(
                          color: Color(0xFFE05A62),
                          fontSize: 12,
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
                            color: primary,
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
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isUpdating
                      ? null
                      : () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: primary,
                    minimumSize: const Size(80, 42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isUpdating
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          final newName = controller.text.trim();
                          if (newName == currentName) {
                            Navigator.pop(dialogContext, false);
                            return;
                          }
                          setDialogState(() => isUpdating = true);
                          try {
                            await sl<FirebaseServices>().updateUsername(newName);
                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext, true);
                            }
                          } catch (e) {
                            if (dialogContext.mounted) {
                              setDialogState(() => isUpdating = false);
                              AppSnackbar.error(
                                dialogContext,
                                'Failed to update profile name',
                              );
                            }
                          }
                        },
                  child: isUpdating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (updated == true && mounted) {
      setState(() {});
      AppSnackbar.success(context, 'Profile name updated successfully');
    }
  }

  Future<void> _exportData(
    BuildContext context,
    List<TransactionModel> transactions,
  ) async {
    if (transactions.isEmpty) {
      AppSnackbar.info(context, 'No transactions available to export');
      return;
    }
    try {
      AppSnackbar.info(context, 'Preparing Excel spreadsheet...');
      await ExcelExportService.exportTransactions(transactions);
    } catch (e) {
      if (context.mounted) {
        AppSnackbar.error(context, 'Failed to export transactions: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 720 ? 680.0 : double.infinity;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppFadeSlide(
                      direction: SlideDirection.fromTop,
                      child: _buildHeader(isDark),
                    ),
                    const SizedBox(height: 24),
                    AppFadeSlide(
                      delay: const Duration(milliseconds: 80),
                      child: _buildProfileCard(),
                    ),
                    const SizedBox(height: 28),
                    AppFadeSlide(
                      delay: const Duration(milliseconds: 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(l10n.preferences, isDark),
                          const SizedBox(height: 12),
                          _buildSettingsCard([
                            SettingsListtile(
                              icon: Icons.notifications_active_rounded,
                              title: l10n.upiAutoDetect,
                              subtitle: l10n.upiAutoDetectSubtitle,
                              trailing: Switch.adaptive(
                                value: isselected,
                                onChanged: _toggleUpiSync,
                                activeTrackColor: primary,
                              ),
                            ),
                            _divider(isDark),
                            ListenableBuilder(
                              listenable: BudgetService.instance,
                              builder: (context, _) {
                                final budget = BudgetService.instance.budgetLimit;
                                return SettingsListtile(
                                  icon: Icons.account_balance_wallet_outlined,
                                  title: l10n.monthlyBudget,
                                  subtitle:
                                      '${l10n.budgetLimit}: ₹${NumberFormat('#,##,###').format(budget)} / month',
                                  ontap: () => MonthlyBudgetDialog.show(context),
                                );
                              },
                            ),
                            _divider(isDark),
                            ListenableBuilder(
                              listenable: LocaleController.instance,
                              builder: (context, _) {
                                final currentLang = LocaleController.getLanguageName(
                                  LocaleController.instance.locale.languageCode,
                                );
                                return SettingsListtile(
                                  icon: Icons.language_rounded,
                                  title: l10n.language,
                                  subtitle: currentLang,
                                  ontap: () => LanguageSelectorModal.show(context),
                                );
                              },
                            ),
                            _divider(isDark),
                            SettingsListtile(
                              icon: Icons.table_view_outlined,
                              title: l10n.exportData,
                              subtitle: l10n.exportSubtitle,
                              ontap: () {
                                final txs = context
                                    .read<HomeBloc>()
                                    .state
                                    .transactions
                                    .whereType<TransactionModel>()
                                    .toList();
                                _exportData(context, txs);
                              },
                            ),
                            _divider(isDark),
                            SettingsListtile(
                              icon: Icons.category_outlined,
                              title: l10n.categories,
                              subtitle: l10n.categoriesSubtitle,
                              ontap: () => context.push('/categories'),
                            ),
                            _divider(isDark),
                            SettingsListtile(
                              icon: Icons.notifications_none_rounded,
                              title: l10n.notifications,
                              subtitle: l10n.notificationsSubtitle,
                              ontap: () => context.push('/notifications'),
                            ),
                            _divider(isDark),
                            SettingsListtile(
                              icon: Icons.palette_outlined,
                              title: l10n.appearance,
                              subtitle: l10n.appearanceSubtitle,
                              ontap: () => ThemeSelectorModal.show(context),
                            ),
                          ], isDark),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppFadeSlide(
                      delay: const Duration(milliseconds: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle(l10n.accountAndSupport, isDark),
                          const SizedBox(height: 12),
                          _buildSettingsCard([
                            SettingsListtile(
                              icon: Icons.auto_awesome,
                              title: l10n.aiAssistant,
                              subtitle: l10n.aiAssistantSubtitle,
                              ontap: () => context.push('/chatbot'),
                            ),
                            _divider(isDark),
                            SettingsListtile(
                              icon: Icons.shield_outlined,
                              title: l10n.privacySecurity,
                              subtitle: l10n.privacySecuritySubtitle,
                              ontap: () {
                                _showComingSoon(context, l10n.privacySecurity);
                              },
                            ),
                          ], isDark),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    AppFadeSlide(
                      delay: const Duration(milliseconds: 260),
                      child: _buildLogoutButton(
                        onTap: () => _confirmLogout(context),
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'OUTSPLITIN • SMART FINANCIAL TRACKER',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFA1AFA9) : muted,
                            ),
                          ),
                          if (AppConfig.instance.isDev) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.amber.withValues(alpha: 0.4),
                                ),
                              ),
                              child: const Text(
                                'DEVELOPMENT ENVIRONMENT',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile',
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: isDark ? Colors.white : textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Your account, your preferences.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? const Color(0xFFA1AFA9) : muted,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    final user = FirebaseAuth.instance.currentUser;
    final displayName =
        (user?.displayName != null && user!.displayName!.isNotEmpty)
        ? user.displayName!
        : (user?.email?.split('@').first ?? 'User');
    final email = user?.email ?? 'No email associated';

    final homeState = context.watch<HomeBloc>().state;
    final transactions = homeState.transactions;
    final income = transactions
        .where((t) => t.type == TransactionType.income)
        .fold<double>(0, (sum, t) => sum + t.amount);
    final expenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold<double>(0, (sum, t) => sum + t.amount);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primary, darkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.16),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _showAvatarOptionsBottomSheet,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 68,
                      width: 68,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _buildAvatarImage(user),
                      ),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: primary,
                          size: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            displayName,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: displayName.length > 22
                                  ? 18
                                  : (displayName.length > 15 ? 20 : 23),
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.6,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2.5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.35),
                                width: 0.8,
                              ),
                            ),
                            child: const Text(
                              'PRO',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit name',
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 21,
                ),
                onPressed: () => _showEditProfileDialog(displayName),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.22)),
          const SizedBox(height: 18),
          const Text(
            'YOUR FINANCIAL OVERVIEW',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 340;

              return Row(
                children: [
                  Expanded(
                    child: _profileStat(
                      value: '${transactions.length}',
                      label: 'Total recorded',
                      compact: compact,
                    ),
                  ),
                  _statDivider(),
                  Expanded(
                    child: _profileStat(
                      value: '₹${income.toStringAsFixed(0)}',
                      label: 'Total income',
                      compact: compact,
                    ),
                  ),
                  _statDivider(),
                  Expanded(
                    child: _profileStat(
                      value: '₹${expenses.toStringAsFixed(0)}',
                      label: 'Total expenses',
                      compact: compact,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _profileStat({
    required String value,
    required String label,
    required bool compact,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 16 : 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          maxLines: 2,
          style: TextStyle(color: Colors.white70, fontSize: compact ? 9 : 10),
        ),
      ],
    );
  }

  Widget _statDivider() {
    return Container(
      height: 38,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white.withValues(alpha: 0.22),
    );
  }

  Widget _sectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        color: isDark ? const Color(0xFFA1AFA9) : muted,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2824) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.025),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 0.7,
      indent: 70,
      endIndent: 16,
      color: isDark ? const Color(0xFF283631) : const Color(0xFFEFF2F0),
    );
  }

  Widget _buildLogoutButton({
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.logout_rounded, size: 19),
        label: const Text(
          'Log out',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFE05A62),
          backgroundColor: isDark ? const Color(0xFF2B191B) : const Color(0xFFFFF5F5),
          side: BorderSide(
            color: isDark ? const Color(0xFF452224) : const Color(0xFFF4DEDE),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Are you sure you want to log out of OutSplitIn?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD94C4C),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      await sl<UpiNotificationService>().stopListening();
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        context.go('/');
      }
    }
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature settings are coming soon.')),
    );
  }
}
