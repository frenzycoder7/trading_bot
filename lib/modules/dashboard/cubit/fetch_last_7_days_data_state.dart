part of 'fetch_last_7_days_data_cubit.dart';

class FetchLast_7DaysDataState extends Equatable {
  const FetchLast_7DaysDataState({
    this.data = const [],
    this.pageStatus = PageStatus.loading,
  });

  final List<SevenDaysProfit> data;
  final PageStatus pageStatus;

  @override
  List<Object> get props => [data, pageStatus];

  FetchLast_7DaysDataState copyWith({
    List<SevenDaysProfit>? data,
    PageStatus? pageStatus,
  }) {
    return FetchLast_7DaysDataState(
      data: data ?? this.data,
      pageStatus: pageStatus ?? this.pageStatus,
    );
  }
}
