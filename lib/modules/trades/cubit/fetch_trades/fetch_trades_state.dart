part of 'fetch_trades_cubit.dart';

class FetchTradesState extends Equatable {
  const FetchTradesState({
    this.status = TradeStatus.OPEN,
    this.symbols = const [],
    this.limit = 10,
    this.total = 0,
  });
  final TradeStatus status;
  final List<String> symbols;
  final limit;
  final int total;

  FetchTradesState copyWith({
    TradeStatus? status,
    List<String>? symbols,
    int? limit,
    int? total,
  }) {
    return FetchTradesState(
      status: status ?? this.status,
      symbols: symbols ?? this.symbols,
      limit: limit ?? this.limit,
      total: total ?? this.total,
    );
  }

  @override
  List<Object> get props => [status, symbols, total];
}
