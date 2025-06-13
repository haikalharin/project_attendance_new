enum Status { LOADING, COMPLETED, ERROR }

class ResultModel<T> {
  final Status status;
  final T? data;
  final String? message;

  ResultModel.loading([this.data, this.message]) : status = Status.LOADING;

  ResultModel.completed(this.data, [this.message]) : status = Status.COMPLETED;

  ResultModel.error(this.message, [this.data]) : status = Status.ERROR;

  @override
  String toString() {
    return 'Status : $status \nMessage : $message \nData : $data';
  }
}
