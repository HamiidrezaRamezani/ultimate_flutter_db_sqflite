import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: FirstPage()));
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // نویگیت به صفحه دوم و انتظار برای نتیجه
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondPage()),
            );

            // اجرای کد خاص بر اساس نتیجه دریافتی
            if (result != null && result == 'data_from_second_page') {
              _executeSpecificCode();
            }
          },
          child: Text('Go to Second Page'),
        ),
      ),
    );
  }

  void _executeSpecificCode() {
    // کد خاصی که می‌خواهید اجرا شود
    print('Executing specific code after returning from second page');
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{

        Navigator.pop(context, 'data_from_second_page');
          return true;
        },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Second Page'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // ارسال داده به صفحه اول و بازگشت
              Navigator.pop(context, 'data_from_second_page');
            },
            child: Text('Return to First Page'),
          ),
        ),
      ),
    );
  }
}
