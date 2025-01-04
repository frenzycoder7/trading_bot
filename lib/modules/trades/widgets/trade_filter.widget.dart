import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trading_bot/modules/trades/cubit/fetch_trades/fetch_trades_cubit.dart';

class TradeFilterWidget extends StatelessWidget {
  const TradeFilterWidget({
    super.key,
    required this.symbols,
    required this.cubit,
    required this.ctx,
  });
  final List<String> symbols;
  final FetchTradesCubit cubit;
  final BuildContext ctx;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: 10,
        ),
        child: BlocProvider.value(
          value: cubit,
          child: BlocBuilder<FetchTradesCubit, FetchTradesState>(
            builder: (context, state) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filter",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.xmark,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        if (state.symbols.contains(symbols[index])) {
                          cubit.removeSymbol(symbols[index]);
                        } else {
                          cubit.addSymbol(symbols[index]);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: state.symbols.contains(symbols[index])
                              ? Colors.blue
                              : Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          symbols[index],
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: state.symbols.contains(symbols[index])
                                    ? Colors.white
                                    : Colors.black,
                              ),
                        ),
                      ),
                    ),
                    itemCount: symbols.length,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
