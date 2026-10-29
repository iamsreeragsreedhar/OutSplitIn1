import 'package:flutter/material.dart';

class ChatQuickSuggestionChips extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSelect;
  final bool isDark;

  const ChatQuickSuggestionChips({
    super.key,
    required this.suggestions,
    required this.onSelect,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return InkWell(
            onTap: () => onSelect(suggestion),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E352C).withValues(alpha: 0.7)
                    : const Color(0xFFE8F8F2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF0BA874).withValues(alpha: 0.35)
                      : const Color(0xFF0BA874).withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  suggestion,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF5BE2B5)
                        : const Color(0xFF087F59),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
