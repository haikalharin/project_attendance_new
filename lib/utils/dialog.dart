import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AppDialog {


  static Future<dynamic> DialogInfo({title, btnCenter, desc, onBtnCenter}) {
    return showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return DialogInfoItem(
              btnCenter: btnCenter,
              desc: desc,
              onBtnCenter: onBtnCenter,
              title: title);
        });
  }
}

class DialogInfoItem extends StatelessWidget {
  final String? title, desc, btnCenter;
  final VoidCallback? onBtnCenter;

  const DialogInfoItem({
    Key? key,
    this.title,
    this.desc,
    this.btnCenter,
    this.onBtnCenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          //* atur maxHeight buat batasin ukuran dialog 100.h = 100% full screen di layar
          maxHeight: 240,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title!,
                textAlign: TextAlign.center,
                maxLines: 3,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 2),
              Text(
                desc!,
                style:  TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
                // *atur maxLines buat batasin max baris yang ditampilkan
                maxLines: 18,
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        fixedSize: Size.fromHeight(32),
                        minimumSize: Size(70, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: onBtnCenter ?? () => Get.back(),
                      child: Center(
                        child: Text(
                          btnCenter ??"Oke",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
