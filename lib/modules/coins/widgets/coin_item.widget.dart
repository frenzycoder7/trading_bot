import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_bot/core/apis/models/coin.model.dart';
import 'package:trading_bot/core/extensions/context_extension.dart';
import 'package:trading_bot/modules/coins/add_coins.view.dart';
import 'package:trading_bot/modules/coins/cubit/coin_item/coin_item_cubit.dart';
import 'package:trading_bot/modules/coins/cubit/fetch_coin/fetch_coins_cubit.dart';

class CoinItem extends StatelessWidget {
  const CoinItem({super.key, required this.coin});
  final Coin coin;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoinItemCubit(coin)..listenMarket(),
      child: BlocBuilder<CoinItemCubit, CoinItemState>(
        builder: (context, state) {
          return Dismissible(
            key: Key(state.coin.symbol),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) {
              BlocProvider.of<CoinItemCubit>(context)
                  .deleteCoin()
                  .then((value) {
                context.showAppSnackBar(
                  message: 'Coin deleted successfully',
                  type: SnackBarType.success,
                );
                refetchCoins(context);
              }).catchError((error) {
                context.showAppSnackBar(
                  message: 'Failed to delete coin: ${error.toString()}',
                  type: SnackBarType.error,
                );
                refetchCoins(context);
              });
            },
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm"),
                    content: const Text(
                        "Are you sure you want to delete this coin?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Delete"),
                      ),
                    ],
                  );
                },
              );
            },
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCoinsView(coinToEdit: coin),
                  ),
                ).then((value) {
                  BlocProvider.of<FetchCoinsCubit>(context).fetchCoins();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: state.isMarketHigh
                      ? Colors.green.withOpacity(0.05)
                      : Colors.red.withOpacity(0.05),
                  border: Border.all(
                    color: state.isMarketHigh
                        ? Colors.green.withOpacity(0.5)
                        : Colors.red.withOpacity(0.5),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                coin.symbol,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.color
                                          ?.withOpacity(0.9),
                                    ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${coin.leverage}x',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '\$${state.marketPrice}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.color
                                          ?.withOpacity(0.7),
                                    ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: state.isMarketHigh
                                  ? Colors.green.withOpacity(0.15)
                                  : Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${state.percentageChange}%',
                              style: TextStyle(
                                fontSize: 13,
                                color: state.isMarketHigh
                                    ? Colors.green.shade400
                                    : Colors.red.shade400,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCompactInfoChip(
                              'MT: ${coin.maxTrade == -1 ? '∞' : coin.maxTrade}'),
                          _buildCompactInfoChip(
                              'OOMP: ${coin.buyOnMarketAfterSell}'),
                          _buildCompactInfoChip('ROB: ${coin.reorder}'),
                          _buildCompactInfoChip('ROS: ${coin.reorderOnSell}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  refetchCoins(BuildContext context) {
    BlocProvider.of<FetchCoinsCubit>(context).fetchCoins();
  }

  Widget _buildCompactInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade200.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
