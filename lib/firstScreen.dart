import 'package:flutter/material.dart';
import 'mapScreen.dart';
import 'reduxApp.dart';
import 'package:flutter_redux/flutter_redux.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color primary = Color.fromRGBO(162, 22, 91, 1);
  Color colorText = Color.fromRGBO(255, 255, 255, 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: primary,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    //   child: Container(
                    //     height: 250,
                    //     width: 250,
                    //     color: Colors.blueGrey,
                    //   ),
                    child: Image(
                      image: NetworkImage(
                          'https://initgrammers.com/wp-content/uploads/2019/02/Logo-IG.png'),
                      height: 250,
                      width: 250,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, right: 5),
                  child: Container(
                    width: 230,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      border: new Border.all(
                        color: colorText,
                        width: 1.0,
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Email address",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, right: 5),
                  child: Container(
                    width: 230,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      border: new Border.all(
                        color: colorText,
                        width: 1.0,
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment(0.5, 0),
                    child: new StoreConnector<int, String>(
                      converter: (store) => store.state.toString(),
                      builder: (context, count) {
                        return new Text(
                          "En el store: " + count,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Container(
                    width: 230,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.black,
                    ),
                    child: StoreConnector<int, VoidCallback>(
                      converter: (store) {
                        return () => store.dispatch(Actions.Increment);
                      },
                      builder: (context, callback) {
                        return MaterialButton(
                          onPressed: callback,
                          child: Text(
                            "Aumentar",
                            style: TextStyle(color: colorText),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Container(
                    width: 230,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.black,
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapScreen()),
                        );
                      },
                      child: Text(
                        "Siguiente",
                        style: TextStyle(color: colorText),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
