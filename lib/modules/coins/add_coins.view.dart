import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_bot/core/apis/models/coin.model.dart';
import 'package:trading_bot/extensions/context_extensions.dart';
import 'package:trading_bot/modules/coins/cubit/create_coin/create_coin_cubit.dart';
import 'package:trading_bot/modules/coins/widgets/coin_form_widgets.dart';

class AddCoinsView extends StatelessWidget {
  AddCoinsView({super.key, this.coinToEdit}) {
    if (isEditing) {
      coinNameController.text = coinToEdit!.symbol;
      coinAmountController.text = coinToEdit!.amount.toString();
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController coinNameController = TextEditingController();
  final TextEditingController coinAmountController = TextEditingController();

  final Coin? coinToEdit;

  bool get isEditing => coinToEdit != null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateCoinCubit(coinToEdit: coinToEdit),
      child: BlocBuilder<CreateCoinCubit, CreateCoinState>(
        builder: (context, state) {
          final cubit = context.read<CreateCoinCubit>();
          return Scaffold(
            appBar: context.animatedAppBar(
              title: isEditing ? "Edit Coin" : "Add Coin",
              onBackPressed: () async {
                if (state.isLoading) {
                  final shouldPop = await context.showConfirmationDialog(
                    title:
                        '${isEditing ? "Update" : "Add"} coin request in progress',
                    message:
                        'Are you sure you want to cancel the coin ${isEditing ? "update" : "add"}?',
                  );

                  if (shouldPop && context.mounted) {
                    Navigator.of(context).pop();
                  }
                } else {
                  Navigator.of(context).pop();
                }
              },
              dialogTitle: "Add Coins Information",
              dialogContent:
                  "Here you can add new coins to your portfolio and configure their trading parameters.",
              dialogTitleStyle: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              dialogContentStyle: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
              dialogBackgroundColor:
                  Theme.of(context).primaryColor.withOpacity(0.95),
              dialogBorderRadius: BorderRadius.circular(20),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnimatedFormContainer(
                        child: TextFormField(
                          controller: coinNameController,
                          decoration: _buildInputDecoration(
                              'Coin Symbol', Icons.monetization_on),
                          validator: (value) =>
                              _validateCoinName(context, value),
                          enabled: !state.isLoading,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedFormContainer(
                        child: TextFormField(
                          controller: coinAmountController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: _buildInputDecoration(
                              'Amount', Icons.account_balance_wallet),
                          validator: (value) => _validateAmount(context, value),
                          enabled: !state.isLoading,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CoinFormSlider(
                        label: 'Leverage',
                        value: state.leverage,
                        min: 1,
                        max: 15,
                        onChanged: cubit.setLeverage,
                        disabled: state.isLoading,
                      ),
                      CoinFormSlider(
                        label: 'Precision',
                        value: state.precision,
                        min: 0,
                        max: 8,
                        onChanged: cubit.setPrecision,
                        disabled: state.isLoading,
                      ),
                      CoinFormSlider(
                        label: 'Take Profit %',
                        value: state.sellPercentage,
                        min: 1,
                        max: 10,
                        onChanged: cubit.setSellPercentage,
                        disabled: state.isLoading,
                        decimals: 2,
                        useDecimals: true,
                      ),
                      CoinFormSlider(
                        label: 'Reorder %',
                        value: state.buyPercentage,
                        min: 1,
                        max: 10,
                        onChanged: cubit.setBuyPercentage,
                        disabled: state.isLoading,
                        decimals: 2,
                        useDecimals: true,
                      ),
                      CoinFormSlider(
                        label: 'Max Trade',
                        value: state.maxTrade,
                        min: -1,
                        max: 10,
                        onChanged: cubit.setMaxTrade,
                        disabled: state.isLoading,
                      ),
                      const SizedBox(height: 16),
                      CoinFormSwitch(
                        label: 'Reorder on Buy',
                        value: state.reorderOnBuy,
                        onChanged: cubit.setReorderOnBuy,
                        disabled: state.isLoading,
                      ),
                      CoinFormSwitch(
                        label: 'Reorder on Sell',
                        value: state.reorderOnSell,
                        onChanged: cubit.setReorderOnSell,
                        disabled: state.isLoading,
                      ),
                      CoinFormSwitch(
                        label: 'Buy on Market After Sell',
                        value: state.buyOnMarketAfterSell,
                        onChanged: cubit.setBuyOnMarketAfterSell,
                        disabled: state.isLoading,
                      ),
                      const SizedBox(height: 24),
                      SubmitButton(
                        label: isEditing ? "Update Coin" : "Add Coin",
                        isLoading: state.isLoading,
                        onPressed: () => _submitForm(context),
                      ),
                      const SizedBox(height: 24),
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

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
    );
  }

  String? _validateCoinName(BuildContext context, String? value) {
    if (value?.isEmpty ?? true) {
      context.showToast(
        message: 'Please enter coin symbol',
        backgroundColor: Colors.red,
      );
      return 'Please enter coin symbol';
    }
    return null;
  }

  String? _validateAmount(BuildContext context, String? value) {
    if (value?.isEmpty ?? true) {
      context.showToast(
        message: 'Please enter amount',
        backgroundColor: Colors.red,
      );
      return 'Please enter amount';
    }
    try {
      double amount = double.parse(value!);
      if (amount <= 0) {
        context.showToast(
          message: 'Amount must be greater than 0',
          backgroundColor: Colors.red,
        );
        return 'Amount must be greater than 0';
      }
    } catch (e) {
      context.showToast(
        message: 'Please enter a valid number',
        backgroundColor: Colors.red,
      );
      return 'Please enter a valid number';
    }
    return null;
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = context.read<CreateCoinCubit>();

      await cubit.submitForm(
        symbol: coinNameController.text,
        amount: coinAmountController.text,
      );

      if (context.mounted && cubit.state.isSuccess) {
        context.showToast(
          message: "Coin ${isEditing ? "updated" : "added"} successfully",
          backgroundColor: Colors.green,
        );
        Navigator.of(context).pop();
      }

      if (context.mounted && cubit.state.error != null) {
        context.showToast(
          message: cubit.state.error!,
          backgroundColor: Colors.red,
        );
      }
    }
  }
}
