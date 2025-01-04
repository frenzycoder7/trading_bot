part of 'fetch_coins_cubit.dart';

class FetchCoinsState {
  PageStatus status = PageStatus.loading;
  List<Coin> coins = [];
  String errorMessage = "";

  FetchCoinsState({
    this.status = PageStatus.loading,
    this.coins = const [],
    this.errorMessage = "",
  });

  FetchCoinsState copyWith({
    PageStatus? status,
    List<Coin>? coins,
    String? errorMessage,
  }) {
    return FetchCoinsState(
      status: status ?? this.status,
      coins: coins ?? this.coins,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
