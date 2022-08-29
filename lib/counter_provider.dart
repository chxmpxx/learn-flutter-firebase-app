import 'package:flutter/material.dart';

class CounterProvider with ChangeNotifier {

  int value = 0;
  // สร้างฟังก์ชันการนับ counter
  increment() {
    value++;
    // เสมือนเป็นการใช้ setState เฉพาะตรงนี้ แล้วจะทำงานเฉพาะตอนถูกเรียก (ใช้ Consumer เรียก)
    notifyListeners();
  }

}