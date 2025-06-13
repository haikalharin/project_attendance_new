
enum ResourceStatus {
  success,
  empty,
  error,
  loading
}

class Resource<T> {
  final ResourceStatus status;

  @override
  Resource._({required this.status, T? data, String? message});

  factory Resource.success(T data) => Resource._(
        status: ResourceStatus.success,
        data: data,
      );

  factory Resource.empty() => Resource._(status: ResourceStatus.empty);

  factory Resource.loading() => Resource._(status: ResourceStatus.loading);

  factory Resource.error({required String message}) => Resource._(
        status: ResourceStatus.error,
        message: message,
      );

  // Additional methods for convenience and handling different states
  bool get isSuccess => status == ResourceStatus.success;

  bool get isEmpty => status == ResourceStatus.empty;

  bool get isError => status == ResourceStatus.error;
}
