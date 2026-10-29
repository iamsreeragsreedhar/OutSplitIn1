import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:out_split_in/feature/onboarding/model/onboarding_item.dart';
import 'package:out_split_in/feature/onboarding/widgets/onboarding_action_button.dart';
import 'package:out_split_in/feature/onboarding/widgets/onboarding_skip_button.dart';
import 'package:out_split_in/feature/onboarding/widgets/onboarding_slide_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.go('/home');
    } else {
      context.go('/');
    }
  }

  void _onNextPressed() {
    if (_currentPage < OnboardingItem.items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    const isLastSlide = 2; // index of last slide
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: OnboardingSkipButton(onSkip: _completeOnboarding),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: OnboardingItem.items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingSlideWidget(
                    item: OnboardingItem.items[index],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: OnboardingItem.items.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: const Color(0xFF0BA874),
                      dotColor: isDark ? const Color(0xFF283631) : const Color(0xFFD6E3DD),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3.5,
                      spacing: 6,
                    ),
                  ),
                  const SizedBox(height: 28),
                  OnboardingActionButton(
                    isLastSlide: _currentPage == isLastSlide,
                    onPressed: _onNextPressed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
