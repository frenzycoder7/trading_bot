import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:trading_bot/core/services/Storage.service.dart';
import 'package:trading_bot/modules/trades/cubit/fetch_trades/fetch_trades_cubit.dart';
import 'package:trading_bot/modules/trades/enums/trade_status.enums.dart';
import 'package:trading_bot/modules/trades/models/trade.model.dart';
import 'package:trading_bot/modules/trades/widgets/trade_filter.widget.dart';
import 'package:trading_bot/modules/trades/widgets/trade_item.widgets.dart';

class TradesView extends StatelessWidget {
  const TradesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocProvider<FetchTradesCubit>(
        create: (context) => FetchTradesCubit(),
        child: Builder(
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<FetchTradesCubit, FetchTradesState>(
                  builder: (context, state) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Trades",
                              style: Theme.of(context).textTheme.titleLarge),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  context
                                      .read<FetchTradesCubit>()
                                      .pagingController
                                      .refresh();
                                },
                                child: const FaIcon(FontAwesomeIcons.refresh),
                              ),
                              const SizedBox(width: 15),
                              Badge(
                                label: Text(state.symbols.length.toString()),
                                backgroundColor: state.symbols.isNotEmpty
                                    ? Colors.blue
                                    : Colors.white,
                                child: InkWell(
                                  onTap: () {
                                    showFilterBottomSheet(context);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: FaIcon(FontAwesomeIcons.filter),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: state.status == TradeStatus.CLOSED,
                              onChanged: (value) {
                                TradeStatus status = value == true
                                    ? TradeStatus.CLOSED
                                    : TradeStatus.OPEN;
                                context
                                    .read<FetchTradesCubit>()
                                    .setStatus(status);
                              },
                            ),
                            const Text("Show only closed trades"),
                          ],
                        ),
                        Text("${state.total} Trades")
                      ],
                    )
                  ],
                );
              }),
              Expanded(
                child: PagedListView<int, Trade>(
                  pagingController:
                      context.read<FetchTradesCubit>().pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Trade>(
                    itemBuilder: (context, item, index) =>
                        TradeItem(trade: item),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showFilterBottomSheet(BuildContext context) {
    final cubit = context.read<FetchTradesCubit>();
    List<String> symbols = Storage.shared.fetchSymbols();
    showBottomSheet(
      context: context,
      builder: (ctx) =>
          TradeFilterWidget(symbols: symbols, cubit: cubit, ctx: ctx),
    );
  }
}
