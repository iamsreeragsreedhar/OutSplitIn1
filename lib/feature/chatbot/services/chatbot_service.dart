import 'package:intl/intl.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';

class ChatbotService {
  final NumberFormat _currencyFormatter =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

  /// Generates an intelligent, conversational response based on prompt and user transaction data.
  Future<Map<String, dynamic>> generateResponse({
    required String prompt,
    required List<TransactionModel> transactions,
    required bool isConnected,
  }) async {
    // Artificial small delay for natural conversational feel
    await Future.delayed(const Duration(milliseconds: 350));

    final query = prompt.toLowerCase().trim();

    // Calculate live financial statistics
    final income = transactions
        .where((t) => t.type == TransactionType.income)
        .fold<double>(0, (sum, t) => sum + t.amount);

    final expenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold<double>(0, (sum, t) => sum + t.amount);

    final balance = income - expenses;

    // Category breakdown
    final Map<String, double> categoryTotals = {};
    for (final t in transactions.where((t) => t.type == TransactionType.expense)) {
      final catName = t.category.name;
      categoryTotals[catName] = (categoryTotals[catName] ?? 0) + t.amount;
    }

    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topCategory = sortedCategories.isNotEmpty ? sortedCategories.first : null;

    // 1. GREETINGS
    if (_matchesAny(query, ['hi', 'hello', 'hey', 'good morning', 'good evening', 'who are you', 'what can you do'])) {
      return {
        'text': 'Hello! 👋 I am your **OutSplitIn AI Financial Assistant**.\n\n'
            'I can help you analyze your spending, check balances, explore money-saving tips, or guide you through app features like UPI auto-detection and offline auto-sync.\n\n'
            'What would you like to know today?',
        'suggestions': [
          '📊 My financial summary',
          '🍔 Food expenses breakdown',
          '💡 Money saving tips',
          '📶 How offline sync works',
        ],
      };
    }

    // 2. FINANCIAL SUMMARY & BALANCE
    if (_matchesAny(query, ['balance', 'summary', 'total', 'how much money', 'cashflow', 'finances', 'status', 'overview'])) {
      final savingsRate = income > 0 ? (((income - expenses) / income) * 100).clamp(0, 100).toStringAsFixed(1) : '0';
      final topCatStr = topCategory != null
          ? '• **Top Expense Category**: ${topCategory.key.toUpperCase()} (${_currencyFormatter.format(topCategory.value)})\n'
          : '';

      return {
        'text': 'Here is your **live financial snapshot**:\n\n'
            '• **Net Balance**: ${_currencyFormatter.format(balance)}\n'
            '• **Total Income**: ${_currencyFormatter.format(income)}\n'
            '• **Total Expenses**: ${_currencyFormatter.format(expenses)}\n'
            '• **Savings Rate**: $savingsRate%\n'
            '$topCatStr'
            '• **Total Records**: ${transactions.length} transactions\n\n'
            '${balance >= 0 ? "🎉 You have a positive cash flow! Keep it up." : "⚠️ Your expenses currently exceed your income. Consider reviewing non-essential spending."}',
        'suggestions': [
          '🍕 Spending by category',
          '🕒 Recent transactions',
          '💡 Tips to save money',
        ],
      };
    }

    // 3. CATEGORY SPECIFIC QUERIES
    if (_matchesAny(query, ['food', 'dining', 'eating', 'grocery', 'restaurant', 'snack'])) {
      final foodTotal = categoryTotals['food'] ?? 0;
      final foodTxns = transactions.where((t) => t.category == TransactionCategory.food).take(3).toList();

      String recentFood = '';
      if (foodTxns.isNotEmpty) {
        final spendsList = foodTxns.map((t) => '• ${t.title}: ${_currencyFormatter.format(t.amount)}').join('\n');
        recentFood = '\n\n**Recent Food Spends:**\n$spendsList';
      }

      return {
        'text': '🍔 **Food & Dining Expenses**:\n\n'
            '• Total spent: **${_currencyFormatter.format(foodTotal)}**\n'
            '• Share of total spending: ${expenses > 0 ? ((foodTotal / expenses) * 100).toStringAsFixed(1) : 0}%'
            '$recentFood\n\n'
            '💡 *Tip: Cooking at home or meal planning on weekends can reduce food expenses by up to 35%!*',
        'suggestions': [
          '📊 Overall spending',
          '🛍️ Shopping expenses',
          '💡 Budget advice',
        ],
      };
    }

    if (_matchesAny(query, ['shopping', 'clothes', 'purchase', 'amazon', 'flipkart'])) {
      final shoppingTotal = categoryTotals['shopping'] ?? 0;
      return {
        'text': '🛍️ **Shopping Expenses**:\n\n'
            '• Total spent: **${_currencyFormatter.format(shoppingTotal)}**\n'
            '• Share of spending: ${expenses > 0 ? ((shoppingTotal / expenses) * 100).toStringAsFixed(1) : 0}%\n\n'
            '💡 *Tip: Try the 48-hour rule! When you want to buy a non-essential item, wait 48 hours. Most impulse urges fade away.*',
        'suggestions': [
          '📊 My financial summary',
          '🚗 Transport expenses',
        ],
      };
    }

    if (_matchesAny(query, ['transport', 'travel', 'fuel', 'petrol', 'cab', 'uber', 'ola', 'auto'])) {
      final transportTotal = categoryTotals['transport'] ?? 0;
      return {
        'text': '🚗 **Transport & Travel Expenses**:\n\n'
            '• Total spent: **${_currencyFormatter.format(transportTotal)}**\n'
            '• Share of spending: ${expenses > 0 ? ((transportTotal / expenses) * 100).toStringAsFixed(1) : 0}%\n\n'
            '💡 *Tip: Carpooling or choosing public transit for predictable commutes can free up hundreds each month.*',
        'suggestions': [
          '📊 My financial summary',
          '💡 Money saving tips',
        ],
      };
    }

    if (_matchesAny(query, ['categories', 'where is my money going', 'spending', 'spend', 'breakdown', 'expenses'])) {
      if (sortedCategories.isEmpty) {
        return {
          'text': 'You have no expense transactions recorded yet. Tap the **+** button to log your first expense!',
          'suggestions': ['➕ How to add transaction', '⚡ How UPI works'],
        };
      }

      final buffer = StringBuffer('📊 **Expense Breakdown by Category:**\n\n');
      for (final entry in sortedCategories) {
        final pct = expenses > 0 ? ((entry.value / expenses) * 100).toStringAsFixed(1) : '0';
        buffer.writeln('• **${entry.key.toUpperCase()}**: ${_currencyFormatter.format(entry.value)} ($pct%)');
      }

      buffer.writeln('\n💡 Your highest expense is in **${topCategory?.key.toUpperCase()}**.');

      return {
        'text': buffer.toString(),
        'suggestions': [
          '📊 Net balance',
          '💡 How can I reduce spending?',
          '🕒 Recent transactions',
        ],
      };
    }

    // 4. RECENT TRANSACTIONS
    if (_matchesAny(query, ['recent', 'latest', 'history', 'last transaction', 'past'])) {
      if (transactions.isEmpty) {
        return {
          'text': 'No transactions found yet. Add an expense or receive a UPI payment to see it here!',
          'suggestions': ['➕ How to add transaction'],
        };
      }

      final recent = transactions.take(4).toList();
      final buffer = StringBuffer('🕒 **Recent Transactions:**\n\n');
      for (final t in recent) {
        final symbol = t.type == TransactionType.income ? '+' : '-';
        final formattedDate = DateFormat('dd MMM, hh:mm a').format(t.date);
        buffer.writeln('• **${t.title}**: $symbol${_currencyFormatter.format(t.amount)} ($formattedDate)');
      }

      return {
        'text': buffer.toString(),
        'suggestions': [
          '📊 Financial overview',
          '🍕 Food expenses',
        ],
      };
    }

    // 5. OFFLINE SAVING & AUTO-SYNC HELP
    if (_matchesAny(query, ['offline', 'no internet', 'sync', 'connectivity', 'cloud', 'without internet'])) {
      return {
        'text': '📶 **How Offline Saving & Auto-Sync Works in OutSplitIn**:\n\n'
            '1. **Instant Offline Saving**: When you add a transaction without internet (or if your connection suddenly drops), OutSplitIn saves it directly to secure local device storage immediately.\n'
            '2. **Zero Data Loss**: The transaction is marked in a pending sync queue so it\'s never lost or duplicated.\n'
            '3. **Automatic Cloud Sync**: As soon as your device reconnects to Wi-Fi or mobile data, OutSplitIn silently uploads all pending records to Firebase Firestore in the background and shows a confirmation toast!\n\n'
            'Currently: **${isConnected ? "🟢 Connected to Internet" : "🟠 Offline Mode Active"}**',
        'suggestions': [
          '⚡ How UPI auto-detection works',
          '📊 My financial summary',
        ],
      };
    }

    // 6. UPI NOTIFICATION LISTENER
    if (_matchesAny(query, ['upi', 'gpay', 'phonepe', 'paytm', 'auto detect', 'notification', 'sms'])) {
      return {
        'text': '⚡ **How UPI Auto-Detection Works**:\n\n'
            '• OutSplitIn features a **modern notification listener** that detects real-time payment alerts from Google Pay, PhonePe, Paytm, CRED, BHIM, and bank apps.\n'
            '• When a UPI payment alert arrives, the app reads the amount, vendor name, and transaction type (Debit or Credit) automatically.\n'
            '• It requires **no invasive SMS permissions**, keeping your privacy 100% secure!\n'
            '• You can toggle this feature anytime in **Profile ➔ Preferences ➔ UPI Payment Auto-Detect**.',
        'suggestions': [
          '📶 How offline sync works',
          '📊 My financial summary',
          '🎨 How to switch themes',
        ],
      };
    }

    // 7. FINANCIAL ADVICE & TIPS
    if (_matchesAny(query, ['tip', 'advice', 'save', 'budget', '50/30/20', 'rule', 'invest', 'cut'])) {
      return {
        'text': '💡 **Golden Rules for Smart Financial Growth**:\n\n'
            '1. **The 50/30/20 Rule**:\n'
            '   • 50% for Needs (Rent, groceries, utilities)\n'
            '   • 30% for Wants (Dining out, entertainment, shopping)\n'
            '   • 20% for Savings & Investments\n\n'
            '2. **Build an Emergency Fund**: Stash 3-6 months of living expenses in a liquid savings account before aggressive investments.\n\n'
            '3. **The 24-Hour Wait Rule**: Wait 24 hours before making any impulse purchase over ₹1,000.\n\n'
            '4. **Track Micro-Expenses**: Small daily spending (teas, snacks, convenience fees) often add up to ₹3,000–₹5,000 monthly!',
        'suggestions': [
          '📊 My financial summary',
          '🍔 Food expenses breakdown',
        ],
      };
    }

    // 8. THEMES & APP CUSTOMIZATION
    if (_matchesAny(query, ['theme', 'dark', 'light', 'appearance', 'mode', 'color'])) {
      return {
        'text': '🎨 **Appearance & Themes**:\n\n'
            '• OutSplitIn supports **Light Theme**, **Dark Theme**, and **System Default**.\n'
            '• To switch themes, tap **Profile** at the bottom right, select **Appearance**, and pick your preferred mode!\n'
            '• All charts, graphs, and transaction cards automatically adjust their contrast and colors.',
        'suggestions': [
          '📊 My financial summary',
          '📈 Where are my charts?',
        ],
      };
    }

    // 9. REPORTS & CHARTS
    if (_matchesAny(query, ['chart', 'graph', 'report', 'analytics', 'visualize'])) {
      return {
        'text': '📈 **Reports & Charts**:\n\n'
            '• Tap the **Reports** tab in the bottom navigation bar to view interactive graphs.\n'
            '• You can switch between **Weekly**, **Monthly**, and **All-Time** views.\n'
            '• View your income vs expense bar charts and category distribution pie charts with smooth animations!',
        'suggestions': [
          '📊 My financial summary',
          '💡 Money saving tips',
        ],
      };
    }

    // 10. DEFAULT HELPFUL FALLBACK
    return {
      'text': 'I understand you are asking about "$prompt".\n\n'
          'Here are some common things I can answer for you instantly:\n'
          '• Your current net balance and monthly cash flow\n'
          '• Category breakdown (Food, Shopping, Travel, Bills)\n'
          '• How offline saving & auto-sync works\n'
          '• How UPI notification auto-detect works\n'
          '• Money saving tips and budgeting rules\n\n'
          'Try tapping one of the suggestions below!',
      'suggestions': [
        '📊 My financial summary',
        '🍔 Food expenses breakdown',
        '📶 How offline sync works',
        '💡 Money saving tips',
      ],
    };
  }

  bool _matchesAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }
}
