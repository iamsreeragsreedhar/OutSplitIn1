import 'package:flutter/material.dart';

class CategoryEmptyView extends StatelessWidget {
  final String message;

  const CategoryEmptyView({
    super.key,
    this.message = 'No categories found in this section.',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E2824)
                    : const Color(0xFFE8F8F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.category_outlined,
                size: 38,
                color: Color(0xFF0BA874),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Categories',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF18231F),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? const Color(0xFFA1AFA9) : const Color(0xFF78837F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
