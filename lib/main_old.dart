import 'package:firebase_app/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // ประกาศการเรียก Provider มาใช้งาน
        ChangeNotifierProvider<CounterProvider>(
          // _ แทนการเรียกใช้ context ที่อยู่ในตัว runApp 
          create: (_) => CounterProvider(),
        )
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // true: คือเรียกตลอด (ก็เหมือน setState) false: เรียกเฉพาะตอนใช้
    var _counter = Provider.of<CounterProvider>(context, listen: false);

    print("load...");

    return Scaffold(
      appBar: AppBar(
        title: Text('Provider Manage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You have pushed the button this many times'),
            // ใส่ Consumer เพื่อให้อัปเดต UI เฉพาะตรงนี้
            Consumer<CounterProvider>(
              builder: (_, value, __) => Text(
                '${_counter.value}',
                style: Theme.of(context).textTheme.headline4,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _counter.increment(),
        child: Icon(Icons.add),
      ),
    );
  }
}
