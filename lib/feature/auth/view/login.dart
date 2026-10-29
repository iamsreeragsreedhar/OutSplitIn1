import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:out_split_in/core/shared_widgets/auth_textfield.dart';
import 'package:out_split_in/core/shared_widgets/network_status_banner.dart';
import 'package:out_split_in/core/shared_widgets/snackbar.dart';
import 'package:out_split_in/feature/auth/view_model/auth/auth_bloc.dart';
import 'package:out_split_in/feature/auth/widget/google_login_button.dart';
import 'package:out_split_in/feature/auth/widget/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  static const Color primary = Color(0xFF0BA874);
  static const Color darkGreen = Color(0xFF087F59);
  static const Color lightGreen = Color(0xFFE8F8F2);
  static const Color textDark = Color(0xFF18211E);
  static const Color muted = Color(0xFF78837F);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late final AnimationController animationController;
  late final Animation<double> fadeAnimation;
  late final Animation<Offset> slideAnimation;

  bool obscurePassword = true;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutCubic,
    );

    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (email.isEmpty) {
      AppSnackbar.info(context, 'Please enter your email address first');
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      AppSnackbar.error(context, 'Please enter a valid email address');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (!mounted) return;
      AppSnackbar.success(context, 'Password reset email sent');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      AppSnackbar.error(
        context,
        e.message ?? 'Unable to send password reset email',
      );
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.error(context, 'Something went wrong. Please try again.');
    }
  }

  void submitLogin() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();

    context.read<AuthBloc>().add(
      AuthEvent.loginPressed(
        emailController.text.trim(),
        passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if ((state.authtype == Authtype.login ||
                  state.authtype == Authtype.google) &&
              state.loadingStatus == AuthLoadingStatus.success) {
            final user = FirebaseAuth.instance.currentUser;
            final displayName =
                (user?.displayName != null && user!.displayName!.isNotEmpty)
                    ? user.displayName!
                    : (user?.email?.split('@').first ?? 'User');

            AppSnackbar.success(
              context,
              state.authtype == Authtype.google
                  ? 'Welcome, $displayName!'
                  : 'Welcome back, $displayName!',
            );

            context.go(
              '/home',
              extra: {'username': displayName},
            );
          } else if ((state.authtype == Authtype.login ||
                  state.authtype == Authtype.google) &&
              state.loadingStatus == AuthLoadingStatus.error) {
            AppSnackbar.error(context, state.msg);
          }
        },
        builder: (context, state) {
          final isLoading =
              state.authtype == Authtype.login &&
              state.loadingStatus == AuthLoadingStatus.loading;
          final isGoogleLoading =
              state.authtype == Authtype.google &&
              state.loadingStatus == AuthLoadingStatus.loading;

          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 850;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: isWide
                        ? _buildDesktopLayout(isLoading, isGoogleLoading, isDark)
                        : _buildMobileLayout(isLoading, isGoogleLoading, isDark),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(
    bool isLoading,
    bool isGoogleLoading,
    bool isDark,
  ) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: _animatedContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBrand(isDark),
                const SizedBox(height: 38),
                _buildWelcome(isDark),
                const SizedBox(height: 26),
                _buildLoginForm(isLoading, isGoogleLoading, isDark),
                const SizedBox(height: 24),
                _buildSignupLink(isDark),
                const SizedBox(height: 28),
                _buildFooter(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    bool isLoading,
    bool isGoogleLoading,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _buildHeroPanel()),
          const SizedBox(width: 36),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: _animatedContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBrand(isDark),
                      const SizedBox(height: 34),
                      _buildWelcome(isDark),
                      const SizedBox(height: 26),
                      _buildLoginForm(isLoading, isGoogleLoading, isDark),
                      const SizedBox(height: 24),
                      _buildSignupLink(isDark),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _animatedContent({required Widget child}) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(position: slideAnimation, child: child),
    );
  }

  Widget _buildBrand(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [primary, darkGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 27,
          ),
        ),
        const SizedBox(width: 12),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Out',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: 'Split',
                style: TextStyle(
                  color: isDark ? Colors.white : textDark,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const TextSpan(
                text: 'In',
                style: TextStyle(
                  color: Color(0xFFF47A45),
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWelcome(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back 👋',
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.9,
            color: isDark ? Colors.white : textDark,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          'Sign in to manage your money smarter.',
          style: TextStyle(
            color: isDark ? const Color(0xFFA1AFA9) : muted,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(
    bool isLoading,
    bool isGoogleLoading,
    bool isDark,
  ) {
    return Form(
      key: formKey,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2824) : Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.045),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign in',
              style: TextStyle(
                color: isDark ? Colors.white : textDark,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Enter your account details below.',
              style: TextStyle(
                color: isDark ? const Color(0xFFA1AFA9) : muted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 23),
            const NetworkStatusBanner(),
            AuthTextField(
              label: 'Email address',
              hint: 'you@example.com',
              icon: Icons.mail_outline_rounded,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return 'Please enter your email address';
                }
                final emailRegex = RegExp(
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                );
                if (!emailRegex.hasMatch(trimmed)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 19),

            AuthTextField(
              label: 'Password',
              hint: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              controller: passwordController,
              obscureText: obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => submitLogin(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              suffixIcon: IconButton(
                tooltip: obscurePassword ? 'Show password' : 'Hide password',
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: isDark ? const Color(0xFFA1AFA9) : muted,
                  size: 21,
                ),
              ),
            ),

            const SizedBox(height: 12),
            _buildRememberRow(isDark),
            const SizedBox(height: 23),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: isLoading
                  ? Container(
                      key: const ValueKey('loading'),
                      height: 54,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E352C) : lightGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: primary,
                          size: 32,
                        ),
                      ),
                    )
                  : SizedBox(
                      key: const ValueKey('button'),
                      width: double.infinity,
                      height: 54,
                      child: LoginButton(
                        text: 'Sign In',
                        onPressed: isGoogleLoading ? null : submitLogin,
                      ),
                    ),
            ),

            const SizedBox(height: 22),
            _buildDivider(isDark),
            const SizedBox(height: 18),
            GoogleLoginButton(
              isLoading: isGoogleLoading,
              onPressed: isLoading || isGoogleLoading
                  ? null
                  : () {
                      FocusScope.of(context).unfocus();
                      context
                          .read<AuthBloc>()
                          .add(const AuthEvent.googleSignIn());
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRememberRow(bool isDark) {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: rememberMe,
            activeColor: primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onChanged: (value) {
              setState(() => rememberMe = value ?? false);
            },
          ),
        ),
        const SizedBox(width: 7),
        Flexible(
          child: Text(
            'Remember me',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFFA1AFA9) : muted,
            ),
          ),
        ),
        const Spacer(),
        Flexible(
          child: TextButton(
            onPressed: resetPassword,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            child: Text(
              'Forgot password?',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: isDark ? const Color(0xFF10C487) : darkGreen,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDark ? const Color(0xFF283631) : const Color(0xFFE5EBE8),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR CONTINUE WITH',
            style: TextStyle(
              color: isDark ? const Color(0xFFA1AFA9) : muted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDark ? const Color(0xFF283631) : const Color(0xFFE5EBE8),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupLink(bool isDark) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: TextStyle(
              color: isDark ? const Color(0xFFA1AFA9) : muted,
              fontSize: 13,
            ),
          ),
          TextButton(
            onPressed: () => context.push('/signup'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Create account',
              style: TextStyle(
                color: isDark ? const Color(0xFF10C487) : darkGreen,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isDark) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E352C) : lightGreen,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shield_outlined,
              size: 19,
              color: isDark ? const Color(0xFF10C487) : darkGreen,
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                'Your financial journey, securely managed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? const Color(0xFF10C487) : darkGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroPanel() {
    return Container(
      constraints: const BoxConstraints(minHeight: 580),
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0BA874), Color(0xFF075C43)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          Positioned(top: -55, right: -45, child: _decorativeCircle(190)),
          Positioned(bottom: -80, left: -50, child: _decorativeCircle(230)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 42,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 34),
              const Text(
                'Take control of\nyour finances.',
                style: TextStyle(
                  fontSize: 39,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 17),
              Text(
                'Track your income, understand your expenses, '
                'and build better money habits with OutSplitIn.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.7,
                  color: Colors.white.withValues(alpha: 0.82),
                ),
              ),
              const SizedBox(height: 36),
              _heroFeature(Icons.insights_rounded, 'Understand your spending'),
              const SizedBox(height: 18),
              _heroFeature(
                Icons.savings_outlined,
                'Build smarter saving habits',
              ),
              const SizedBox(height: 18),
              _heroFeature(Icons.lock_outline_rounded, 'Secure account access'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _decorativeCircle(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.055),
      ),
    );
  }

  Widget _heroFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 21),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
