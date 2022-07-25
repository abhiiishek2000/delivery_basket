class Response<T> {
  late Status status;
  late T data;
  late String message;
  late bool loading;

  Response.loading(this.loading) : status = Status.LOADING;

  Response.completed(this.data) : status = Status.COMPLETED;

  Response.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }
