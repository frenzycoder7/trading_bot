import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trading_bot/modules/coins/add_coins.view.dart';
import 'package:trading_bot/modules/coins/cubit/fetch_coin/fetch_coins_cubit.dart';
import 'package:trading_bot/modules/coins/widgets/coin_item.widget.dart';

class CoinsView extends StatelessWidget {
  const CoinsView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return FetchCoinsCubit()..fetchCoins();
      },
      child: BlocBuilder<FetchCoinsCubit, FetchCoinsState>(
          builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Coins", style: Theme.of(context).textTheme.titleLarge),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddCoinsView(),
                          ),
                        ).then((value) {
                          BlocProvider.of<FetchCoinsCubit>(context).fetchCoins();
                        });
                      },
                      child: const FaIcon(FontAwesomeIcons.add),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.coins.length,
                  itemBuilder: (context, index) {
                    return CoinItem(coin: state.coins[index]);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
