import 'package:go_router/go_router.dart';
import 'package:out_split_in/core/routes/main_shell_scaffold.dart';
import 'package:out_split_in/core/routes/page_transitions.dart';
import 'package:out_split_in/feature/add_transaction/view/add_trans.dart';
import 'package:out_split_in/feature/auth/view/login.dart';
import 'package:out_split_in/feature/auth/view/signup.dart';
import 'package:out_split_in/feature/category/view/category_screen.dart';
import 'package:out_split_in/feature/chatbot/view/chatbot_screen.dart';
import 'package:out_split_in/feature/home/view/home_page.dart';
import 'package:out_split_in/feature/notification/view/notification_screen.dart';
import 'package:out_split_in/feature/onboarding/view/onboarding_screen.dart';
import 'package:out_split_in/feature/profile/view/profile.dart';
import 'package:out_split_in/feature/reports/view/reports_screen.dart';

GoRouter createRouter({String initialLocation = '/'}) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      pageBuilder: (context, state) => buildAppTransitionPage(
        context: context,
        state: state,
        child: const OnboardingScreen(),
      ),
    ),
    GoRoute(
      path: '/',
      name: 'login',
      pageBuilder: (context, state) => buildAppTransitionPage(
        context: context,
        state: state,
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      pageBuilder: (context, state) => buildAppTransitionPage(
        context: context,
        state: state,
        child: const SignupScreen(),
      ),
    ),
    GoRoute(
      path: '/categories',
      name: 'categories',
      pageBuilder: (context, state) => buildAppTransitionPage(
        context: context,
        state: state,
        child: const CategoryScreen(),
      ),
    ),
    GoRoute(
      path: '/notifications',
      name: 'notifications',
      pageBuilder: (context, state) => buildAppTransitionPage(
        context: context,
        state: state,
        child: const NotificationScreen(),
      ),
    ),
    GoRoute(
      path: '/chatbot',
      name: 'chatbot',
      pageBuilder: (context, state) => buildAppTransitionPage(
        context: context,
        state: state,
        child: const ChatbotScreen(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShellScaffold(navShell: navigationShell),
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => buildAppTransitionPage(
                context: context,
                state: state,
                child: const HomeScreen(),
              ),
            ),
          ],
        ),
        // Tab 1: Reports & Charts
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/reports',
              pageBuilder: (context, state) => buildAppTransitionPage(
                context: context,
                state: state,
                child: const ReportsScreen(),
              ),
            ),
          ],
        ),
        // Tab 2: Add Transaction
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/add-transaction',
              pageBuilder: (context, state) => buildAppTransitionPage(
                context: context,
                state: state,
                child: const AddTransactionScreen(),
              ),
            ),
          ],
        ),
        // Tab 3: Profile & Settings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) => buildAppTransitionPage(
                context: context,
                state: state,
                child: const ProfileScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

final GoRouter routes = createRouter();
