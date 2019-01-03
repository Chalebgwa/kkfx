import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmfx/auth_provider.dart';
import 'package:tmfx/screens/payment.dart';
import 'chat.dart';
import 'package:tmfx/screens/library.dart';
import 'discussions.dart';
import 'package:tmfx/screens/store.dart';
import 'package:tmfx/screens/course.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Home extends StatefulWidget {

  final VoidCallback onSignOut;

  const Home({Key key,this.onSignOut}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  FirebaseUser user;
  String currentUserId;
  SharedPreferences prefs;

  void setValues() async {
    prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString("id");
  }

  @override
  void initState() {
    setValues();
  }

  void _signOut() async {
    try {
      AuthProvider.of(context).auth.signOut();
      widget.onSignOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text("Home"),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onPressed: _signOut)
          ],
        ),
        body: AnimatedBackground(
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                Tile(
                  icon: Icons.email,
                  text: "inbox",
                  page: ChatList(),
                ),
                Tile(
                  icon: Icons.store,
                  text: "store",
                  page: Store(),
                ),
                Tile(
                  icon: Icons.school,
                  text: "course",
                  page: Course(),
                ),
                Tile(
                    icon: Icons.picture_as_pdf,
                    text: "library",
                    page: BookList()),
                Tile(
                  icon: Icons.account_balance,
                  text: "payments",
                  page: Payments(),
                ),
                Tile(
                    icon: Icons.people_outline,
                    text: "discussions",
                    page: Discussions())
              ],
            ),
            vsync: this,
            behaviour: RacingLinesBehaviour(
                numLines: 7, direction: LineDirection.Btt)));
  }
}

class Tile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget page;
  const Tile({this.icon, this.text, this.page});

  @override
  Widget build(BuildContext context) {
    var radius = 32.0;
    double elevation = 4.0;

    return Card(
      elevation: elevation,
      color: Colors.white,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => this.page));
        },
        borderRadius: BorderRadius.circular(radius),
        splashColor: Colors.yellow,
        highlightColor: Colors.amberAccent,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  this.icon,
                  size: 40.0,
                  color: Colors.amber,
                ),
                Text(
                  this.text,
                  style: TextStyle(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
