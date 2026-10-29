import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:out_split_in/core/config/app_config.dart';
import 'package:out_split_in/core/localization/app_localizations.dart';
import 'package:out_split_in/core/localization/locale_controller.dart';
import 'package:out_split_in/core/routes/routes.dart';
import 'package:out_split_in/core/service_locator/di.dart';
import 'package:out_split_in/core/theme/dark_theme.dart';
import 'package:out_split_in/core/theme/light_theme.dart';
import 'package:out_split_in/core/theme/view_model/theme_bloc.dart';
import 'package:out_split_in/core/theme/view_model/theme_event.dart';
import 'package:out_split_in/core/theme/view_model/theme_state.dart';
import 'package:out_split_in/feature/add_transaction/view_model/addtrans/addtrans_bloc.dart';
import 'package:out_split_in/feature/auth/view_model/auth/auth_bloc.dart';
import 'package:out_split_in/feature/category/view_model/category/category_bloc.dart';
import 'package:out_split_in/feature/category/view_model/category/category_event.dart';
import 'package:out_split_in/feature/home/view_model/home/home_bloc.dart';
import 'package:out_split_in/feature/notification/view_model/notification/notification_bloc.dart';
import 'package:out_split_in/feature/notification/view_model/notification/notification_event.dart';
import 'package:out_split_in/feature/profile/view_model/profile/profile_bloc.dart';
import 'package:out_split_in/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> bootstrap(AppConfig config) async {
  AppConfig.instance = config;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Enable Firestore offline persistence for offline saving
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  await depInit();

  // Determine initial launch route based on onboarding and auth status
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
  final isLoggedIn = FirebaseAuth.instance.currentUser != null;

  final initialRoute = !seenOnboarding
      ? '/onboarding'
      : (isLoggedIn ? '/home' : '/');

  runApp(MyApp(router: createRouter(initialLocation: initialRoute)));
}

void main() async {
  await bootstrap(AppConfig.prod);
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(sl())),
        BlocProvider(create: (context) => HomeBloc(sl(), sl())),
        BlocProvider(
          create: (context) => AddtransBloc(firebaseServices: sl(), bloc: sl()),
        ),
        BlocProvider(create: (context) => ProfileBloc(sl())),
        BlocProvider(
          create: (context) =>
              CategoryBloc(categoryService: sl())..add(const LoadCategoriesEvent()),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(notificationService: sl())
            ..add(const LoadNotificationsEvent()),
        ),
        BlocProvider(
          create: (context) => ThemeBloc()..add(const LoadThemeEvent()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return ListenableBuilder(
            listenable: LocaleController.instance,
            builder: (context, _) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: AppConfig.instance.showDebugBanner,
                title: AppConfig.instance.appTitle,
                theme: LightTheme.lightTheme,
                darkTheme: DarkTheme.darkTheme,
                themeMode: themeState.themeMode,
                routerConfig: router,
                locale: LocaleController.instance.locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
              );
            },
          );
        },
      ),
    );
  }
}
