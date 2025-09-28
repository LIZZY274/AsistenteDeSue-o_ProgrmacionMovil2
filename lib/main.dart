import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/sleep_viewmodel.dart';
import 'view/sleep_tracker_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SleepViewModel()),
      ],
      child: MaterialApp(
        title: 'Asistente de Sueño Inteligente',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
        ),
        home: SleepTrackerView(),
      ),
    );
  }
}
