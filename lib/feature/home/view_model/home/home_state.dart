part of 'home_bloc.dart';

enum HomeLoadingStatus { none, loading, success, error }

enum Hometype { none, paymentListing }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeLoadingStatus.none) HomeLoadingStatus loadingStatus,
    @Default('') String msg,
    @Default([]) List<dynamic> transactions,
    @Default(Hometype.none) Hometype hometype,
  }) = _homeState;
}
