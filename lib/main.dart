import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/homeLayout.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/components/blocObserver.dart';

void main() {
  Bloc.observer = blocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeLayout(),
    );
  }
}
//done