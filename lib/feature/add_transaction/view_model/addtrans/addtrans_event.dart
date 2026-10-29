// ignore_for_file: non_constant_identifier_names
part of 'addtrans_bloc.dart';

@freezed
abstract class AddtransEvent with _$AddtransEvent {
  const factory AddtransEvent.AddTransaction(TransactionModel model) =
      addTransaction;
}
