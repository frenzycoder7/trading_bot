import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:trading_bot/core/apis/index.dart';
import 'package:trading_bot/core/apis/models/7_days_profit.model.dart';
import 'package:trading_bot/core/enums/enums.dart';

part 'fetch_last_7_days_data_state.dart';

class FetchLast_7DaysDataCubit extends Cubit<FetchLast_7DaysDataState> {
  FetchLast_7DaysDataCubit() : super(const FetchLast_7DaysDataState());

  Future<void> fetchLast7DaysData() async {
    try {
      emit(state.copyWith(pageStatus: PageStatus.loading));
      final data = await API.shared.fetch7DaysProfit();
      emit(state.copyWith(data: data, pageStatus: PageStatus.success));
    } catch (e) {
      debugPrint("Error: $e");
      emit(state.copyWith(pageStatus: PageStatus.error));
    }
  }
}
