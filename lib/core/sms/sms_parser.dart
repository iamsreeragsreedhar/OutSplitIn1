import 'package:out_split_in/feature/home/model/transation_model.dart';

class SmsParser {
  static TransactionModel? parse({
    required String body,
    required String message,
    required String sender,
    required DateTime date,
    required String smsId,
    required DateTime smsDate,
  }) {
    final text = message.trim();
    if (text.isEmpty) return null;
    final lower = text.toLowerCase();

    // 1. Ignore non-transaction messages
    final ignoredPatterns = <RegExp>[
      RegExp(r'\botp\b|\bone[- ]time password\b|\bverification code\b'),
      RegExp(
        r'\b(promotional|promotion|offer|cashback offer|sale|unsubscribe)\b',
      ),
      RegExp(r'\b(failed|failure|declined|unsuccessful|pending|processing)\b'),
      RegExp(r'\bwill be debited\b|\bwill be credited\b'),
      RegExp(r'\brequest received\b|\bmandate\b|\bautopay registration\b'),
    ];
    if (ignoredPatterns.any((pattern) => pattern.hasMatch(lower))) {
      return null;
    }

    // 2. Explicit credit indicators (money coming INTO user's account)
    final creditPattern = RegExp(
      r'\b(credited|credit|received|deposited|refund|refunded|cashback|reversal)\b'
      r'|\b(?:payment|money|amount)?\s*(?:of\s+.*?\s+)?(?:received|credited|deposited)\b'
      r'|\breceived\s+(?:a\s+)?(?:payment|money)\b'
      r'|\b(?:sent|paid|transferred)\s+(?:you|to\s+you|to\s+your|into\s+your)\b'
      r'|\b(?:transfer|payment)\s+from\b'
      r'|\breceived\s+(?:from|rs|re|inr|₹)\b'
      r'|\b(?:added\s+to\s+(?:your\s+)?(?:account|wallet|balance))\b'
      r'|\bcr\s+(?:to|in|by)\b|\bcredited\s+(?:with|by|to)\b',
      caseSensitive: false,
    );

    // 3. Explicit debit indicators (money going OUT of user's account)
    // Avoid matching 'payment' or 'paid' when preceded or followed by credit phrases like 'payment received'
    final debitPattern = RegExp(
      r'\b(debited|debit|spent|withdrawn|withdrawal|purchase|bought|dr)\b'
      r'|\bpaid\b(?!\s+(?:you|to\s+you)\b)'
      r'|\bpayment\b(?!\s*:?\s*(?:received|credited|from)\b)(?![^\n]*?\breceived\b)'
      r'|\b(?:sent|transferred)\b(?!\s+(?:you|to\s+you|to\s+your|into\s+your)\b)'
      r'|\bdr\s+(?:from|by|for|to)\b|\bdebited\s+(?:from|by|for|to)\b'
      r'|\btransaction\s+(?:of\s+.*?\s+)?to\s+(?!you\b|your\b)'
      r'|\b(?:transfer|transferred|payment|sent|paid)\s+to\s+(?!you\b|your\b)',
      caseSensitive: false,
    );

    final hasCredit = creditPattern.hasMatch(lower);
    final hasDebit = debitPattern.hasMatch(lower);

    if (!hasCredit && !hasDebit) return null;

    final bool isCredit;
    if (hasCredit && !hasDebit) {
      isCredit = true;
    } else if (hasDebit && !hasCredit) {
      isCredit = false;
    } else {
      // Both matched: check specifically which account was affected
      final isUserAccountDebited = RegExp(
        r'\b(?:your\s+)?(?:a/c|acct|account)\b[^\n.,;]*?\b(?:debited|withdrawn|spent|dr)\b'
        r'|\b(?:debited|withdrawn|dr)\b.*?\b(?:from|by)\b.*?\b(?:a/c|acct|account|your)\b'
        r'|\bdebited\s+(?:from|by|for)\b'
        r'|\bcredited\s+to\s+(?!your\b|you\b)[a-z]+',
        caseSensitive: false,
      ).hasMatch(lower);

      final isUserAccountCredited = RegExp(
        r'\b(?:your\s+)?(?:a/c|acct|account)\b[^\n.,;]*?\b(?:credited|received|deposited|cr)\b'
        r'|\b(?:credited|deposited|cr)\b.*?\b(?:to|in|into|by)\b.*?\b(?:a/c|acct|account|your)\b'
        r'|\bcredited\s+(?:to\s+(?:your|a/c|acct)|in|into|by|with)\b',
        caseSensitive: false,
      ).hasMatch(lower);

      if (isUserAccountDebited && !isUserAccountCredited) {
        isCredit = false;
      } else if (isUserAccountCredited && !isUserAccountDebited) {
        isCredit = true;
      } else {
        final isCreditPhrase = RegExp(
          r'\b(?:payment|money|amount)?\s*(?:of\s+.*?\s+)?(?:received|credited|deposited)\b'
          r'|\breceived\b'
          r'|\b(?:credited|deposited|refund|refunded|cashback|reversal)\b'
          r'|\b(?:sent|paid|transferred)\s+(?:you|to\s+you|to\s+your|into\s+your)\b'
          r'|\b(?:transfer|payment)\s+from\b',
          caseSensitive: false,
        ).hasMatch(lower);

        final isExplicitDebitPhrase = RegExp(
          r'\b(?:debited|withdrawn|spent)\b'
          r'|\bpaid\s+(?:to\s+(?!you\b|your\b)|for|at)\b'
          r'|\b(?:sent|transferred)\s+to\s+(?!you\b|your\b)'
          r'|\bpayment\s+to\s+(?!you\b|your\b)',
          caseSensitive: false,
        ).hasMatch(lower);

        if (isCreditPhrase && !isExplicitDebitPhrase) {
          isCredit = true;
        } else if (isExplicitDebitPhrase && !isCreditPhrase) {
          isCredit = false;
        } else {
          final creditIndex = creditPattern.firstMatch(lower)?.start ?? 999999;
          final debitIndex = debitPattern.firstMatch(lower)?.start ?? 999999;
          isCredit = creditIndex < debitIndex;
        }
      }
    }

    final isDebit = !isCredit;

    // 4. Require a successful transaction indicator
    final successPattern = RegExp(
      r'\b(successful|succeeded|completed|transaction of|debited|credited|paid|spent|received|deposited|purchase|sent|transferred|dr|cr)\b'
      r'|\bwas successful\b',
    );

    if (!successPattern.hasMatch(lower)) return null;

    final amount = _extractAmount(message);
    if (amount == null) return null;

    final parsedDate = _extractDate(text) ?? smsDate;
    final party = _detectParty(text, sender, isCredit);
    final category = _detectCategory(text, party, isCredit);

    return TransactionModel(
      id: '${parsedDate.millisecondsSinceEpoch}_$amount',
      type: isDebit ? TransactionType.expense : TransactionType.income,
      amount: amount,
      title: party,
      source: _detectBank(sender, message),
      sender: sender,
      date: parsedDate,
      autoDetected: true,
      category: category,
      smsId: 'sms_$smsId',
    );
  }

