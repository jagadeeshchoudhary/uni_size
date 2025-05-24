import 'package:flutter/material.dart';
import 'package:uni_size/uni_size.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
   Widget build(BuildContext context) {
    return UniSizeWidget(
      designWidth: 375,  // Your design width (optional, default: 375)
      designHeight: 812, // Your design height (optional, default: 812)
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'UniSize Demo',
          home: MyHomePage(),
        );
      },
    );
  }
}
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'UniSize Demo',
          style: TextStyle(fontSize: 18.sp), // Use .sp for fonts
        ),
      ),
      body: Container(
        width: 200.dp,        // Use .dp for sizes
        height: 100.dp,       // Use .dp for sizes
        padding: EdgeInsets.all(16.dp), // Use .dp for padding
        margin: EdgeInsets.symmetric(
          horizontal: 20.dp,  // Use .dp for margins
          vertical: 10.dp,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.dp), // Use .dp for radius
        ),
        child: Text(
          'Hello UniSize!',
          style: TextStyle(
            fontSize: 16.sp,    // Use .sp for font size
            height: 1.5,        // Line height can remain unitless
          ),
        ),
      ),
    );
  }
}