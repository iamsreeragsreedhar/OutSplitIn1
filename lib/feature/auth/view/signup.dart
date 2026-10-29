import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:out_split_in/core/shared_widgets/auth_textfield.dart';
import 'package:out_split_in/core/shared_widgets/network_status_banner.dart';
import 'package:out_split_in/core/shared_widgets/snackbar.dart';
import 'package:out_split_in/feature/auth/view/login.dart';
import 'package:out_split_in/feature/auth/view_model/auth/auth_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:out_split_in/feature/auth/widget/signup_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool acceptedTerms = false;

  void _submitSignup() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!acceptedTerms) {
      AppSnackbar.info(
        context,
        'Please accept the Terms of Service and Privacy Policy to continue',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    context.read<AuthBloc>().add(
      AuthEvent.signupPressed(
        emailController.text.trim(),
        passwordController.text,
        nameController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.loadingStatus == AuthLoadingStatus.success) {
            AppSnackbar.success(context, 'Account created successfully');
            context.go('/');
          } else if (state.loadingStatus == AuthLoadingStatus.error) {
            AppSnackbar.error(context, state.msg);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _brand(isDark),

                            const SizedBox(height: 10),

                            Text(
                              'Create Your Account',
                              style: TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : const Color(0xFF17201D),
                              ),
                            ),

                            const SizedBox(height: 7),

                            Text(
                              'Start your journey to better money management',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF78837F),
                              ),
                            ),

                            const SizedBox(height: 28),
                            const NetworkStatusBanner(),
                            AuthTextField(
                              label: 'Full Name',
                              hint: 'Enter your full name',
                              icon: Icons.person_outline,
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.name],
                              validator: (value) {
                                final trimmed = value?.trim() ?? '';
                                if (trimmed.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                if (trimmed.length < 2) {
                                  return 'Name must be at least 2 characters';
                                }
                                if (trimmed.length > 50) {
                                  return 'Name cannot exceed 50 characters';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            AuthTextField(
                              label: 'Email address',
                              hint: 'you@example.com',
                              icon: Icons.email_outlined,
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

                            const SizedBox(height: 16),

                            AuthTextField(
                              label: 'Password',
                              hint: 'Create a strong password (min 6 chars)',
                              icon: Icons.lock_outline,
                              controller: passwordController,
                              obscureText: obscurePassword,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.newPassword],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF7D8883),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            AuthTextField(
                              label: 'Confirm Password',
                              hint: 'Re-enter your password',
                              icon: Icons.lock_outline,
                              controller: confirmPasswordController,
                              obscureText: obscureConfirmPassword,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.newPassword],
                              onFieldSubmitted: (_) => _submitSignup(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureConfirmPassword =
                                        !obscureConfirmPassword;
                                  });
                                },
                                icon: Icon(
                                  obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF7D8883),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),
                            _terms(isDark),
                            const SizedBox(height: 20),
                            _loginLink(isDark),
                            const SizedBox(height: 28),
                            (state.authtype == Authtype.signup &&
                                    state.loadingStatus ==
                                        AuthLoadingStatus.loading)
                                ? Center(
                                    child:
                                        LoadingAnimationWidget.staggeredDotsWave(
                                          color: const Color(0xFF0BA874),
                                          size: 50,
                                        ),
                                  )
                                : SignupButton(
                                    buttonname: 'Create Account',
                                    onpressed: _submitSignup,
                                  ),
                            const SizedBox(height: 20),
                            _securityFeatures(isDark),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _brand(bool isDark) {
    return Row(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF0BA874),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.bar_chart_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),

        const SizedBox(width: 12),

        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Out',
                style: TextStyle(
                  color: Color(0xFF087F59),
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: 'Split',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF18211E),
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const TextSpan(
                text: 'In',
                style: TextStyle(
                  color: Color(0xFFF47A45),
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _terms(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: acceptedTerms,
            activeColor: const Color(0xFF0BA874),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onChanged: (value) {
              setState(() {
                acceptedTerms = value ?? false;
              });
            },
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text.rich(
            TextSpan(
              text: 'I agree to the ',
              style: TextStyle(
                color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF78837F),
                fontSize: 12,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF10C487) : const Color(0xFF087F59),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF10C487) : const Color(0xFF087F59),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _securityFeatures(bool isDark) {
    return Row(
      children: [
        _securityItem(Icons.shield_outlined, 'Your data\nis secure', isDark),
        _securityItem(Icons.cloud_outlined, 'Backed by\nFirebase', isDark),
        _securityItem(Icons.bar_chart_rounded, 'Track your\nmoney', isDark),
      ],
    );
  }

  Widget _securityItem(IconData icon, String text, bool isDark) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E352C) : const Color(0xFFE8F8F2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDark ? const Color(0xFF10C487) : const Color(0xFF087F59),
              size: 21,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF78837F),
              fontSize: 10,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginLink(bool isDark) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(
                  color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF78837F),
                ),
              ),
              TextSpan(
                text: 'Sign In',
                style: TextStyle(
                  color: isDark ? const Color(0xFF10C487) : const Color(0xFF087F59),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
