import 'package:flutter/material.dart';

/// A high-performance, synchronized shimmer gradient animation widget.
/// Sweeps smoothly across all descendant [ShimmerBox], [ShimmerCircle], or opaque widgets.
class AppShimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color? baseColor;
  final Color? highlightColor;

  const AppShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1400),
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = widget.baseColor ??
        (isDark ? const Color(0xFF1E2824) : const Color(0xFFE6EBE8));
    final highlight = widget.highlightColor ??
        (isDark ? const Color(0xFF2E3D35) : const Color(0xFFF7FAF8));

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-2.2 + (4.4 * t), -0.3),
              end: Alignment(-1.0 + (4.4 * t), 0.3),
              colors: [base, highlight, base],
              stops: const [0.1, 0.5, 0.9],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// A rounded rectangular placeholder block that responds to an ancestor [AppShimmer].
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = color ?? (isDark ? const Color(0xFF1E2824) : const Color(0xFFE6EBE8));

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: defaultColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// A circular placeholder block that responds to an ancestor [AppShimmer].
class ShimmerCircle extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  const ShimmerCircle({
    super.key,
    required this.size,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = color ?? (isDark ? const Color(0xFF1E2824) : const Color(0xFFE6EBE8));

    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: BoxDecoration(
        color: defaultColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Full-screen shimmer skeleton layout for the Home screen during initial load or pull-to-refresh.
class HomeShimmerView extends StatelessWidget {
  const HomeShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppShimmer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 650;
          final horizontalPadding = isWide ? 32.0 : 20.0;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 110),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Skeleton
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerBox(width: 95, height: 22, borderRadius: 11),
                              SizedBox(height: 8),
                              ShimmerBox(width: 175, height: 30, borderRadius: 8),
                              SizedBox(height: 6),
                              ShimmerBox(width: 130, height: 14, borderRadius: 6),
                            ],
                          ),
                        ),
                        ShimmerBox(width: 42, height: 42, borderRadius: 14),
                        SizedBox(width: 8),
                        ShimmerBox(width: 42, height: 42, borderRadius: 14),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Balance Card Skeleton
                    const ShimmerBox(width: double.infinity, height: 168, borderRadius: 26),
                    const SizedBox(height: 18),

                    // Dual Summary Cards (Income & Expense)
                    const Row(
                      children: [
                        Expanded(child: ShimmerBox(height: 116, borderRadius: 20)),
                        SizedBox(width: 14),
                        Expanded(child: ShimmerBox(height: 116, borderRadius: 20)),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Monthly Budget Progress Card Skeleton
                    const ShimmerBox(width: double.infinity, height: 108, borderRadius: 24),
                    const SizedBox(height: 14),

                    // Subscriptions Quick Banner Skeleton
                    const ShimmerBox(width: double.infinity, height: 60, borderRadius: 18),
                    const SizedBox(height: 28),

                    // Transactions Header Skeleton
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerBox(width: 180, height: 24, borderRadius: 8),
                        ShimmerBox(width: 75, height: 24, borderRadius: 8),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Filter Chips Skeleton
                    const Row(
                      children: [
                        ShimmerBox(width: 58, height: 32, borderRadius: 12),
                        SizedBox(width: 8),
                        ShimmerBox(width: 72, height: 32, borderRadius: 12),
                        SizedBox(width: 8),
                        ShimmerBox(width: 82, height: 32, borderRadius: 12),
                        SizedBox(width: 8),
                        ShimmerBox(width: 78, height: 32, borderRadius: 12),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Grouped Transactions Card Skeleton
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E2824) : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isDark ? const Color(0xFF283631) : const Color(0xFFE9EFEC),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShimmerBox(width: 130, height: 15, borderRadius: 6),
                              ShimmerBox(width: 65, height: 15, borderRadius: 6),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTileSkeleton(),
                          const SizedBox(height: 14),
                          _buildTileSkeleton(),
                          const SizedBox(height: 14),
                          _buildTileSkeleton(),
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

  static Widget _buildTileSkeleton() {
    return const Row(
      children: [
        ShimmerBox(width: 46, height: 46, borderRadius: 15),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: 150, height: 15, borderRadius: 6),
              SizedBox(height: 6),
              ShimmerBox(width: 90, height: 12, borderRadius: 4),
            ],
          ),
        ),
        ShimmerBox(width: 68, height: 18, borderRadius: 6),
      ],
    );
  }
}

