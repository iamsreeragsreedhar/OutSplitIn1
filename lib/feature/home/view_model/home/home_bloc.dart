import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:out_split_in/core/services/firebase_services.dart';
import 'package:out_split_in/core/sms/sms_parser.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';
import 'package:out_split_in/feature/home/services/sms_services.dart';

part 'home_state.dart';
part 'home_event.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseServices firebaseServices;
  final SmsServices smsservices;
  HomeBloc(this.firebaseServices, this.smsservices) : super(const HomeState()) {
    on<fetchsmsTransactions>(onFetchTransactions);
    on<refreshsmsTransactions>(onRefreshTransactions);
    on<fetchAppUsername>(onFetchAppUsername);
  }

  Future<void> onFetchTransactions(
    fetchsmsTransactions event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(loadingStatus: HomeLoadingStatus.loading));

    try {
      final transactions = await firebaseServices.getTransactions();
      debugPrint('Fetched transactions: ${transactions.length}');

      emit(
        state.copyWith(
          loadingStatus: HomeLoadingStatus.success,
          transactions: transactions,
          hometype: Hometype.paymentListing,
        ),
      );
    } catch (e) {
      debugPrint('Error fetching transactions: ${e.toString()}');
      emit(
        state.copyWith(
          loadingStatus: HomeLoadingStatus.error,
          msg: e.toString(),
        ),
      );
    }
  }

  Future<void> onRefreshTransactions(
    refreshsmsTransactions event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final messages = await smsservices.getSmsMessages();

      final transactions = <TransactionModel>[];

      for (final sms in messages) {
        final body = sms.body;

        if (body == null || body.trim().isEmpty) {
          continue;
        }
        final transaction = SmsParser.parse(
          body: body,
          message: body,
          sender: sms.sender ?? '',
          date: sms.date ?? DateTime.now(),
          smsId: 'sms_${sms.id ?? ''}',
          smsDate: sms.date ?? DateTime.now(),
        );
        if (transaction != null) {
          transactions.add(transaction);
        }
      }
      emit(
        state.copyWith(
          loadingStatus: HomeLoadingStatus.success,
          transactions: transactions,
          hometype: Hometype.paymentListing,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loadingStatus: HomeLoadingStatus.error,
          msg: e.toString(),
        ),
      );
    }
  }

  Future<void> onFetchAppUsername(
      fetchAppUsername event, Emitter<HomeState> emit) async {
    try {
      final username = await firebaseServices.getUsername(event.uid);
      debugPrint('Fetched username: $username');
      if (username == null) {
        emit(
          state.copyWith(
            loadingStatus: HomeLoadingStatus.error,
            msg: 'Username not found for uid: ${event.uid}',
          ),
        );
        return;
      }
      emit(
        state.copyWith(loadingStatus: HomeLoadingStatus.success, msg: username),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loadingStatus: HomeLoadingStatus.error,
          msg: e.toString(),
        ),
      );
    }
  }
}
