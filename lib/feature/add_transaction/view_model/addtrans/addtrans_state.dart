// ignore_for_file: camel_case_types
part of 'addtrans_bloc.dart';

enum LoadingStatus { none, loading, success, error }

enum type { none, paymentListing }

@freezed
abstract class AddtransState with _$AddtransState {
  const factory AddtransState({
    @Default(LoadingStatus.none) LoadingStatus loadingStatus,
    @Default('') String msg,
    @Default(type.none) type hometype,
  }) = addtransState;
}
