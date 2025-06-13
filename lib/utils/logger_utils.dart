import 'dart:developer';


class Logger {
  // Sample of abstract logging function
  static void write(String text, {bool isError = false}) {
    print('** $text [$isError]');
  }

  static void printLog(dynamic text) {

      print(text.toString());

  }

  static void printLongText(dynamic text) {

      log(text.toString());
  }

  static void show(String message, {String? title}) {
    // var r = Random();
    // const _chars =
    //     'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    // final genRandom =
    //     List.generate(10, (index) => _chars[r.nextInt(_chars.length)]).join();
    // print('** ${title ?? genRandom} : $message');
  }
}
