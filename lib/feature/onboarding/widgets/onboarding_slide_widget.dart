import 'package:flutter/material.dart';
import 'package:out_split_in/core/shared_widgets/app_fade_slide.dart';
import 'package:out_split_in/feature/onboarding/model/onboarding_item.dart';

class OnboardingSlideWidget extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingSlideWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Floating Icon Hero Card
          AppFadeSlide(
            direction: SlideDirection.scaleOnly,
            duration: const Duration(milliseconds: 550),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glowing outer orb
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.accentColor.withValues(alpha: 0.12),
                    ),
                  ),
                  // Inner gradient badge
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          item.accentColor,
                          item.accentColor.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: item.accentColor.withValues(alpha: 0.35),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(item.icon, size: 56, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 38),

          // Category Badge Pill & Title
          AppFadeSlide(
            delay: const Duration(milliseconds: 100),
            direction: SlideDirection.fromBottom,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: item.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: item.accentColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    item.badge,
                    style: TextStyle(
                      color: item.accentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF17201D),
                    letterSpacing: -0.8,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  item.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF6E7C77),
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Feature Highlight Chips
          AppFadeSlide(
            delay: const Duration(milliseconds: 180),
            direction: SlideDirection.fromBottom,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2824) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: item.features
                    .map(
                      (feature) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          feature,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : const Color(0xFF2C3E37),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
