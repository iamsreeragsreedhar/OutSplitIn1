import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:out_split_in/core/services/firebase_services.dart';
import 'package:out_split_in/core/services/network_service.dart';
import 'package:out_split_in/core/services/offline_storage_service.dart';
import 'package:out_split_in/core/services/upi_notification_service.dart';
import 'package:out_split_in/core/sms/sms_import_service.dart';
import 'package:out_split_in/core/theme/view_model/theme_bloc.dart';
import 'package:out_split_in/feature/add_transaction/view_model/addtrans/addtrans_bloc.dart';
import 'package:out_split_in/feature/auth/view_model/auth/auth_bloc.dart';
import 'package:out_split_in/feature/category/services/category_service.dart';
import 'package:out_split_in/feature/category/view_model/category/category_bloc.dart';
import 'package:out_split_in/feature/chatbot/services/chatbot_service.dart';
import 'package:out_split_in/feature/chatbot/view_model/chatbot/chatbot_bloc.dart';
import 'package:out_split_in/feature/home/services/sms_services.dart';
import 'package:out_split_in/feature/home/view_model/home/home_bloc.dart';
import 'package:out_split_in/feature/notification/services/notification_service.dart';
import 'package:out_split_in/feature/notification/view_model/notification/notification_bloc.dart';
import 'package:out_split_in/feature/profile/view_model/profile/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> depInit() async {
  sl.registerFactory(() => FirebaseAuth.instance);
  sl.registerFactory(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => NetworkService());
  sl.registerLazySingleton(() => OfflineStorageService());
  sl.registerLazySingleton(() => CategoryService());
  sl.registerLazySingleton(() => NotificationService());
  sl.registerLazySingleton(() => ChatbotService());
  sl.registerFactory(
    () => FirebaseServices(
      offlineStorageService: sl<OfflineStorageService>(),
      networkService: sl<NetworkService>(),
    ),
  );
  sl.registerFactory(() => SmsServices());
  sl.registerFactory(() => SmsImportService());
  sl.registerLazySingleton(
    () => UpiNotificationService(firebaseServices: sl(), auth: sl()),
  );

  //////Bloc
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerFactory(() => AddtransBloc(firebaseServices: sl(), bloc: sl()));
  sl.registerFactory(() => HomeBloc(sl(), sl()));
  sl.registerFactory(() => ProfileBloc(sl()));
  sl.registerFactory(() => CategoryBloc(categoryService: sl()));
  sl.registerFactory(() => NotificationBloc(notificationService: sl()));
  sl.registerFactory(() => ThemeBloc());
  sl.registerFactory(
    () => ChatbotBloc(
      chatbotService: sl<ChatbotService>(),
      homeBloc: sl<HomeBloc>(),
      networkService: sl<NetworkService>(),
    ),
  );
}
