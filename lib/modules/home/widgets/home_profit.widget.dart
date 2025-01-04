import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_bot/core/enums/enums.dart';
import 'package:trading_bot/extensions/context_extensions.dart';
import 'package:trading_bot/modules/home/cubit/fetch_profit_summary_cubit.dart';
import 'package:trading_bot/modules/home/widgets/profit_card.widget.dart';

class HomeProfitWidget extends StatelessWidget {
  const HomeProfitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchProfitSummaryCubit, FetchProfitSummaryState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 5),
                      state.pageStatus.isLoading()
                          ? context.circularLoader()
                          : InkWell(
                              child: const Icon(
                                Icons.refresh,
                                color: Colors.white70,
                                size: 18,
                              ),
                              onTap: () {
                                context
                                    .read<FetchProfitSummaryCubit>()
                                    .fetchProfitSummary();
                              },
                            )
                    ],
                  ),
                  const SizedBox(height: 8),
                  state.pageStatus.isLoading()
                      ? context.shimmerLoader(
                          height: 32,
                          width: 150,
                        )
                      : Text(
                          '\$ ${state.totalProfit.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ProfitCard(
                        label: 'Today',
                        amount: state.todayProfit,
                        isPositive: true,
                        isLoading: state.pageStatus.isLoading(),
                      ),
                      ProfitCard(
                        label: 'Weekly',
                        amount: state.lastWeekProfit,
                        isPositive: true,
                        isLoading: state.pageStatus.isLoading(),
                      ),
                      ProfitCard(
                        label: 'Monthly',
                        amount: state.lastMonthProfit,
                        isPositive: true,
                        isLoading: state.pageStatus.isLoading(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
