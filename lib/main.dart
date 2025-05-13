import 'package:empetzapp/splash.dart';
import 'package:flutter/material.dart';

final ValueNotifier<bool> isDarkmode = ValueNotifier(false);

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkmode,
      builder: (context, Darkmode, child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: Darkmode? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: Myempetz(),
        );
      }
    );
  }
}