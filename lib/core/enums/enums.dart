enum PageStatus {
  loading,
  success,
  error,
}

extension PageStatusExtension on PageStatus {
  bool isLoading() => this == PageStatus.loading;
  bool isSuccess() => this == PageStatus.success;
  bool isError() => this == PageStatus.error;
}
