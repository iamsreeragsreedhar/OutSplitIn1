import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
    Locale('ml'),
    Locale('ta'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'OutSplitIn',
      'goodDay': 'Good day',
      'keepTrackCashflow': 'Keep track of your cashflow',
      'totalBalance': 'Total Balance',
      'income': 'Income',
      'expenses': 'Expenses',
      'recentTransactions': 'Recent transactions',
      'records': 'records',
      'noTransactions': 'No transactions yet',
      'noTransactionsSubtitle': 'Add an expense or enable auto-sync to get started.',
      'monthlyBudget': 'Monthly Budget',
      'spentThisMonth': 'Spent this month',
      'remaining': 'Remaining',
      'overBudget': 'Over budget',
      'setBudget': 'Set Budget',
      'editBudget': 'Edit Budget',
      'budgetLimit': 'Budget Limit',
      'saveBudget': 'Save Budget',
      'enterBudgetAmount': 'Enter monthly budget amount',
      'budgetUpdated': 'Monthly budget updated successfully',
      'filterAll': 'All',
      'filterToday': 'Today',
      'filterYesterday': 'Yesterday',
      'filterThisWeek': 'This Week',
      'filterThisMonth': 'This Month',
      'filterExpense': 'Expenses',
      'filterIncome': 'Income',
      'todayHeader': 'Today',
      'yesterdayHeader': 'Yesterday',
      'exportExcel': 'Export Excel',
      'exportData': 'Export to Excel / CSV',
      'exportSubtitle': 'Download full transaction history as a spreadsheet',
      'exportSuccess': 'Transactions spreadsheet exported successfully',
      'exportFailed': 'Failed to export spreadsheet',
      'profile': 'Profile',
      'preferences': 'PREFERENCES',
      'accountAndSupport': 'ACCOUNT & SUPPORT',
      'upiAutoDetect': 'UPI Payment Auto-Detect',
      'upiAutoDetectSubtitle': 'Auto-record from GPay, PhonePe, Paytm & Bank alerts',
      'categories': 'Categories',
      'categoriesSubtitle': 'View and manage spending categories',
      'notifications': 'Notifications',
      'notificationsSubtitle': 'Alerts and transaction summaries',
      'appearance': 'Appearance',
      'appearanceSubtitle': 'Switch between light and dark themes',
      'language': 'Language',
      'languageSubtitle': 'Choose app display language',
      'selectLanguage': 'Select Language',
      'aiAssistant': 'AI Financial Assistant',
      'aiAssistantSubtitle': 'Instant spending insights & 24/7 help',
      'privacySecurity': 'Privacy & Security',
      'privacySecuritySubtitle': 'Manage your data and encryption',
      'logout': 'Log Out',
      'logoutConfirm': 'Are you sure you want to log out of OutSplitIn?',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'close': 'Close',
      'catFood': 'Food',
      'catGrocery': 'Grocery',
      'catShopping': 'Shopping',
      'catTransport': 'Transport',
      'catBills': 'Bills',
      'catEntertainment': 'Entertainment',
      'catHealth': 'Health',
      'catSalary': 'Salary',
      'catFreelance': 'Freelance',
      'catTransfer': 'Transfer',
      'catOther': 'Other',
    },
    'hi': {
      'appName': 'OutSplitIn',
      'goodDay': 'नमस्ते',
      'keepTrackCashflow': 'अपने खर्चों और आय पर नज़र रखें',
      'totalBalance': 'कुल शेष राशि',
      'income': 'आय',
      'expenses': 'व्यय / खर्च',
      'recentTransactions': 'हाल के लेन-देन',
      'records': 'रिकॉर्ड',
      'noTransactions': 'कोई लेन-देन नहीं मिला',
      'noTransactionsSubtitle': 'शुरू करने के लिए एक खर्च जोड़ें या ऑटो-डिटेक्ट चालू करें।',
      'monthlyBudget': 'मासिक बजट',
      'spentThisMonth': 'इस महीने का खर्च',
      'remaining': 'शेष बचा',
      'overBudget': 'बजट से अधिक',
      'setBudget': 'बजट सेट करें',
      'editBudget': 'बजट बदलें',
      'budgetLimit': 'बजट सीमा',
      'saveBudget': 'बजट सहेजें',
      'enterBudgetAmount': 'मासिक बजट राशि दर्ज करें',
      'budgetUpdated': 'मासिक बजट सफलतापूर्वक अपडेट किया गया',
      'filterAll': 'सभी',
      'filterToday': 'आज',
      'filterYesterday': 'कल',
      'filterThisWeek': 'इस सप्ताह',
      'filterThisMonth': 'इस महीने',
      'filterExpense': 'खर्च',
      'filterIncome': 'आय',
      'todayHeader': 'आज',
      'yesterdayHeader': 'कल',
      'exportExcel': 'एक्सेल निर्यात',
      'exportData': 'एक्सेल / सीएसवी में निर्यात करें',
      'exportSubtitle': 'स्प्रेडशीट के रूप में पूरा लेन-देन डाउनलोड करें',
      'exportSuccess': 'लेन-देन स्प्रेडशीट सफलतापूर्वक निर्यात की गई',
      'exportFailed': 'स्प्रेडशीट निर्यात करने में विफल',
      'profile': 'प्रोफ़ाइल',
      'preferences': 'प्राथमिकताएँ',
      'accountAndSupport': 'खाता एवं सहायता',
      'upiAutoDetect': 'यूपीआई ऑटो-डिटेक्ट',
      'upiAutoDetectSubtitle': 'GPay, PhonePe, Paytm और बैंक अलर्ट से ऑटो-सेव करें',
      'categories': 'श्रेणियाँ',
      'categoriesSubtitle': 'खर्च की श्रेणियों का प्रबंधन करें',
      'notifications': 'सूचनाएं',
      'notificationsSubtitle': 'अलर्ट और सारांश',
      'appearance': 'थीम और दिखावट',
      'appearanceSubtitle': 'लाइट और डार्क थीम बदलें',
      'language': 'भाषा (Language)',
      'languageSubtitle': 'ऐप की भाषा चुनें',
      'selectLanguage': 'भाषा चुनें',
      'aiAssistant': 'एआई वित्तीय सहायक',
      'aiAssistantSubtitle': 'त्वरित बचत सुझाव और सहायता',
      'privacySecurity': 'गोपनीयता और सुरक्षा',
      'privacySecuritySubtitle': 'अपना डेटा और सुरक्षा प्रबंधित करें',
      'logout': 'लॉग आउट',
      'logoutConfirm': 'क्या आप वाकई OutSplitIn से लॉग आउट करना चाहते हैं?',
      'cancel': 'रद्द करें',
      'save': 'सहेजें',
      'delete': 'हटाएं',
      'edit': 'संपादित करें',
      'close': 'बंद करें',
      'catFood': 'भोजन',
      'catGrocery': 'किराना',
      'catShopping': 'खरीदारी',
      'catTransport': 'यात्रा / ईंधन',
      'catBills': 'बिल भुगतान',
      'catEntertainment': 'मनोरंजन',
      'catHealth': 'स्वास्थ्य',
      'catSalary': 'वेतन',
      'catFreelance': 'फ्रीलांस',
      'catTransfer': 'ट्रांसफर',
      'catOther': 'अन्य',
    },
    'ml': {
      'appName': 'OutSplitIn',
      'goodDay': 'നമസ്കാരം',
      'keepTrackCashflow': 'നിങ്ങളുടെ വരവുചിലവുകൾ കൃത്യമായി സൂക്ഷിക്കുക',
      'totalBalance': 'ആകെ ബാക്കി തുക',
      'income': 'വരുമാനം',
      'expenses': 'ചിലവുകൾ',
      'recentTransactions': 'സമീപകാല ഇടപാടുകൾ',
      'records': 'ഇടപാടുകൾ',
      'noTransactions': 'ഇടപാടുകൾ ലഭ്യമല്ല',
      'noTransactionsSubtitle': 'ഒരു ചിലവ് രേഖപ്പെടുത്തുകയോ ഓട്ടോ സിങ്ക് ഓൺ ചെയ്യുകയോ ചെയ്യുക.',
      'monthlyBudget': 'പ്രതിമാസ ബജറ്റ്',
      'spentThisMonth': 'ഈ മാസം ചിലവായത്',
      'remaining': 'ബാക്കി',
      'overBudget': 'ബജറ്റ് കവിഞ്ഞു',
      'setBudget': 'ബജറ്റ് നിശ്ചയിക്കുക',
      'editBudget': 'ബജറ്റ് മാറ്റുക',
      'budgetLimit': 'ബജറ്റ് പരിധി',
      'saveBudget': 'സേവ് ചെയ്യുക',
      'enterBudgetAmount': 'പ്രതിമാസ ബജറ്റ് തുക നൽകുക',
      'budgetUpdated': 'പ്രതിമാസ ബജറ്റ് വിജയകരമായി മാറ്റി',
      'filterAll': 'എല്ലാം',
      'filterToday': 'ഇന്ന്',
      'filterYesterday': 'ഇന്നലെ',
      'filterThisWeek': 'ഈ ആഴ്ച',
      'filterThisMonth': 'ഈ മാസം',
      'filterExpense': 'ചിലവ്',
      'filterIncome': 'വരവ്',
      'todayHeader': 'ഇന്ന്',
      'yesterdayHeader': 'ഇന്നലെ',
      'exportExcel': 'എക്സൽ കയറ്റുമതി',
      'exportData': 'എക്സൽ / CSV ആയി എക്സ്പോർട്ട് ചെയ്യുക',
      'exportSubtitle': 'മുഴുവൻ ഇടപാടുകളും സ്പ്രെഡ്ഷീറ്റായി ഡൗൺലോഡ് ചെയ്യുക',
      'exportSuccess': 'എക്സൽ ഫയൽ വിജയകരമായി തയ്യാറാക്കി',
      'exportFailed': 'എക്സൽ ഫയൽ നിർമ്മിക്കാൻ കഴിഞ്ഞില്ല',
      'profile': 'പ്രൊഫൈൽ',
      'preferences': 'മുൻഗണനകൾ',
      'accountAndSupport': 'സഹായവും വിവരങ്ങളും',
      'upiAutoDetect': 'യുപിഐ ഓട്ടോ ഡിറ്റക്റ്റ്',
      'upiAutoDetectSubtitle': 'GPay, PhonePe, ബാങ്ക് മെസേജുകളിൽ നിന്നും സ്വയം രേഖപ്പെടുത്തുന്നു',
      'categories': 'വിഭാഗങ്ങൾ',
      'categoriesSubtitle': 'ചിലവ് വിഭാഗങ്ങൾ കാണുക',
      'notifications': 'അറിയിപ്പുകൾ',
      'notificationsSubtitle': 'അലേർട്ടുകളും വിവരങ്ങളും',
      'appearance': 'തീം തെരഞ്ഞെടുക്കുക',
      'appearanceSubtitle': 'ലൈറ്റ് / ഡാർക്ക് തീമുകൾ മാറ്റുക',
      'language': 'ഭാഷ (Language)',
      'languageSubtitle': 'ആപ്പ് പ്രദർശന ഭാഷ തെരഞ്ഞെടുക്കുക',
      'selectLanguage': 'ഭാഷ തെരഞ്ഞെടുക്കുക',
      'aiAssistant': 'എഐ ഫിനാൻഷ്യൽ അസിസ്റ്റന്റ്',
      'aiAssistantSubtitle': 'ചിലവുചുരുക്കൽ നിർദ്ദേശങ്ങളും സഹായവും',
      'privacySecurity': 'സ്വകാര്യതയും സുരക്ഷയും',
      'privacySecuritySubtitle': 'നിങ്ങളുടെ ഡാറ്റാ സുരക്ഷ',
      'logout': 'ലോഗ് ഔട്ട്',
      'logoutConfirm': 'നിങ്ങൾ തീർച്ചയായും ലോഗ് ഔട്ട് ചെയ്യാൻ ആഗ്രഹിക്കുന്നുണ്ടോ?',
      'cancel': 'റദ്ദാക്കുക',
      'save': 'സേവ് ചെയ്യുക',
      'delete': 'ഡിലീറ്റ് ചെയ്യുക',
      'edit': 'മാറ്റുക',
      'close': 'അടയ്ക്കുക',
      'catFood': 'ഭക്ഷണം',
      'catGrocery': 'പലചരക്ക്',
      'catShopping': 'ഷോപ്പിംഗ്',
      'catTransport': 'യാത്ര / ഇന്ധനം',
      'catBills': 'ബില്ലുകൾ',
      'catEntertainment': 'വിനോദം',
      'catHealth': 'ആരോഗ്യം',
      'catSalary': 'ശമ്പളം',
      'catFreelance': 'ഫ്രീലാൻസ്',
      'catTransfer': 'കൈമാറ്റം',
      'catOther': 'മറ്റുള്ളവ',
    },
    'ta': {
      'appName': 'OutSplitIn',
      'goodDay': 'வணக்கம்',
      'keepTrackCashflow': 'உங்கள் வரவு செலவுகளைக் கண்காணிக்கவும்',
      'totalBalance': 'மொத்த இருப்பு',
      'income': 'வருமானம்',
      'expenses': 'செலவுகள்',
      'recentTransactions': 'சமீபத்திய பரிவர்த்தனைகள்',
      'records': 'பதிவுகள்',
      'noTransactions': 'பரிவர்த்தனைகள் இல்லை',
      'noTransactionsSubtitle': 'செலவைச் சேர்க்கவும் அல்லது தானியங்கு ஒத்திசைவை இயக்கவும்.',
      'monthlyBudget': 'மாதாந்திர பட்ஜெட்',
      'spentThisMonth': 'இந்த மாதம் செலவானது',
      'remaining': 'மீதி',
      'overBudget': 'பட்ஜெட்டை தாண்டியது',
      'setBudget': 'பட்ஜெட் அமைக்கவும்',
      'editBudget': 'பட்ஜெட்டை மாற்றவும்',
      'budgetLimit': 'பட்ஜெட் வரம்பு',
      'saveBudget': 'சேமிக்கவும்',
      'enterBudgetAmount': 'பட்ஜெட் தொகையை உள்ளிடவும்',
      'budgetUpdated': 'பட்ஜெட் வெற்றிகரமாக மாற்றப்பட்டது',
      'filterAll': 'அனைத்தும்',
      'filterToday': 'இன்று',
      'filterYesterday': 'நேற்று',
      'filterThisWeek': 'இந்த வாரம்',
      'filterThisMonth': 'இந்த மாதம்',
      'filterExpense': 'செலவு',
      'filterIncome': 'வருமானம்',
      'todayHeader': 'இன்று',
      'yesterdayHeader': 'நேற்று',
      'exportExcel': 'எக்செல் ஏற்றுமதி',
      'exportData': 'எக்செல் / CSV ஆக ஏற்றுமதி செய்யவும்',
      'exportSubtitle': 'பரிவர்த்தனை வரலாற்றை தரவிறக்கவும்',
      'exportSuccess': 'வெற்றிகரமாக ஏற்றுமதி செய்யப்பட்டது',
      'exportFailed': 'ஏற்றுமதி செய்ய முடியவில்லை',
      'profile': 'சுயவிவரம்',
      'preferences': 'விருப்பங்கள்',
      'accountAndSupport': 'கணக்கு & ஆதரவு',
      'upiAutoDetect': 'UPI தானியங்கி கண்டறிதல்',
      'upiAutoDetectSubtitle': 'GPay, PhonePe, வங்கி விழிப்பூட்டல்களிலிருந்து தானாகப் பதிவுசெய்கிறது',
      'categories': 'வகைகள்',
      'categoriesSubtitle': 'செலவு வகைகளை நிர்வகிக்கவும்',
      'notifications': 'அறிவிப்புகள்',
      'notificationsSubtitle': 'எச்சரிக்கைகள் மற்றும் சுருக்கங்கள்',
      'appearance': 'தோற்றம்',
      'appearanceSubtitle': 'ஒளி மற்றும் இருண்ட தீம்களுக்கு இடையில் மாறவும்',
      'language': 'மொழி (Language)',
      'languageSubtitle': 'பயன்பாட்டு மொழியைத் தேர்ந்தெடுக்கவும்',
      'selectLanguage': 'மொழியைத் தேர்ந்தெடுக்கவும்',
      'aiAssistant': 'AI நிதி உதவியாளர்',
      'aiAssistantSubtitle': 'சேமிப்பு ஆலோசனைகள் மற்றும் உதவி',
      'privacySecurity': 'தனியுரிமை மற்றும் பாதுகாப்பு',
      'privacySecuritySubtitle': 'தரவு பாதுகாப்பு',
      'logout': 'வெளியேறு',
      'logoutConfirm': 'நிச்சயமாக வெளியேற விரும்புகிறீர்களா?',
      'cancel': 'ரத்துசெய்',
      'save': 'சேமி',
      'delete': 'நீக்கு',
      'edit': 'திருத்து',
      'close': 'மூடு',
      'catFood': 'உணவு',
      'catGrocery': 'மளிகை',
      'catShopping': 'ஷாப்பிங்',
      'catTransport': 'போக்குவரத்து',
      'catBills': 'பில்கள்',
      'catEntertainment': 'பொழுதுபோக்கு',
      'catHealth': 'மருத்துவம்',
      'catSalary': 'சம்பளம்',
      'catFreelance': 'ஃப்ரீலான்ஸ்',
      'catTransfer': 'பரிமாற்றம்',
      'catOther': 'மற்றவை',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  String get appName => translate('appName');
  String get goodDay => translate('goodDay');
  String get keepTrackCashflow => translate('keepTrackCashflow');
  String get totalBalance => translate('totalBalance');
  String get income => translate('income');
  String get expenses => translate('expenses');
  String get recentTransactions => translate('recentTransactions');
  String get records => translate('records');
  String get noTransactions => translate('noTransactions');
  String get noTransactionsSubtitle => translate('noTransactionsSubtitle');
  String get monthlyBudget => translate('monthlyBudget');
  String get spentThisMonth => translate('spentThisMonth');
  String get remaining => translate('remaining');
  String get overBudget => translate('overBudget');
  String get setBudget => translate('setBudget');
  String get editBudget => translate('editBudget');
  String get budgetLimit => translate('budgetLimit');
  String get saveBudget => translate('saveBudget');
  String get enterBudgetAmount => translate('enterBudgetAmount');
  String get budgetUpdated => translate('budgetUpdated');
  String get filterAll => translate('filterAll');
  String get filterToday => translate('filterToday');
  String get filterYesterday => translate('filterYesterday');
  String get filterThisWeek => translate('filterThisWeek');
  String get filterThisMonth => translate('filterThisMonth');
  String get filterExpense => translate('filterExpense');
  String get filterIncome => translate('filterIncome');
  String get todayHeader => translate('todayHeader');
  String get yesterdayHeader => translate('yesterdayHeader');
  String get exportExcel => translate('exportExcel');
  String get exportData => translate('exportData');
  String get exportSubtitle => translate('exportSubtitle');
  String get exportSuccess => translate('exportSuccess');
  String get exportFailed => translate('exportFailed');
  String get profile => translate('profile');
  String get preferences => translate('preferences');
  String get accountAndSupport => translate('accountAndSupport');
  String get upiAutoDetect => translate('upiAutoDetect');
  String get upiAutoDetectSubtitle => translate('upiAutoDetectSubtitle');
  String get categories => translate('categories');
  String get categoriesSubtitle => translate('categoriesSubtitle');
  String get notifications => translate('notifications');
  String get notificationsSubtitle => translate('notificationsSubtitle');
  String get appearance => translate('appearance');
  String get appearanceSubtitle => translate('appearanceSubtitle');
  String get language => translate('language');
  String get languageSubtitle => translate('languageSubtitle');
  String get selectLanguage => translate('selectLanguage');
  String get aiAssistant => translate('aiAssistant');
  String get aiAssistantSubtitle => translate('aiAssistantSubtitle');
  String get privacySecurity => translate('privacySecurity');
  String get privacySecuritySubtitle => translate('privacySecuritySubtitle');
  String get logout => translate('logout');
  String get logoutConfirm => translate('logoutConfirm');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get close => translate('close');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'ml', 'ta'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
