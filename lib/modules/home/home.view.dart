import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_bot/extensions/context_extensions.dart';
import 'package:trading_bot/modules/coins/coins.view.dart';
import 'package:trading_bot/modules/dashboard/dashboard.view.dart';
import 'package:trading_bot/modules/home/cubit/fetch_profit_summary_cubit.dart';
import 'package:trading_bot/modules/home/widgets/animated_header.widget.dart';
import 'package:trading_bot/modules/home/widgets/home_profit.widget.dart';
import 'package:trading_bot/modules/home/widgets/tab_page_controller.widget.dart';
import 'package:trading_bot/modules/trades/trades.view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedHeader(
            child: SafeArea(
              child: BlocProvider<FetchProfitSummaryCubit>(
                create: (context) =>
                    FetchProfitSummaryCubit()..fetchProfitSummary(),
                child: const HomeProfitWidget(),
              ),
            ),
          ),
          // body content
          Expanded(
            child: TabPageController(
              pages: const [
                DashboardView(),
                TradesView(),
                CoinsView(),
              ],
              tabs: const [
                'Dashboard',
                'Trades',
                'Coins',
              ],
              tabHeight: 40,
            ),
          )
        ],
      ),
    );
  }
}
