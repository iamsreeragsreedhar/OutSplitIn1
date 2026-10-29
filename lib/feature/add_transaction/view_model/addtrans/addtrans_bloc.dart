import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:out_split_in/core/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';
import 'package:out_split_in/feature/home/view_model/home/home_bloc.dart';

part 'addtrans_state.dart';
part 'addtrans_event.dart';
part 'addtrans_bloc.freezed.dart';

class AddtransBloc extends Bloc<AddtransEvent, AddtransState> {
  final FirebaseServices firebaseServices;
  final HomeBloc bloc;

  AddtransBloc({required this.firebaseServices, required this.bloc})
      : super(const AddtransState()) {
    on<AddtransEvent>(addTransaction);
  }

  Future<void> addTransaction(
      AddtransEvent event, Emitter<AddtransState> emit) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.loading));
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(
          state.copyWith(
            loadingStatus: LoadingStatus.error,
            msg: 'User is not logged in',
          ),
        );
        return;
      }

      final syncedOnline =
          await firebaseServices.addTransaction(transaction: event.model);

      // Refresh home bloc transactions so the new item displays immediately
      bloc.add(const fetchsmsTransactions());

      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.success,
          msg: syncedOnline
              ? 'Transaction added and synced to cloud!'
              : 'Saved offline! Will sync automatically once online.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(loadingStatus: LoadingStatus.error, msg: e.toString()),
      );
    }
  }
}
