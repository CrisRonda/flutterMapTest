import 'package:flutter/material.dart';
import 'firstScreen.dart';
import 'reduxApp.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  //Cambiar el metodo y definir una variable que sirva de store 
  //reduxApp contiene el reducer y el actions
  final store = new Store<int>(counterReducer, initialState: 0);
  runApp(MyApp(
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  //Definicion del store dentro del la app 
  final Store<int> store;
  MyApp({
    this.store,
  });
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
      ),
    );
  }
}
