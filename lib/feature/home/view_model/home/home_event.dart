// ignore_for_file: non_constant_identifier_names
part of 'home_bloc.dart';

@freezed
abstract class HomeEvent with _$HomeEvent {
  const factory HomeEvent.FetchsmsTransactions() = fetchsmsTransactions;
  const factory HomeEvent.RefreshsmsTransactions() = refreshsmsTransactions;
  const factory HomeEvent.FetchAppUsername(String uid) = fetchAppUsername;
}
