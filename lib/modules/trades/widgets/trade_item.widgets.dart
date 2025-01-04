import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trading_bot/core/extensions/context_extension.dart';
import 'package:trading_bot/core/widgets/shimmer_text.dart';
import 'package:trading_bot/modules/trades/cubit/trade_item/trade_item_cubit.dart';
import 'package:trading_bot/modules/trades/models/trade.model.dart';
import 'package:trading_bot/modules/trades/widgets/trade_price_display_box.widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TradeItem extends StatelessWidget {
  const TradeItem({super.key, required this.trade});
  final Trade trade;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TradeItemCubit>(
      create: (context) => TradeItemCubit(trade)..listenMarketPrice(),
      child: _TradeWdiegt(trade: trade),
    );
  }
}

class _TradeWdiegt extends StatelessWidget {
  const _TradeWdiegt({super.key, required this.trade});
  final Trade trade;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradeItemCubit, TradeItemState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: state.isProfit
                  ? Colors.green.withOpacity(0.3)
                  : Colors.red.withOpacity(0.3),
              width: 2,
            ),
            color: state.isProfit
                ? Colors.green.withOpacity(0.05)
                : Colors.red.withOpacity(0.05),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: trade.isClosed()
                                    ? Colors.red.withOpacity(0.2)
                                    : Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                trade.isClosed() ? 'SELL' : 'BUY',
                                style: TextStyle(
                                  color: trade.isClosed()
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              trade.symbol,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text('-'),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "${trade.amount.toStringAsFixed(2)} amt",
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.withOpacity(0.2),
                                Colors.blue.withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ShimmerText(
                                text: '\$${trade.margin.toStringAsFixed(2)}',
                                baseColor: Colors.purple,
                                highlightColor: Colors.purple.withOpacity(0.5),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                              const Text(
                                ' on ',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              ShimmerText(
                                text: "${trade.leverage}x",
                                baseColor: Colors.blue,
                                highlightColor: Colors.blue.withOpacity(0.5),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${state.currentROI > 0 ? '+' : ''}${state.currentROI.abs().toStringAsFixed(2)}% ROI',
                          style: TextStyle(
                            color: state.isProfit ? Colors.green : Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${state.currentProfit > 0 ? '+\$' : '-\$'}${state.currentProfit.abs().toStringAsFixed(2)}',
                          style: TextStyle(
                            color: state.isProfit ? Colors.green : Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMM d yyyy, HH:mm').format(DateTime.parse(
                          trade.isClosed()
                              ? trade.updatedAt
                              : trade.createdAt)),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    trade.isClosed()
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 12,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'TC: \$${(trade.fee).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.currency_bitcoin,
                                  size: 12,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'BP: \$${(trade.binanceProfit).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: trade.isBinanceProfit()
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : context.animatedBorderButton(
                            isProfit: state.currentProfit > 0,
                            onPressed: () {
                              // Add close trade logic here
                            },
                            child: const ShimmerText(
                              text: "Close",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                              baseColor: Colors.white,
                              highlightColor: Colors.white,
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PriceDisplayBox(
                      label: 'Entry',
                      price: trade.buyPrice,
                      baseColor: Colors.green,
                    ),
                    if (state.coinNotFound && trade.isOpen())
                      const Text(
                        "Coin not found",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (trade.isOpen())
                      PriceDisplayBox(
                        label: "",
                        price: state.marketPrice,
                        baseColor: state.isHigh ? Colors.green : Colors.red,
                      ),
                    PriceDisplayBox(
                      label: 'Exit',
                      price: trade.sellPrice,
                      baseColor: Colors.green,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
