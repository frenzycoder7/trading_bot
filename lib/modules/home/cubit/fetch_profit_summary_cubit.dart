import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trading_bot/core/apis/index.dart';
import 'package:trading_bot/core/enums/enums.dart';

part 'fetch_profit_summary_state.dart';

class FetchProfitSummaryCubit extends Cubit<FetchProfitSummaryState> {
  FetchProfitSummaryCubit() : super(const FetchProfitSummaryState());

  Future<void> fetchProfitSummary() async {
    emit(state.copyWith(pageStatus: PageStatus.loading));
    try {
      final profitSummary = await API.shared.fetchProfitSummary();
      emit(
        state.copyWith(
          pageStatus: PageStatus.success,
          totalProfit: profitSummary.totalProfit,
          todayProfit: profitSummary.todayProfit,
          lastWeekProfit: profitSummary.lastWeekProfit,
          lastMonthProfit: profitSummary.lastMonthProfit,
          totalTrades: profitSummary.totalTrades,
          todayTrades: profitSummary.todayTrades,
          lastWeekTrades: profitSummary.lastWeekTrades,
          lastMonthTrades: profitSummary.lastMonthTrades,
        ),
      );
    } catch (e) {
      print(e);
      emit(state.copyWith(pageStatus: PageStatus.error, error: e.toString()));
    }
  }
}