  static DateTime? _extractDate(String text) {
    final patterns = <RegExp>[
      RegExp(r'\b(\d{2})[/-](\d{2})[/-](\d{4})\b'),
      RegExp(r'\b(\d{4})-(\d{2})-(\d{2})\b'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match == null) continue;

      try {
        late final int year;
        late final int month;
        late final int day;

        if (pattern == patterns[1]) {
          year = int.parse(match.group(1)!);
          month = int.parse(match.group(2)!);
          day = int.parse(match.group(3)!);
        } else {
          day = int.parse(match.group(1)!);
          month = int.parse(match.group(2)!);
          year = int.parse(match.group(3)!);
        }

        final result = DateTime(year, month, day);
        if (result.year == year && result.month == month && result.day == day) {
          return result;
        }
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  static double? _extractAmount(String text) {
    final patterns = [
      // 1. Currency symbol or code followed by amount (Rs. 1, Re. 1.00, ₹100, INR 50, Rupees 10)
      RegExp(
        r'(?:rs\.?|re\.?|inr|₹|rupees?)\s*([\d,]+(?:\.\d{1,2})?)',
        caseSensitive: false,
      ),
      // 2. Action verb with optional preposition followed by amount (debited by 1.00, paid 1)
      RegExp(
        r'\b(?:debited|credited|paid|spent|sent|received)\s+(?:by|for|of)?\s*(?:rs\.?|re\.?|inr|₹|rupees?)?\s*([\d,]+(?:\.\d{1,2})?)',
        caseSensitive: false,
      ),
      // 3. Amount followed by currency symbol or code (100 Rs, 1 Re, 50 INR, 100/-)
      RegExp(
        r'([\d,]+(?:\.\d{1,2})?)\s*(?:rs\.?|re\.?|inr|rupees?|\/-)',
        caseSensitive: false,
      ),
    ];

    for (final regex in patterns) {
      final match = regex.firstMatch(text);
      if (match != null) {
        final value = match.group(1)!.replaceAll(',', '');
        final parsed = double.tryParse(value);
        if (parsed != null && parsed > 0) {
          return parsed;
        }
      }
    }

    return null;
  }

  static const Set<String> _invalidNames = {
    'view', 'details', 'check', 'see', 'open', 'track', 'your', 'account',
    'a/c', 'acct', 'vpa', 'upi', 'bank', 'balance', 'card', 'transaction',
    'ref', 'statement', 'app', 'click', 'tap', 'here', 'info', 'notification',
    'sms', 'alert', 'message', 'more', 'pay', 'paid', 'sent', 'received',
    'credit', 'credited', 'debit', 'debited', 'successful', 'success',
    'transfer', 'transferred', 'payment', 'money', 'help', 'now', 'today',
    'amount', 'available', 'inr', 'rs', 're', 'rupee', 'rupees', 'to', 'from',
    'with', 'via', 'using', 'link', 'clear', 'total', 'closing', 'opening',
    'was', 'is', 'completed',
  };

  static bool _isValidPartyName(String name) {
    final alphanumeric = name.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), ' ').trim();
    if (alphanumeric.isEmpty || alphanumeric.length < 2) return false;

    final lower = alphanumeric.toLowerCase();
    if (lower.startsWith('view') ||
        lower.startsWith('tap') ||
        lower.startsWith('click') ||
        lower.startsWith('check') ||
        lower.startsWith('see') ||
        lower.startsWith('open')) {
      return false;
    }

    final words = lower.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return false;

    final allStopWords = words.every((w) => _invalidNames.contains(w));
    if (allStopWords) return false;

    return true;
  }

  static String _cleanPartyName(String name) {
    final cleaned = name
        .replaceAll(RegExp(r'^[\s\-_.:;]+|[\s\-_.:;]+$'), '')
        .replaceAll(
          RegExp(
            r'\s+(?:on|ref|via|to|from|for|at|tap|view|with|the)$',
            caseSensitive: false,
          ),
          '',
        )
        .replaceAll(
          RegExp(
            r'^(?:view|tap|click|see|check|open)\s+',
            caseSensitive: false,
          ),
          '',
        )
        .replaceAll(RegExp(r'[\-_]{2,}'), '')
        .trim();

    if (!_isValidPartyName(cleaned)) return '';

    return cleaned.split(' ').where((w) => w.isNotEmpty).map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + (word.length > 1 ? word.substring(1).toLowerCase() : '');
    }).join(' ');
  }

  static String _detectParty(String text, String sender, bool isCredit) {
    final lower = text.toLowerCase();

    // 1. Check known brand merchants using word boundaries
    final merchants = <String, String>{
      'zomato': 'Zomato',
      'swiggy': 'Swiggy',
      'amazon': 'Amazon',
      'flipkart': 'Flipkart',
      'myntra': 'Myntra',
      'blinkit': 'Blinkit',
      'zepto': 'Zepto',
      'bigbasket': 'BigBasket',
      'indian oil': 'Indian Oil',
      'bharat petroleum': 'Bharat Petroleum',
      'hpcl': 'HPCL',
      'uber': 'Uber',
      'ola': 'Ola',
      'rapido': 'Rapido',
      'netflix': 'Netflix',
      'spotify': 'Spotify',
      'hotstar': 'Disney+ Hotstar',
      'prime video': 'Prime Video',
      'airtel': 'Airtel',
      'jio': 'Jio',
      'vi': 'Vodafone Idea',
      'bsnl': 'BSNL',
      'starbucks': 'Starbucks',
      'mcdonald': "McDonald's",
      'kfc': 'KFC',
      'domino': "Domino's",
      'pizza hut': 'Pizza Hut',
      'google pay': 'Google Pay',
      'gpay': 'Google Pay',
      'phonepe': 'PhonePe',
      'paytm': 'Paytm',
      'cred': 'CRED',
    };

    for (final entry in merchants.entries) {
      final pattern = RegExp(r'\b' + RegExp.escape(entry.key) + r'\b');
      if (pattern.hasMatch(lower)) return entry.value;
    }

    if (isCredit) {
      // Money received: extract who SENT the money (e.g. "from Geetha" or "Geetha sent you")
      final sentYouMatch = RegExp(
        r'(?:^|[.,\n;])\s*([A-Za-z][A-Za-z0-9 .&_-]{1,30}?)\s+(?:sent|paid|transferred)\s+(?:you|to\s+you)',
        caseSensitive: false,
      ).firstMatch(text);
      if (sentYouMatch != null) {
        final candidate = sentYouMatch.group(1)!.trim();
        if (_isValidPartyName(candidate)) {
          final cleaned = _cleanPartyName(candidate);
          if (cleaned.isNotEmpty) return cleaned;
        }
      }

      final fromMatch = RegExp(
        r'\bfrom\s+([A-Za-z][A-Za-z0-9 .&_-]{1,35}?)(?:\s+(?:on|ref|via|through|using|to|tap|click|view|with|in)\b|[.,;\n]|$)',
        caseSensitive: false,
      ).firstMatch(text);
      if (fromMatch != null) {
        final candidate = fromMatch.group(1)!.trim();
        if (_isValidPartyName(candidate)) {
          final cleaned = _cleanPartyName(candidate);
          if (cleaned.isNotEmpty) return cleaned;
        }
      }

      // Check UPI standard reference format: UPI/123456789012/Geetha
      final upiMatch = RegExp(
        r'upi/(?:p2[ap]/)?\d+/([a-zA-Z][a-zA-Z0-9 .&_-]{1,30})',
        caseSensitive: false,
      ).firstMatch(text);
      if (upiMatch != null) {
        final candidate = upiMatch.group(1)!.trim();
        if (_isValidPartyName(candidate)) {
          final cleaned = _cleanPartyName(candidate);
          if (cleaned.isNotEmpty) return cleaned;
        }
      }

      if (sender.isNotEmpty &&
          sender != 'UPI Payment' &&
          sender != 'SMS Alert' &&
          _isValidPartyName(sender)) {
        final cleaned = _cleanPartyName(sender);
        if (cleaned.isNotEmpty) return cleaned;
      }

      final bank = _detectBank(sender, text);
      if (bank.isNotEmpty && bank != sender && _isValidPartyName(bank)) {
        return bank;
      }

      return 'Received Payment';
    } else {
      // Money sent / expense: extract who was PAID (after 'to' or 'at')
      final toMatch = RegExp(
        r'\b(?:to|at)\s+([A-Za-z][A-Za-z0-9 .&_-]{1,35}?)(?:\s+(?:on|ref|via|through|using|tap|click|view|with|from|was|is|for|dated|by|completed)\b|[.,;\n]|$)',
        caseSensitive: false,
      ).firstMatch(text);
      if (toMatch != null) {
        final candidate = toMatch.group(1)!.trim();
        if (_isValidPartyName(candidate)) {
          final cleaned = _cleanPartyName(candidate);
          if (cleaned.isNotEmpty) return cleaned;
        }
      }

      // Check UPI standard reference format: UPI/123456789012/Geetha
      final upiMatch = RegExp(
        r'upi/(?:p2[ap]/)?\d+/([a-zA-Z][a-zA-Z0-9 .&_-]{1,30})',
        caseSensitive: false,
      ).firstMatch(text);
      if (upiMatch != null) {
        final candidate = upiMatch.group(1)!.trim();
        if (_isValidPartyName(candidate)) {
          final cleaned = _cleanPartyName(candidate);
          if (cleaned.isNotEmpty) return cleaned;
        }
      }

      if (sender.isNotEmpty &&
          sender != 'UPI Payment' &&
          sender != 'SMS Alert' &&
          _isValidPartyName(sender)) {
        final cleaned = _cleanPartyName(sender);
        if (cleaned.isNotEmpty) return cleaned;
      }

      final bank = _detectBank(sender, text);
      if (bank.isNotEmpty && bank != sender && _isValidPartyName(bank)) {
        return bank;
      }

      return 'Payment';
    }
  }

  static TransactionCategory _detectCategory(
    String text,
    String party,
    bool isCredit,
  ) {
    final value = '${text.toLowerCase()} ${party.toLowerCase()}';

    if (isCredit) {
      if (RegExp(r'\bsalary\b|\bpayroll\b|\bstipend\b').hasMatch(value)) {
        return TransactionCategory.salary;
      }
      return TransactionCategory.transfer;
    }

    if (RegExp(
      r'zomato|swiggy|restaurant|food|cafe|coffee|starbucks|tea|bakery|dominos|pizza|dine|dining|burger|kfc|mcdonald|grocery|groceries|supermarket|blinkit|zepto|bigbasket|dmart|vegetables|fruits|milk|dairy',
    ).hasMatch(value)) {
      return TransactionCategory.food;
    }

    if (RegExp(
      r'amazon|flipkart|shopping|myntra|retail|clothing|apparel|mall',
    ).hasMatch(value)) {
      return TransactionCategory.shopping;
    }

    if (RegExp(
      r'uber|ola|rapido|fuel|petrol|diesel|indian oil|bharat petroleum|hpcl|metro|irctc|train|bus|flight|toll|fastag',
    ).hasMatch(value)) {
      return TransactionCategory.transport;
    }

    if (RegExp(
      r'electricity|water bill|broadband|wifi|recharge|utility|bill|dth|gas bill|bescom|tneb|airtel|jio',
    ).hasMatch(value)) {
      return TransactionCategory.bills;
    }

    if (RegExp(
      r'hospital|pharmacy|medical|clinic|doctor|medicine|apollo|1mg|practo',
    ).hasMatch(value)) {
      return TransactionCategory.health;
    }

    if (RegExp(
      r'netflix|spotify|hotstar|movie|cinema|gaming|pvr|inox|theatre|steam|playstation',
    ).hasMatch(value)) {
      return TransactionCategory.entertainment;
    }

    if (RegExp(
      r'\bupi\b|\btransfer\b|\btransferred\b|\bsent\b|\bpaid\b|\bimps\b|\bneft\b|\brtgs\b',
    ).hasMatch(value)) {
      return TransactionCategory.transfer;
    }

    return TransactionCategory.other;
  }

  static String _detectBank(String sender, String text) {
    final value = '$sender $text'.toLowerCase();

    const banks = <String, String>{
      'sbi': 'SBI',
      'state bank': 'SBI',
      'hdfc': 'HDFC',
      'icici': 'ICICI',
      'axis': 'Axis Bank',
      'federal': 'Federal Bank',
      'kotak': 'Kotak',
      'canara': 'Canara Bank',
      'phonepe': 'PhonePe',
      'google pay': 'Google Pay',
      'gpay': 'Google Pay',
      'paytm': 'Paytm',
    };

    for (final entry in banks.entries) {
      if (value.contains(entry.key)) return entry.value;
    }

    return sender;
  }
}
