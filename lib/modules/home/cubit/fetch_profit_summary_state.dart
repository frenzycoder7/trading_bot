part of 'fetch_profit_summary_cubit.dart';

class FetchProfitSummaryState extends Equatable {
  const FetchProfitSummaryState({
    this.totalProfit = 0.0,
    this.todayProfit = 0.0,
    this.lastWeekProfit = 0.0,
    this.lastMonthProfit = 0.0,
    this.pageStatus = PageStatus.loading,
    this.totalTrades = 0,
    this.todayTrades = 0,
    this.lastWeekTrades = 0,
    this.lastMonthTrades = 0,
    this.error,
  });

  final double totalProfit;
  final double todayProfit;
  final double lastWeekProfit;
  final double lastMonthProfit;
  final int totalTrades;
  final int todayTrades;
  final int lastWeekTrades;
  final int lastMonthTrades;
  final PageStatus pageStatus;
  final String? error;

  @override
  List<Object?> get props => [
        totalProfit,
        todayProfit,
        lastWeekProfit,
        lastMonthProfit,
        totalTrades,
        todayTrades,
        lastWeekTrades,
        lastMonthTrades,
        pageStatus,
        error,
      ];

  FetchProfitSummaryState copyWith({
    double? totalProfit,
    double? todayProfit,
    double? lastWeekProfit,
    double? lastMonthProfit,
    int? totalTrades,
    int? todayTrades,
    int? lastWeekTrades,
    int? lastMonthTrades,
    PageStatus? pageStatus,
    String? error,
  }) {
    return FetchProfitSummaryState(
      totalProfit: totalProfit ?? this.totalProfit,
      todayProfit: todayProfit ?? this.todayProfit,
      lastWeekProfit: lastWeekProfit ?? this.lastWeekProfit,
      lastMonthProfit: lastMonthProfit ?? this.lastMonthProfit,
      totalTrades: totalTrades ?? this.totalTrades,
      todayTrades: todayTrades ?? this.todayTrades,
      lastWeekTrades: lastWeekTrades ?? this.lastWeekTrades,
      lastMonthTrades: lastMonthTrades ?? this.lastMonthTrades,
      pageStatus: pageStatus ?? this.pageStatus,
      error: error ?? this.error,
    );
  }
}
