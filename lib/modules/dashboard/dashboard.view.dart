import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_bot/modules/chats/bar_chart.view.dart';
import 'package:trading_bot/modules/dashboard/cubit/fetch_last_7_days_data_cubit.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dashboard", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.9),
            ),
            child: BlocProvider(
              create: (context) =>
                  FetchLast_7DaysDataCubit()..fetchLast7DaysData(),
              child: BlocBuilder<FetchLast_7DaysDataCubit,
                  FetchLast_7DaysDataState>(
                builder: (context, state) {
                  return SevenDaysDataChart(data: state.data);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
