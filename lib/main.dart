import 'package:flutter/material.dart'; // 导入Flutter材料设计的包
import 'package:shared_preferences/shared_preferences.dart'; // 导入用于持久化存储的SharedPreferences包
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp()); // 运行MyApp应用
}

class MyApp extends StatefulWidget {
  // 定义MyApp类，继承自StatefulWidget，可以更新状态
  @override
  _MyApp createState() => _MyApp(); // 创建状态对象
}

class _MyApp extends State<MyApp> {
  double balance = 0; // 定义一个状态变量balance，初始化为0，用于存储余额

  @override
  Widget build(BuildContext context) {
    // 构建UI界面
    Future<void> _incrementBalance() async {
      // 定义一个异步函数，用于增加余额
      setState(() {
        // 更新状态
        balance += 500; // 每次调用时余额增加500
      });

      // 获取SharedPreferences的实例
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('balance', balance); // 将更新后的余额保存到SharedPreferences
    }

    Future<void> loadBalance() async {
      // 定义一个异步函数，用于加载保存的余额
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        balance = prefs.getDouble('balance') ??
            0; // 从SharedPreferences获取余额，如果未找到，则返回0
      });
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(), // 设置暗色主题
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true, // 标题居中
            title: Text("余额app"), // AppBar标题
          ),
          body: Container(
              padding: EdgeInsets.all(20), // 内边距为20
              color: Colors.blueGrey.shade700, // 背景色
              height: double.infinity, // 高度尽可能大
              width: double.infinity, // 宽度尽可能大
              child: Column(
                children: [
                  Expanded(
                    flex: 9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // 子元素垂直居中
                      children: [
                        Text("当前余额:"), // 显示文本
                        SizedBox(
                          height: 20, // 高度为20的空间
                        ),
                        Text(
                            '${NumberFormat.simpleCurrency().format(balance)}', // 显示余额
                            style: TextStyle(
                                fontSize: 24, color: Colors.white)), // 文字样式
                        OutlinedButton(
                            onPressed: loadBalance, // 按钮按下时调用loadBalance函数
                            child: Text('获取余额')) // 按钮文本
                        ,
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 0), // 按钮尺寸尽可能大
                            backgroundColor: Colors.red), // 背景色为红色
                        onPressed:
                            _incrementBalance, // 按钮按下时调用_incrementBalance函数
                        child: Text("点击这里"), // 按钮文本
                      ))
                ],
              )),
        ));
  }
}
