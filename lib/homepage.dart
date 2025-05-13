import 'package:empetzapp/About.dart';
import 'package:empetzapp/Account.dart';
import 'package:empetzapp/Favorite.dart';
import 'package:empetzapp/contact.dart';
import 'package:empetzapp/buyer.dart';
import 'package:empetzapp/main.dart';
import 'package:empetzapp/seller.dart';
import 'package:flutter/material.dart';

class homegage extends StatefulWidget {
  const homegage({super.key});

  @override
  State<homegage> createState() => _homegageState();
}

class _homegageState extends State<homegage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
          length: 2,
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.amber,
                title: Text(
                  "HOME",
                  style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
              actions: [
                IconButton(
                  onPressed: (){
                    isDarkmode.value = !isDarkmode.value;
                  }, 
                icon: Icon(
                  isDarkmode.value ? Icons.dark_mode : Icons.light_mode,),
                color: Theme.of(context).iconTheme.color,
                ),
              ],
                // actions: [
                //   IconButton(
                //     icon: Icon(
                //       Icons.notifications,
                //       color: Colors.black,
                //     ),
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => Notifications()),
                //       );
                //     },
                //   ),
                // ],
                iconTheme: IconThemeData(color: Colors.black),
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(color: Colors.amber),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage("assets/person.jpg"),
                            radius: 50,
                          ),
                          Text(
                            "Manu",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    _buildItem(
                      icon: Icons.person,
                      title: "Account",
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Account()));
                      },
                    ),
                    _buildItem(
                      icon: Icons.favorite,
                      title: "Favorite",
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Favorite()));
                      },
                    ),
                    _buildItem(
                      icon: Icons.question_mark,
                      title: "About",
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => About()));
                      },
                    ),
                    _buildItem(
                      icon: Icons.contacts,
                      title: "Contact Us",
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Contact()));
                      },
                    )
                  ],
                ),
              ),
              body: Column(
                children: [
                  TabBar(tabs: [
                    Tab(
                      text: "BUYER",
                    ),
                    Tab(
                      text: "SELLER",
                    ),
                  ]),
                  Expanded(
                    child: TabBarView(children: [
                      Buyer(),
                      seller(),
                    ]),
                  )
                ],
              )));
  }

  _buildItem(
      {required IconData icon,
      required String title,
      required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
      minLeadingWidth: 5,
    );
  }
}