/// Shimmer skeleton for Reports & Charts screen
class ReportsShimmerView extends StatelessWidget {
  const ReportsShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 180, height: 26, borderRadius: 8),
                        SizedBox(height: 6),
                        ShimmerBox(width: 120, height: 14, borderRadius: 6),
                      ],
                    ),
                    ShimmerBox(width: 110, height: 38, borderRadius: 14),
                  ],
                ),
                SizedBox(height: 20),

                // Timeframe Selector
                ShimmerBox(width: double.infinity, height: 48, borderRadius: 16),
                SizedBox(height: 20),

                // Main Chart Card Skeleton
                ShimmerBox(width: double.infinity, height: 260, borderRadius: 24),
                SizedBox(height: 20),

                // Summary Stats Card Skeleton
                ShimmerBox(width: double.infinity, height: 130, borderRadius: 22),
                SizedBox(height: 20),

                // Breakdown list skeletons
                ShimmerBox(width: 160, height: 20, borderRadius: 6),
                SizedBox(height: 12),
                ShimmerBox(width: double.infinity, height: 68, borderRadius: 16),
                SizedBox(height: 10),
                ShimmerBox(width: double.infinity, height: 68, borderRadius: 16),
                SizedBox(height: 10),
                ShimmerBox(width: double.infinity, height: 68, borderRadius: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer skeleton for Categories screen
class CategoryShimmerView extends StatelessWidget {
  final bool showHeader;
  const CategoryShimmerView({super.key, this.showHeader = true});

  @override
  Widget build(BuildContext context) {
    final list = ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, _) => const ShimmerBox(
        width: double.infinity,
        height: 72,
        borderRadius: 18,
      ),
    );

    if (!showHeader) {
      return AppShimmer(child: list);
    }

    return AppShimmer(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 80),
            child: Column(
              children: [
                // Toggle Type Skeleton
                const ShimmerBox(width: double.infinity, height: 46, borderRadius: 16),
                const SizedBox(height: 16),
                Expanded(child: list),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer skeleton for Notifications screen
class NotificationShimmerView extends StatelessWidget {
  final bool showHeader;
  const NotificationShimmerView({super.key, this.showHeader = true});

  @override
  Widget build(BuildContext context) {
    final list = ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => const ShimmerBox(
        width: double.infinity,
        height: 82,
        borderRadius: 18,
      ),
    );

    if (!showHeader) {
      return AppShimmer(child: list);
    }

    return AppShimmer(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
            child: Column(
              children: [
                // Filter Tabs Skeleton
                const ShimmerBox(width: double.infinity, height: 42, borderRadius: 14),
                const SizedBox(height: 16),
                Expanded(child: list),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer skeleton for Subscriptions screen
class SubscriptionShimmerView extends StatelessWidget {
  const SubscriptionShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20, 12, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Burn Overview Card
            ShimmerBox(width: double.infinity, height: 170, borderRadius: 26),
            SizedBox(height: 24),
            ShimmerBox(width: 180, height: 16, borderRadius: 6),
            SizedBox(height: 12),
            ShimmerBox(width: double.infinity, height: 76, borderRadius: 18),
            SizedBox(height: 24),
            ShimmerBox(width: 190, height: 16, borderRadius: 6),
            SizedBox(height: 12),
            ShimmerBox(width: double.infinity, height: 86, borderRadius: 20),
            SizedBox(height: 12),
            ShimmerBox(width: double.infinity, height: 86, borderRadius: 20),
            SizedBox(height: 12),
            ShimmerBox(width: double.infinity, height: 86, borderRadius: 20),
          ],
        ),
      ),
    );
  }
}
